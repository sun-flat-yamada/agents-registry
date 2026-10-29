---
name: registry-monthly-review
description: Monthly review of this agents registry. Checks Anthropic's official repositories (and ideas-only sources) for changes since the last review, decides per V-model slot whether anything is a real improvement, and opens a draft PR for a human to merge. Use when the monthly scheduled task fires or when asked to review the registry for updates.
---

# Registry Monthly Review

Keep each V-model slot holding the single best entry. Read `docs/v-model-skeleton.md` (slots, the six selection criteria, the replacement rule) and `registry.yml` (current entries and sources) before starting.

## Rules

- Open a pull request only when there is a concrete improvement. Do not open one just to record that nothing changed.
- Never merge. A human decides every merge.
- One best entry per slot. A new candidate replaces the current one only when it is clearly better on the criteria; a small gain is applied as an improvement to the current entry instead.
- Anthropic official repositories are the primary source. `worldflowai/everything-claude-code` (`role: ideas-only`) contributes ideas and techniques that still hold, never copied content.
- Vendored files stay verbatim: copy upstream content unchanged (agent files keep the local `NAME.agent.md` name).

## Procedure

1. **Collect changes.** Run `python3 scripts/check-upstream.py --output /tmp/upstream-report.md` and read the report.
2. **Vendored files.** For each file reported `changed` or `removed upstream`, read the upstream diff. Copy the new version verbatim, update its `commit` under `vendored:` in `registry.yml` and the commit list in `THIRD_PARTY_NOTICES.md`, and note what behavior changed. If a file was removed upstream, find its successor and treat it as a candidate (step 3).
3. **Changed or new upstream components.** For every component in the report's tables (a plugin, skill or file), decide whether it bears on a slot:
   - Read what changed (`git log -p` on the clone the script made, or the component's README).
   - Map it to a slot (V1-V8, X1, X2) or to none.
   - For a relevant one, compare it with the current entry on the six criteria. Record the comparison as a table with sources (URLs at the reviewed commit).
4. **Claude Code changelog.** Read the new `CHANGELOG.md` entries of `anthropics/claude-code` for features that change how a slot entry should work (skills, subagents, hooks, plugins, review or security tooling). Propose concrete edits to the affected in-house skills.
5. **GitHub Copilot CLI.** Check the Copilot CLI plugin reference (https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference) for format changes that would stop agents, skills or commands from loading, and fix the manifests if needed.
6. **Ideas-only sources.** If `everything-claude-code` has new commits, look only for techniques that are still valid and missing from the in-house skills.
7. **Apply.** Make the changes, then move each source's `reviewed_commit` to the HEAD you reviewed and set `last_reviewed` to today in `registry.yml`. Update `README.md`, `README.ja.md` and `archive/` (with a reason) when an entry is replaced.
8. **Verify.** Run `./scripts/sync-apm.sh` then `./scripts/sync-apm.sh --verify`, and `python3 scripts/security-audit.py --scanners builtin --fail-on high`. If Copilot CLI is installed, confirm the plugin's skills load (`copilot plugin install ./` then `copilot skill list`).
9. **Open a draft PR** titled `Monthly registry review YYYY-MM`. The body contains: a summary of decisions per slot (kept / improved / replaced), the comparison tables, what was skipped and why, and the upstream report. If no change is worth proposing, open no PR and report "no changes" with the reviewed HEADs.
