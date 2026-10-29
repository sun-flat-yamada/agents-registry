#!/usr/bin/env python3
"""
Upstream Change Report for the monthly registry review.

Reads `upstream_sources` and `vendored` from registry.yml, clones each upstream
repository (blobless), and writes a Markdown report of:
  1. vendored files that differ from upstream HEAD (or were removed upstream);
  2. what changed under each source's watch paths since `reviewed_commit`,
     grouped by top-level component (plugin / skill / file).

The report is input for a human-reviewed PR. This script never edits the
registry itself.
"""

import argparse
import filecmp
import subprocess
import sys
import tempfile
from collections import defaultdict
from pathlib import Path
from typing import Dict, List, Optional

try:
    import yaml
except ImportError:
    sys.exit("PyYAML is required: pip install pyyaml")

ROOT_DIR = Path(__file__).resolve().parent.parent


def git(args: List[str], cwd: Optional[Path] = None) -> str:
    res = subprocess.run(["git", *args], cwd=cwd, capture_output=True, text=True, check=True)
    return res.stdout.strip()


def clone(repo: str, dest: Path) -> Path:
    target = dest / repo.replace("/", "__")
    if not target.exists():
        git(["clone", "--quiet", "--filter=blob:none", f"https://github.com/{repo}.git", str(target)])
    return target


def component_of(path: str, watch: str) -> str:
    """plugins/feature-dev/agents/x.md under 'plugins/' -> 'plugins/feature-dev'."""
    if not watch.endswith("/"):
        return path
    rest = path[len(watch):]
    return watch + rest.split("/", 1)[0]


def changes_since(repo_dir: Path, since: Optional[str], watch: List[str]) -> Dict[str, Dict[str, int]]:
    if since:
        out = git(["diff", "--name-status", f"{since}..HEAD", "--", *watch], cwd=repo_dir)
    else:
        # No previous review: list the latest 30 days of commits touching the watch paths.
        out = git(["log", "--since=30.days", "--name-status", "--format=", "--", *watch], cwd=repo_dir)
    summary: Dict[str, Dict[str, int]] = defaultdict(lambda: defaultdict(int))
    for line in out.splitlines():
        parts = line.split("\t")
        if len(parts) < 2:
            continue
        status, path = parts[0][0], parts[-1]
        w = next((w for w in watch if path.startswith(w.rstrip("/"))), watch[0])
        summary[component_of(path, w)][status] += 1
    return summary


def compare_vendored(entry: dict, repo_dir: Path) -> str:
    local = ROOT_DIR / entry["local"]
    upstream = repo_dir / entry["path"]
    if not upstream.exists():
        return "removed upstream"
    if local.is_dir():
        cmp = filecmp.dircmp(local, upstream, ignore=[".git"])
        diffs = cmp.diff_files + cmp.left_only + cmp.right_only
        for sub in cmp.subdirs.values():
            diffs += sub.diff_files + sub.left_only + sub.right_only
        return "unchanged" if not diffs else f"changed ({', '.join(sorted(diffs))})"
    return "unchanged" if filecmp.cmp(local, upstream, shallow=False) else "changed"


def build_report(registry: dict, workdir: Path) -> str:
    lines = ["# Upstream Change Report", ""]
    repo_dirs: Dict[str, Path] = {}
    for src in registry.get("upstream_sources", []):
        repo_dirs[src["repo"]] = clone(src["repo"], workdir)

    lines += ["## 1. Vendored files", "", "| Local | Upstream | Status |", "| :--- | :--- | :--- |"]
    for entry in registry.get("vendored", []):
        repo_dir = repo_dirs.get(entry["repo"]) or clone(entry["repo"], workdir)
        status = compare_vendored(entry, repo_dir)
        lines.append(f"| `{entry['local']}` | {entry['repo']} `{entry['path']}` | {status} |")
    lines.append("")

    lines += ["## 2. Changes under watched paths", ""]
    for src in registry.get("upstream_sources", []):
        repo_dir = repo_dirs[src["repo"]]
        head = git(["rev-parse", "HEAD"], cwd=repo_dir)
        date = git(["log", "-1", "--format=%cs"], cwd=repo_dir)
        since = src.get("reviewed_commit")
        span = f"`{since[:12]}`..`{head[:12]}`" if since else f"last 30 days up to `{head[:12]}`"
        lines += [f"### {src['repo']} ({src.get('role', 'primary')})", "",
                  f"- HEAD: `{head}` ({date})", f"- Range: {span}", ""]
        summary = changes_since(repo_dir, since, src["watch"])
        if not summary:
            lines += ["No changes.", ""]
            continue
        lines += ["| Component | Added | Modified | Deleted | Renamed |", "| :--- | ---: | ---: | ---: | ---: |"]
        for comp in sorted(summary):
            c = summary[comp]
            lines.append(f"| `{comp}` | {c.get('A', 0)} | {c.get('M', 0)} | {c.get('D', 0)} | {c.get('R', 0)} |")
        lines.append("")
    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description="Report upstream changes for the monthly registry review.")
    parser.add_argument("--registry", default=str(ROOT_DIR / "registry.yml"))
    parser.add_argument("--output", help="Write the Markdown report here instead of stdout.")
    parser.add_argument("--workdir", help="Directory for upstream clones (default: a temporary directory).")
    args = parser.parse_args()

    with open(args.registry, encoding="utf-8") as fp:
        registry = yaml.safe_load(fp)

    with tempfile.TemporaryDirectory() as tmp:
        workdir = Path(args.workdir) if args.workdir else Path(tmp)
        workdir.mkdir(parents=True, exist_ok=True)
        report = build_report(registry, workdir)

    if args.output:
        Path(args.output).write_text(report + "\n", encoding="utf-8")
    else:
        print(report)


if __name__ == "__main__":
    main()
