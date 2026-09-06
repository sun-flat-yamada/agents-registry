---
name: wiki-ingest
description: Ingests an external source (workspace file path or pasted text) into a personal LLM-Wiki — generates a structured summary page, cross-references up to 5 related pages with [[wiki-links]], and appends an audit log entry. (Karpathy's LLM-Wiki Ingest Pattern).
---

# Wiki Ingest Skill

This skill implements the **Ingest** operation from the LLM-Wiki pattern (Karpathy's LLM-Wiki paradigm). It transforms external information into structured, interconnected, provenance-tracked wiki knowledge.

## Core Philosophy
- **The Workspace is the Knowledge Base**: Knowledge lives in `data/wiki/` as plain Markdown files.
- **Bi-directional Knowledge Linking**: Every newly ingested entity links to existing concepts using `[[slug]]` syntax.
- **Provenance by Design**: Every fact records its source path and timestamp.

## Inputs
Accepts one of:
1. **Workspace-relative file path**: e.g., `data/sources/...`, `artifacts/documents/...`. Must resolve within the workspace boundary.
2. **Pasted text**: Raw article text, notes, or research findings passed directly.

### Size Guardrail
If the input exceeds 100 KB (~25k tokens), prompt the user to summarize or split the content into sections before ingesting.

## Execution Workflow

### 1. Slug & Summary Generation
- Derive a kebab-case ASCII `<slug>` from the document title (e.g. `vector-databases-in-2026`).
- Create or update `data/wiki/pages/<slug>.md`:
  - Top header (`# <Title>`)
  - Overview / Executive Summary
  - Key Insights / Structured Concepts
  - Provenance footer (Source filename, ingest timestamp)

### 2. Cross-Referencing ([[Wiki-Links]])
- Scan `data/wiki/index.md` and existing pages under `data/wiki/pages/`.
- Identify 1 to 5 conceptually related existing pages.
- Embed `[[related-slug]]` links within the new page content.
- Update each referenced page to add a reciprocal backlink under a `## Related Topics` section.

### 3. Catalog & Audit Logging
- Register `<slug>` into `data/wiki/index.md` categorized by subject.
- Append a timestamped log entry to `data/wiki/log.md`:
  ```markdown
  - 2026-09-06: Ingested `[Title](pages/<slug>.md)` from `<source>`
  ```
