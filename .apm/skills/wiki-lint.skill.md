---
name: wiki-lint
description: Audits personal LLM-Wiki health (Karpathy's LLM-Wiki Lint Pattern) — detects broken [[wiki-links]], orphan pages, missing image assets, conflicting assertions across documents, and tag drift.
schedule: interval 168h
---

# Wiki Lint Skill

This skill implements the **Lint & Health Audit** operation from the LLM-Wiki pattern. It periodically scans the `data/wiki/` directory to prevent knowledge degradation, dead links, and factual contradictions.

## Scope of Inspection

### 1. Structural Checks (Deterministic)
- **Broken [[links]]**: Wiki-links targeting pages that do not exist under `data/wiki/pages/`.
- **Orphan Pages**: Documents that have zero inbound backlinks from other pages or `index.md`.
- **Missing File References**: Image `![](path)` or attachment links pointing to deleted/moved files.
- **Index Synchronization**: Verify that every page file is cataloged in `data/wiki/index.md`.

### 2. Semantic Checks (LLM Deep Lint)
- **Contradiction Detection**: Conflicting factual assertions between different topic documents.
- **Stale Claims**: Time-sensitive statements that have been superseded by newer entries.
- **Stub Detection**: Pages with less than 3 sentences that require fleshing out or merging.

## Execution Workflow

1. Scan all files in `data/wiki/pages/` and parse `data/wiki/index.md`.
2. Build an in-memory graph of all nodes (`pages`) and edges (`[[links]]`).
3. Compile a concise audit report:
   - If clean: Output a 1-line confirmation: `Wiki is healthy (N pages verified).`
   - If issues found: Group findings into `Broken Links`, `Orphans`, and `Inconsistencies` with exact file paths and suggested remediation.
4. Prompt the user for approval before applying any automated fixes.
