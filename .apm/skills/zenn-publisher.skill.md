---
name: zenn-publisher
description: Authors and manages technical blog articles for Zenn (or markdown publishing platforms) — scaffolds Zenn projects (`github/zenn/`), distills engineering sessions into structured articles (`articles/<slug>.md`), and prepares Git commits.
---

# Zenn Article Publisher Skill

This skill automates drafting, structuring, and formatting engineering write-ups into publication-ready Markdown articles adhering to the official Zenn CLI specification.

## Directory Structure & Conventions
- **Zenn Repository Path**: `github/zenn/`
- **Article Files**: `github/zenn/articles/<slug>.md`
- **Idempotency**: If `github/zenn/articles/` exists, the project is already initialized.

## Article Schema & Frontmatter

```markdown
---
title: "Agent Skills Standard によるエージェント環境のモジュール化"
emoji: "🤖"
type: "tech" # tech or idea
topics: ["ai", "claude", "architecture", "automation"]
published: false
---

## はじめに
本記事では、AI エージェントの実行環境（Harness）を自己進化させるアーキテクチャについて解説します。

## 課題と背景
...

## 実装手順
...

## まとめ
...
```

## Core Workflows

### 1. Initialize Zenn Workspace (Idempotent)
If `github/zenn/` does not exist:
```bash
mkdir -p github/zenn
cd github/zenn && npm init --yes && npm install zenn-cli && npx zenn init
```

### 2. Distill Conversation into an Article
- Transform recent debugging sessions, architecture decisions, or benchmark results into a clear technical narrative.
- Generate a 14-character alphanumeric slug (e.g. `a1b2c3d4e5f6g7`) or kebab-case slug.
- Select fitting emoji and topics.
- Save as `github/zenn/articles/<slug>.md` with `published: false` for author review.
