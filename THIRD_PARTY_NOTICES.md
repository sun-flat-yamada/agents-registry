# Third-Party Notices

Some files in this repository are copied from Anthropic's official repositories under the Apache License 2.0. They are kept **verbatim** (unmodified) so they can be refreshed from upstream; the pinned upstream commit for each is recorded in [`registry.yml`](registry.yml).

| Files in this repository | Upstream | License |
| :--- | :--- | :--- |
| `agents/code-explorer.md`, `agents/code-architect.md` | [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) `plugins/feature-dev/agents/` | Apache-2.0 ([licenses/anthropics-claude-plugins-official.LICENSE](licenses/anthropics-claude-plugins-official.LICENSE)) |
| `agents/code-simplifier.md` | anthropics/claude-plugins-official `plugins/code-simplifier/agents/` | Apache-2.0 |
| `agents/pr-test-analyzer.md`, `agents/type-design-analyzer.md` | anthropics/claude-plugins-official `plugins/pr-review-toolkit/agents/` | Apache-2.0 |
| `commands/code-review.md` | anthropics/claude-plugins-official `plugins/code-review/commands/` | Apache-2.0 |
| `skills/webapp-testing/` | [anthropics/skills](https://github.com/anthropics/skills) `skills/webapp-testing/` | Apache-2.0 ([skills/webapp-testing/LICENSE.txt](skills/webapp-testing/LICENSE.txt)) |

Upstream commits at the time of copying (2026-10-28):

- anthropics/claude-plugins-official: `f8c5e7a1dcb71b10cb74586224b5401f3de5db28`
- anthropics/skills: `ca45fc496a3436251f191354091d557da31c15b5`

Ideas (not text) were also taken from [worldflowai/everything-claude-code](https://github.com/worldflowai/everything-claude-code) (MIT) for the in-house skills `requirements-definition`, `architecture-design`, `implementation-loop` and `unit-test-tdd`; see `ideas_from` in `registry.yml`.

All other files are under this repository's [MIT License](LICENSE).
