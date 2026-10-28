---
name: wiki-promote
description: Promotes valuable chat exchanges (Q&A pairs, architectural decisions, solved debugging problems) into persistent wiki pages or appends them to existing knowledge topics. (Karpathy's LLM-Wiki Promote Pattern).
---

# Wiki Promote Skill

This skill implements the **Query-to-Page Return Loop** of the LLM-Wiki pattern. When an insightful discussion, problem resolution, or synthesized explanation occurs in a chat session, this skill extracts and promotes it into a canonical wiki document in `data/wiki/pages/`.

## Inputs
- **Current Chat Session Context**: The recent assistant explanation/solution paired with the user's triggering inquiry.
- **Optional Target Slug**: If the user mentions an existing topic (e.g. "add this to docker-troubleshooting"), target that specific page.

## Execution Workflow

### 1. Proposal Phase (Review Before Write)
Present a structured promotion proposal before making changes:
```markdown
**Proposed Wiki Promotion:**
- **Target**: `NEW pages/<slug>.md` OR `APPEND pages/<existing-slug>.md`
- **Slug**: `<slug>`
- **Title**: `<H1 Title>`
- **Draft Summary**:
  [Concise explanation stripped of conversational filler]
- **Proposed [[wiki-links]]**: `[[topic-a]]`, `[[topic-b]]`
```

### 2. User Confirmation & Normalization
Once confirmed (or if explicitly requested with "save directly"):
- Create `data/wiki/pages/<slug>.md` or append an `### Promoted YYYY-MM-DD` section to an existing page.
- Clean conversational markers ("Sure!", "As mentioned earlier") and format as crisp technical documentation.
- Add reciprocal `[[links]]` and update `data/wiki/index.md` and `data/wiki/log.md`.
