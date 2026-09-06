#!/usr/bin/env python3
"""
Agent & Skill Security Audit Orchestrator
Integrates Cisco AI Skill Scanner, NVIDIA SkillSpector, and Built-in Security Linters.
"""

import argparse
import datetime
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

# Ensure UTF-8 output across Windows and non-UTF-8 console encodings
if hasattr(sys.stdout, "reconfigure"):
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

SEVERITY_LEVELS = {"critical": 4, "high": 3, "medium": 2, "low": 1, "info": 0}

# Common dangerous patterns for built-in security auditing
DANGEROUS_PATTERNS = [
    (
        r"(?:sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{36}|AKIA[0-9A-Z]{16})",
        "hardcoded-credential",
        "high",
        "Potential hardcoded API token or credential secret detected.",
    ),
    (
        r"(?:curl|wget)\s+[^\n|&;]+\|\s*(?:bash|sh|zsh)",
        "dangerous-remote-execution",
        "high",
        "Piping remote URL content directly into a shell interpreter.",
    ),
    (
        r"rm\s+-rf\s+/(?:\s|$)",
        "destructive-filesystem-command",
        "critical",
        "Destructive recursive deletion of filesystem root.",
    ),
    (
        r"(?:ignore\s+all\s+previous\s+instructions|system\s+override\s+prompt|bypass\s+all\s+guardrails)",
        "prompt-injection-marker",
        "high",
        "Suspected prompt injection or jailbreak instruction sequence.",
    ),
    (
        r"(?:eval|exec)\s*\(\s*(?:request|input|sys\.argv)",
        "arbitrary-code-execution",
        "high",
        "Untrusted input passed to dynamic evaluation sink (eval/exec).",
    ),
    (
        r"https?://(?:webhook\.site|pastebin\.com|requestbin\.net)/[a-zA-Z0-9_\-]+",
        "data-exfiltration-sink",
        "medium",
        "Suspicious public webhook or pastebin endpoint referenced.",
    ),
]


