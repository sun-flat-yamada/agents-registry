---
name: library
description: Personal book journal and literature manager — tracks reading lists, enriches titles with metadata/covers via book APIs, logs verbatim reader impressions, and resurfaces past reading reflections.
---

# Personal Library & Reading Journal Skill

This skill acts as an intellectual companion for tracking books, reading goals, and reflections. It enriches book titles with authoritative bibliographic metadata and maintains a structured reading journal under `data/library/books/<slug>.md`.

## Data Storage
- **Book Records**: Stored as Markdown files at `data/library/books/<slug>.md`.
- **Reading Index**: `data/library/README.md` cataloging books by reading status (`Want to Read`, `Currently Reading`, `Finished`).

## Book Record Schema & Frontmatter

```markdown
---
title: Thinking, Fast and Slow
author: Daniel Kahneman
status: finished
rating: 5
isbn: 9780374533557
created: 2026-03-15
finished: 2026-04-02
---

# Thinking, Fast and Slow

![cover](https://books.google.com/books/content?id=...&printsec=frontcover&img=1)

## Synopsis
> A tour of the mind explaining the two systems that drive the way we think: System 1 (fast, intuitive, emotional) and System 2 (slower, more deliberative, logical).

## Reader Impressions & Key Takeaways
- Captured verbatim user quotes, highlights, and conceptual notes.
```

## Core Workflows

### 1. Add to Reading List
- Determine clean kebab-case ASCII slug.
- Query Google Books API (`https://www.googleapis.com/books/v1/volumes?q=intitle:<title>`) to harvest ISBN, author, thumbnail, and synopsis without requiring an API key.
- Save to `data/library/books/<slug>.md` and update index.

### 2. Capture Reader Impressions (On Finish)
- When the user mentions finishing a book, prompt for their authentic reaction ("What resonated most?").
- Append user reflections verbatim under `## Reader Impressions`.

### 3. Recall & Cross-Referencing
- Search existing book impressions when user explores related topics in conversations.
