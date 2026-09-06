## Description
<!-- Provide a brief description of the changes introduced by this PR -->

## Type of Change
- [ ] 🐛 Bug fix (non-breaking change fixing an issue)
- [ ] ✨ New feature (new skill, agent persona, command, or rule)
- [ ] ♻️ Refactoring or optimization
- [ ] 📚 Documentation update

## Checklist
- [ ] Modified primitives are located under Source of Truth (`skills/`, `agents/`, `commands/`, `instructions/`, etc.)
- [ ] Updated `.claude-plugin/plugin.json` and `apm.yml` if new primitives were added
- [ ] Executed sync script (`./scripts/sync-apm.ps1` or `./scripts/sync-apm.sh`)
- [ ] Verified integrity via `./scripts/sync-apm.ps1 -VerifyOnly` (or `./scripts/sync-apm.sh --verify`)