class SecurityAuditor:
    def __init__(
        self,
        root_dir: Path,
        scanners: List[str],
        fail_on: str = "high",
        strict: bool = False,
        verbose: bool = False,
    ):
        self.root_dir = root_dir.resolve()
        self.scanners = scanners
        self.fail_on = fail_on.lower()
        self.strict = strict
        self.verbose = verbose
        self.threshold_score = SEVERITY_LEVELS.get(self.fail_on, 3)

        # External tool availability
        self.cisco_available = shutil.which("skill-scanner") is not None
        self.nvidia_available = shutil.which("skillspector") is not None

    def find_all_targets(self) -> List[Dict[str, Any]]:
        """Finds all skills and agent definitions in the registry."""
        targets = []

        # 1. Skills
        skills_dir = self.root_dir / "skills"
        if skills_dir.exists() and skills_dir.is_dir():
            for item in sorted(skills_dir.iterdir()):
                if item.is_dir():
                    skill_md = item / "SKILL.md"
                    targets.append(
                        {
                            "name": item.name,
                            "type": "skill",
                            "path": item,
                            "entrypoint": skill_md if skill_md.exists() else item,
                        }
                    )

        # 2. Agents
        agents_dir = self.root_dir / "agents"
        if agents_dir.exists() and agents_dir.is_dir():
            for item in sorted(agents_dir.glob("*.md")):
                targets.append(
                    {
                        "name": item.stem,
                        "type": "agent",
                        "path": item,
                        "entrypoint": item,
                    }
                )

        return targets

    def find_changed_targets(self, base_ref: str = "HEAD~1") -> List[Dict[str, Any]]:
        """Finds only skills and agents added or modified compared to base_ref or working tree."""
        all_targets = self.find_all_targets()
        changed_paths = set()

        # Try git diff against base_ref
        try:
            cmd = ["git", "diff", "--name-only", "--diff-filter=d", base_ref, "HEAD"]
            res = subprocess.run(cmd, cwd=self.root_dir, capture_output=True, text=True, check=False)
            if res.returncode == 0 and res.stdout.strip():
                for line in res.stdout.strip().splitlines():
                    changed_paths.add(Path(line.strip()).as_posix())
        except Exception:
            pass

        # Also check unstaged or untracked changes
        try:
            cmd = ["git", "status", "--porcelain"]
            res = subprocess.run(cmd, cwd=self.root_dir, capture_output=True, text=True, check=False)
            if res.returncode == 0 and res.stdout.strip():
                for line in res.stdout.strip().splitlines():
                    parts = line.strip().split(maxsplit=1)
                    if len(parts) == 2:
                        changed_paths.add(Path(parts[1]).as_posix())
        except Exception:
            pass

        if not changed_paths:
            # Fallback to all targets if no diff detected or not a git repo
            if self.verbose:
                print("No git diff detected; defaulting to full scan.")
            return all_targets

        filtered = []
        for target in all_targets:
            rel_target = target["path"].relative_to(self.root_dir).as_posix()
            if any(cp == rel_target or cp.startswith(rel_target + "/") for cp in changed_paths):
                filtered.append(target)

        return filtered

    def run_builtin_audit(self, target: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Runs fast static heuristic analysis and schema verification."""
        findings = []
        target_path: Path = target["path"]
        files_to_check = []

        if target_path.is_file():
            files_to_check.append(target_path)
        elif target_path.is_dir():
            for root, _, files in os.walk(target_path):
                for f in files:
                    if f.endswith((".md", ".txt", ".json", ".yaml", ".yml", ".sh", ".py", ".ps1")):
                        files_to_check.append(Path(root) / f)

        for file_path in files_to_check:
            try:
                content = file_path.read_text(encoding="utf-8", errors="ignore")
            except Exception as e:
                findings.append(
                    {
                        "scanner": "builtin",
                        "rule_id": "file-read-error",
                        "severity": "low",
                        "message": f"Could not read file {file_path.name}: {e}",
                        "file": str(file_path.relative_to(self.root_dir)),
                        "line": 1,
                    }
                )
                continue

            rel_file = str(file_path.relative_to(self.root_dir))

            # Check markdown frontmatter for agents and SKILL.md
            if file_path.name == "SKILL.md" or target["type"] == "agent":
                if not content.startswith("---"):
                    findings.append(
                        {
                            "scanner": "builtin",
                            "rule_id": "missing-frontmatter",
                            "severity": "medium",
                            "message": f"{file_path.name} is missing frontmatter metadata delimiter ('---').",
                            "file": rel_file,
                            "line": 1,
                        }
                    )
                else:
                    # Check description in frontmatter
                    fm_match = re.search(r"^---\s*\n(.*?)\n---", content, re.DOTALL)
                    if fm_match:
                        fm_text = fm_match.group(1)
                        if "description:" not in fm_text:
                            findings.append(
                                {
                                    "scanner": "builtin",
                                    "rule_id": "missing-description",
                                    "severity": "low",
                                    "message": f"{file_path.name} frontmatter lacks a 'description' field.",
                                    "file": rel_file,
                                    "line": 1,
                                }
                            )

            # Check dangerous patterns
            for pattern, rule_id, severity, desc in DANGEROUS_PATTERNS:
                for line_idx, line in enumerate(content.splitlines(), start=1):
                    if re.search(pattern, line, re.IGNORECASE):
                        findings.append(
                            {
                                "scanner": "builtin",
                                "rule_id": rule_id,
                                "severity": severity,
                                "message": f"{desc} (Match: {line.strip()[:60]}...)",
                                "file": rel_file,
                                "line": line_idx,
                            }
                        )

        return findings

    def run_cisco_scanner(self, target: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Invokes Cisco AI Skill Scanner (skill-scanner)."""
        findings = []
        if not self.cisco_available:
            return findings

        scan_path = str(target["path"])
        cmd = [
            "skill-scanner",
            "scan",
            scan_path,
            "--lenient",
            "--format",
            "json",
        ]

        try:
            res = subprocess.run(cmd, cwd=self.root_dir, capture_output=True, text=True, timeout=60)
            output = res.stdout.strip()
            if output:
                try:
                    data = json.loads(output)
                    # Parse standard Cisco Skill Scanner findings
                    raw_findings = data.get("findings", [])
                    for item in raw_findings:
                        findings.append(
                            {
                                "scanner": "cisco-skill-scanner",
                                "rule_id": item.get("rule_id", "cisco-finding"),
                                "severity": item.get("severity", "medium").lower(),
                                "message": item.get("description") or item.get("message", "Cisco security finding"),
                                "file": item.get("file", str(target["path"].relative_to(self.root_dir))),
                                "line": item.get("line", 1),
                            }
                        )
                except json.JSONDecodeError:
                    if self.verbose:
                        print(f"Cisco scanner output was not JSON for {target['name']}: {output[:200]}")
        except Exception as e:
            if self.verbose:
                print(f"Error running Cisco scanner on {target['name']}: {e}")

        return findings

    def run_nvidia_skillspector(self, target: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Invokes NVIDIA SkillSpector (skillspector)."""
        findings = []
        if not self.nvidia_available:
            return findings

        scan_path = str(target["path"])
        temp_out = self.root_dir / f".skillspector_tmp_{target['name']}.json"

        cmd = [
            "skillspector",
            "scan",
            scan_path,
            "--no-llm",
            "--format",
            "json",
            "--output",
            str(temp_out),
        ]

        try:
            subprocess.run(cmd, cwd=self.root_dir, capture_output=True, text=True, timeout=60)
            if temp_out.exists():
                data = json.loads(temp_out.read_text(encoding="utf-8"))
                temp_out.unlink(missing_ok=True)
                raw_findings = data.get("findings", [])
                for item in raw_findings:
                    findings.append(
                        {
                            "scanner": "nvidia-skillspector",
                            "rule_id": item.get("id") or item.get("rule_id", "nvidia-finding"),
                            "severity": item.get("severity", "medium").lower(),
                            "message": item.get("message") or item.get("description", "NVIDIA SkillSpector finding"),
                            "file": item.get("file", str(target["path"].relative_to(self.root_dir))),
                            "line": item.get("line", 1),
                        }
                    )
        except Exception as e:
            if self.verbose:
                print(f"Error running NVIDIA SkillSpector on {target['name']}: {e}")
            temp_out.unlink(missing_ok=True)

        return findings

    def audit_target(self, target: Dict[str, Any]) -> Dict[str, Any]:
        """Audits a single skill or agent with selected scanners."""
        target_findings: List[Dict[str, Any]] = []

        if "builtin" in self.scanners or "all" in self.scanners:
            target_findings.extend(self.run_builtin_audit(target))

        if "cisco" in self.scanners or "all" in self.scanners:
            target_findings.extend(self.run_cisco_scanner(target))

        if "nvidia" in self.scanners or "all" in self.scanners:
            target_findings.extend(self.run_nvidia_skillspector(target))

        max_score = 0
        for f in target_findings:
            score = SEVERITY_LEVELS.get(f.get("severity", "low"), 1)
            if score > max_score:
                max_score = score

        status = "PASSED"
        if max_score >= self.threshold_score:
            status = "FAILED"
        elif max_score > 0:
            status = "WARNING" if not self.strict else "FAILED"

        return {
            "name": target["name"],
            "type": target["type"],
            "path": str(target["path"].relative_to(self.root_dir)),
            "status": status,
            "max_severity": [k for k, v in SEVERITY_LEVELS.items() if v == max_score][0] if max_score > 0 else "clean",
            "findings": target_findings,
        }

    def generate_sarif(self, audit_results: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Generates standard SARIF 2.1.0 output for GitHub Code Scanning integration."""
        rules_map = {}
        sarif_results = []

        for res in audit_results:
            for f in res["findings"]:
                rule_id = f["rule_id"]
                if rule_id not in rules_map:
                    level = "error" if f["severity"] in ["critical", "high"] else "warning"
                    rules_map[rule_id] = {
                        "id": rule_id,
                        "name": rule_id.replace("-", " ").title(),
                        "shortDescription": {"text": f["message"][:100]},
                        "defaultConfiguration": {"level": level},
                    }

                sarif_level = "error" if f["severity"] in ["critical", "high"] else "warning"
                sarif_results.append(
                    {
                        "ruleId": rule_id,
                        "level": sarif_level,
                        "message": {"text": f"{f['scanner'].upper()}: {f['message']}"},
                        "locations": [
                            {
                                "physicalLocation": {
                                    "artifactLocation": {"uri": f["file"].replace("\\", "/")},
                                    "region": {"startLine": f["line"]},
                                }
                            }
                        ],
                    }
                )

        sarif = {
            "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json",
            "version": "2.1.0",
            "runs": [
                {
                    "tool": {
                        "driver": {
                            "name": "Agent-Registry-Security-Auditor",
                            "informationUri": "https://github.com/cisco-ai-defense/skill-scanner",
                            "semanticVersion": "1.0.0",
                            "rules": list(rules_map.values()),
                        }
                    },
                    "results": sarif_results,
                }
            ],
        }
        return sarif

    def generate_markdown(self, audit_results: List[Dict[str, Any]]) -> str:
        """Generates formatted GitHub PR / Step Summary markdown."""
        lines = []
        lines.append("# 🛡️ Skills & Agent Security Audit Report\n")
        lines.append(f"- **Scan Timestamp**: `{datetime.datetime.now(datetime.timezone.utc).isoformat()}`")
        lines.append(f"- **Cisco Skill Scanner Available**: `{'✓ Yes' if self.cisco_available else '⚠️ Not installed (Run scripts/requirements-security.txt)'}`")
        lines.append(f"- **NVIDIA SkillSpector Available**: `{'✓ Yes' if self.nvidia_available else '⚠️ Not installed (Run scripts/requirements-security.txt)'}`")
        lines.append(f"- **Policy Threshold**: Fail on `{self.fail_on.upper()}` or higher\n")

        total = len(audit_results)
        passed = sum(1 for r in audit_results if r["status"] == "PASSED")
        warnings = sum(1 for r in audit_results if r["status"] == "WARNING")
        failed = sum(1 for r in audit_results if r["status"] == "FAILED")

        lines.append("### Summary")
        lines.append(f"| Total Assets | Passed | Warnings | Failed |")
        lines.append(f"| :--- | :--- | :--- | :--- |")
        lines.append(f"| **{total}** | 🟢 {passed} | 🟡 {warnings} | 🔴 {failed} |\n")

        lines.append("### Detailed Results")
        lines.append("| Target | Type | Status | Max Severity | Findings Count |")
        lines.append("| :--- | :--- | :--- | :--- | :--- |")

        for r in audit_results:
            icon = "🟢" if r["status"] == "PASSED" else ("🟡" if r["status"] == "WARNING" else "🔴")
            lines.append(f"| `{r['name']}` | {r['type']} | {icon} {r['status']} | {r['max_severity']} | {len(r['findings'])} |")

        findings_exist = any(r["findings"] for r in audit_results)
        if findings_exist:
            lines.append("\n### Security Findings Breakdown\n")
            for r in audit_results:
                if r["findings"]:
                    lines.append(f"#### `{r['name']}` ({r['path']})")
                    for f in r["findings"]:
                        sev_badge = f"**[{f['severity'].upper()}]**"
                        lines.append(f"- {sev_badge} `{f['scanner']}`: {f['message']} (`{f['file']}:{f['line']}`)")
                    lines.append("")

        return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Security Audit Runner for Agent Skills and Personas.")
    parser.add_argument("--target", type=str, help="Specific skill or agent path to scan.")
    parser.add_argument("--changed-only", action="store_true", help="Scan only files modified or added in git.")
    parser.add_argument(
        "--base-ref",
        type=str,
        default="origin/main",
        help="Git base reference for --changed-only (default: origin/main).",
    )
    parser.add_argument(
        "--scanners",
        nargs="+",
        choices=["cisco", "nvidia", "builtin", "all"],
        default=["all"],
        help="Security scanners to execute.",
    )
    parser.add_argument(
        "--fail-on",
        choices=["critical", "high", "medium", "low", "any"],
        default="high",
        help="Minimum severity level that triggers exit failure (default: high).",
    )
    parser.add_argument("--strict", action="store_true", help="Fail build on any warning or low finding.")
    parser.add_argument("--output-json", type=str, help="Filepath to write JSON audit report.")
    parser.add_argument("--output-markdown", type=str, help="Filepath to write Markdown audit report.")
    parser.add_argument("--output-sarif", type=str, help="Filepath to write SARIF 2.1.0 report for GitHub Security.")
    parser.add_argument("--verbose", action="store_true", help="Enable verbose scanner debug logs.")

    args = parser.parse_args()

    root_dir = Path(__file__).resolve().parent.parent
    auditor = SecurityAuditor(
        root_dir=root_dir,
        scanners=args.scanners,
        fail_on=args.fail_on,
        strict=args.strict,
        verbose=args.verbose,
    )

    print("==================================================")
    print("  AI Agent & Skills Security Audit Orchestrator   ")
    print("  Engines: Cisco AI Defense + NVIDIA SkillSpector ")
    print("==================================================")
    print(f"Root: {root_dir}")
    print(f"Cisco Scanner: {'✓ Detected' if auditor.cisco_available else '⚠️ Not installed in current PATH'}")
    print(f"NVIDIA SkillSpector: {'✓ Detected' if auditor.nvidia_available else '⚠️ Not installed in current PATH'}")
    print(f"Fail Threshold: {args.fail_on.upper()} (Strict: {args.strict})\n")

    # Determine targets
    if args.target:
        target_path = Path(args.target)
        if not target_path.is_absolute():
            target_path = (root_dir / target_path).resolve()
        target_type = "skill" if target_path.is_dir() or "skills" in str(target_path) else "agent"
        target_name = target_path.stem if target_type == "agent" else target_path.name
        targets = [
            {
                "name": target_name,
                "type": target_type,
                "path": target_path,
                "entrypoint": target_path,
            }
        ]
    elif args.changed_only:
        targets = auditor.find_changed_targets(base_ref=args.base_ref)
        print(f"Running incremental audit on {len(targets)} changed asset(s)...")
    else:
        targets = auditor.find_all_targets()
        print(f"Running full registry audit on {len(targets)} asset(s)...")

    if not targets:
        print("No skill or agent targets found to scan. Exiting.")
        sys.exit(0)

    results = []
    has_failure = False

    for target in targets:
        res = auditor.audit_target(target)
        results.append(res)
        status_symbol = "✓" if res["status"] == "PASSED" else ("!" if res["status"] == "WARNING" else "✗")
        print(f"[{status_symbol}] {res['type'].upper()}: {res['name']} -> {res['status']} ({len(res['findings'])} findings)")

        if res["findings"] and args.verbose:
            for f in res["findings"]:
                print(f"    - [{f['severity'].upper()}] ({f['scanner']}) {f['message']} ({f['file']}:{f['line']})")

        if res["status"] == "FAILED":
            has_failure = True

    # Output exports
    if args.output_json:
        out_p = Path(args.output_json)
        out_p.parent.mkdir(parents=True, exist_ok=True)
        out_p.write_text(json.dumps(results, indent=2), encoding="utf-8")
        print(f"\nSaved JSON report to: {out_p}")

    markdown_report = auditor.generate_markdown(results)
    if args.output_markdown:
        out_m = Path(args.output_markdown)
        out_m.parent.mkdir(parents=True, exist_ok=True)
        out_m.write_text(markdown_report, encoding="utf-8")
        print(f"Saved Markdown report to: {out_m}")

    if args.output_sarif:
        sarif_data = auditor.generate_sarif(results)
        out_s = Path(args.output_sarif)
        out_s.parent.mkdir(parents=True, exist_ok=True)
        out_s.write_text(json.dumps(sarif_data, indent=2), encoding="utf-8")
        print(f"Saved SARIF report to: {out_s}")

    print("\n==================================================")
    if has_failure:
        print("❌ SECURITY AUDIT FAILED: Vulnerabilities found exceeding threshold!")
        print("==================================================")
        sys.exit(1)
    else:
        print("✅ SECURITY AUDIT PASSED: All scanned assets meet security standards.")
        print("==================================================")
        sys.exit(0)


if __name__ == "__main__":
    main()
