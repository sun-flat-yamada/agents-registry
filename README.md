# Unified Agent & Skills Registry

[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin%20Ready-blueviolet.svg)](https://docs.claude.com)
[![Agent Package Manager](https://img.shields.io/badge/Microsoft%20APM-Multi--Harness-blue.svg)](https://github.com/microsoft/apm)
[![Agent Skills Standard](https://img.shields.io/badge/Agent%20Skills-Standard%20Compliant-brightgreen.svg)](https://github.com)
[![Security Audited](https://img.shields.io/badge/Security-Cisco%20%26%20NVIDIA%20Audited-success.svg)](docs/security-audit.md)
[![Harness Engineering](https://img.shields.io/badge/Harness%20Engineering-RHO%20Enabled-orange.svg)](docs/harness-engineering.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

本リポジトリは、AI エージェントおよびスキルのパッケージングにおけるデファクトスタンダード（**Claude Code Plugin 形式 & Agent Skills Standard**）を Master (Source of Truth) として採用し、**Microsoft APM (Agent Package Manager)** によるマルチハーネス配信（Claude Code, Cursor, Copilot, Gemini）を完全サポートするハイブリッド構成の Agent Registry / Template です。

最先端の **Harness Engineering (RHO)** による自律的自己診断・更新サイクル、および **Cisco & NVIDIA ツールによる強固なセキュリティ監査 CI/CD** を標準装備しています。

---

## 🏛️ アーキテクチャ構成

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                       Master (Source of Truth)                              │
│            Claude Code Plugin (.claude-plugin/plugin.json)                  │
│                     Agent Skills Standard (skills/*/SKILL.md)               │
└──────────────────────┬───────────────────────────────┬──────────────────────┘
                       │                               │
                       ▼                               ▼
       ┌───────────────────────────────┐ ┌───────────────────────────────┐
       │     Claude Code Ecosystem     │ │     Microsoft APM Deploy      │
       │  • /plugin install            │ │  • targets: claude, cursor,   │
       │  • /retrospective-harness     │ │    copilot, gemini            │
       │  • /update-harness            │ │  • scripts/sync-apm.ps1       │
       └───────────────────────────────┘ └───────────────────────────────┘
                       │                               │
                       └───────────────┬───────────────┘
                                       │
                                       ▼
       ┌───────────────────────────────────────────────────────────────┐
       │         Automated Security Auditing & CI/CD Pipeline          │
       │    • Cisco AI Skill Scanner + NVIDIA SkillSpector + Linter    │
       │    • Automatic incremental scan on skill/agent additions      │
       │    • SARIF 2.1.0 output to GitHub Code Scanning               │
       └───────────────────────────────────────────────────────────────┘
```

---

## ⚡ クイックスタート

### 1. Claude Code プラグインとして利用
```bash
/plugin install github:sun-flat-yamada/agents-registry
```

### 2. セキュリティ監査の実行 (ローカル)
新規スキルやエージェントの作成・修正時に脆弱性やプロンプトインジェクションを検査します：
```powershell
# Windows (PowerShell) - 変更・追加されたスキルのみ高速スキャン
powershell -ExecutionPolicy Bypass -File ./scripts/audit-security.ps1 -ChangedOnly
```
```bash
# Linux / macOS (Bash)
./scripts/audit-security.sh --changed-only
```

### 3. Master と .apm レイヤーの同期
```powershell
powershell -ExecutionPolicy Bypass -File ./scripts/sync-apm.ps1
```

---

## 📚 詳細ドキュメント (Docs)

機能ごとの詳細な手順・設定・アーキテクチャは `docs/` ディレクトリ配下に分類されています：

| ドキュメント | 概要 |
| :--- | :--- |
| [🛡️ **セキュリティ監査ガイド**](docs/security-audit.md) | Cisco AI Skill Scanner、NVIDIA SkillSpector、Built-in Linter の統合仕様、CLI リファレンス、およびスキル新規追加時の CI/CD 自動稼働パイプライン |
| [🧠 **Harness Engineering ガイド**](docs/harness-engineering.md) | Retrospective Harness Optimization (RHO) に基づくエージェント環境の自己診断・改善計画 (HIP) 策定・安全な自動更新サイクル |
| [🚀 **インストールとマルチハーネス配信**](docs/usage-and-deployment.md) | Claude Code での利用方法、Microsoft APM (`apm.yml`) によるマルチプラットフォーム配信、および Master レイヤー自動同期手順 |

---

## 🤖 登録エージェント一覧 (19 Agents)

本レジストリには、専門ドメインに特化した 19 のエージェント（`agents/*.md`）が収録されています：

### 🧠 Harness Engineering (自己診断・改善)
| エージェント | 説明 |
| :--- | :--- |
| [`retrospective-harness-agent`](agents/retrospective-harness-agent.md) | 過去セッション履歴やエラーログからボトルネックを診断し、Harness Improvement Plan (HIP) を策定する診断エージェント |
| [`update-harness-agent`](agents/update-harness-agent.md) | HIP 計画に基づき、Skills、Agents、Hooks、Rules をアトミックかつ安全に適用・更新する適用エージェント |

### 🛡️ Code Review Suite (コード品質・セキュリティ)
| エージェント | 説明 |
| :--- | :--- |
| [`code-reviewer`](agents/code-reviewer.md) | コード品質、セキュリティ、パフォーマンス、保守性を多角的にレビューするメインエージェント |
| [`code-review-orchestrator`](agents/code-review-orchestrator.md) | 4つの専門レビューエージェントを並列起動し、重複排除・重要度ソートされた統合レポートを生成 |
| [`reviewer-security`](agents/reviewer-security.md) | OWASP Top 10、脆弱性、入力検証、暗号化に特化したセキュリティ専門エージェント |
| [`reviewer-memory-safety`](agents/reviewer-memory-safety.md) | メモリ安全性、リソースリーク、並行性・スレッドセーフティに特化した専門エージェント |
| [`reviewer-style-quality`](agents/reviewer-style-quality.md) | クリーンコード、命名規則、デザインパターン、可読性に特化した専門エージェント |
| [`reviewer-effective`](agents/reviewer-effective.md) | Effective シリーズ（C++, C#, Java, Python 等）の言語別イディオム専門エージェント |

### 🏛️ Workspace & Knowledge Core (自己改善ワークスペース)
| エージェント | 説明 |
| :--- | :--- |
| [`workspace-agent`](agents/workspace-agent.md) | 『The Workspace Is the Self-Improving Agent』思想に基づく Wiki/Collection/Automation の自律運用エージェント |
| [`collection-architect`](agents/collection-architect.md) | コレクションスキーマ設計、データモデリング、整合性検証を担うアーキテクトエージェント |
| [`wiki-curator`](agents/wiki-curator.md) | ナレッジベースの構造化、ノートの昇格 (Promote)、リント、定期保守を担うキュレーターエージェント |

### 🎭 Specialized Roles & Personas (各種業務・専門ペルソナ)
| エージェント | 説明 |
| :--- | :--- |
| [`agent-personal`](agents/agent-personal.md) | 個人生産性向上、タスク整理、日々の意思決定を支援するパーソナルコンパニオン |
| [`agent-office`](agents/agent-office.md) | ビジネス文書作成、議事録要約、オフィスワークフローを支援するオフィスアシスタント |
| [`agent-guide`](agents/agent-guide.md) | システムやツールの使い方、オンボーディング、リファレンス案内を行うガイドエージェント |
| [`agent-artist`](agents/agent-artist.md) | クリエイティブ構想、プロンプト設計、ビジュアルアイディア創出を支援するクリエイター |
| [`agent-tutor`](agents/agent-tutor.md) | 段階的なカリキュラム設計、概念解説、理解度チェックを行う個別指導チューター |
| [`agent-storyteller`](agents/agent-storyteller.md) | 世界観構築、キャラクター設定、ナラティブ執筆を行うストーリーテラー |
| [`agent-accounting`](agents/agent-accounting.md) | 請求書・経費計算・帳簿データ整理を支援するアカウンティングエージェント |
| [`agent-investor`](agents/agent-investor.md) | ポートフォリオ分析・市場データ・財務仮説検証を支援するインベスターエージェント |

---

## 🛠️ 登録スキル一覧 (25 Skills)

全スキルは **Agent Skills Standard (`skills/<slug>/SKILL.md`)** に完全準拠しています：

### 🧠 Harness Engineering & Optimization (2)
- [`retrospective-harness`](skills/retrospective-harness/SKILL.md): エージェント実行履歴の自己診断と Harness Improvement Plan (HIP) の自動策定
- [`update-harness`](skills/update-harness/SKILL.md): 策定された HIP に基づく Skills / Agents / Hooks のアトミック更新と検証

### 🏛️ Workspace & Core Primitives (8)
- [`code-review`](skills/code-review/SKILL.md): 多言語対応コードレビューおよび Effective ルール適用
- [`string-helpers`](skills/string-helpers/SKILL.md): 大文字小文字変換、スラッグ化、パディング等の文字列操作ユーティリティ
- [`wiki-ingest`](skills/wiki-ingest/SKILL.md): 外部テキスト・Web ドキュメントの構造化取り込み
- [`wiki-promote`](skills/wiki-promote/SKILL.md): ノートの昇格、重要サマリー抽出、インデックス更新
- [`wiki-lint`](skills/wiki-lint/SKILL.md): リンク切れ、孤立ノート、タグ整合性の静的検証
- [`collection-builder`](skills/collection-builder/SKILL.md): JSON Schema 準拠コレクションの定義と検証
- [`meta-skill-manager`](skills/meta-skill-manager/SKILL.md): スキルメタデータ管理、依存関係チェック、登録支援
- [`automation-scheduler`](skills/automation-scheduler/SKILL.md): cron・タイマー・イベント駆動の自動化スケジューリング

### 🔧 Developer Tools & Environment (7)
- [`archive-shipped-plans`](skills/archive-shipped-plans/SKILL.md): 完了済み実装計画・ドキュメントのアーカイブとクリーンアップ
- [`e2e-live`](skills/e2e-live/SKILL.md): E2E ライブテストの実行およびログ検証
- [`make-e2e-live`](skills/make-e2e-live/SKILL.md): E2E ライブテストシナリオの生成とフィクスチャ構築
- [`setup-app`](skills/setup-app/SKILL.md): アプリケーション初期セットアップおよび依存関係解決
- [`setup-ollama-local`](skills/setup-ollama-local/SKILL.md): ローカル LLM (Ollama) 環境の構築とモデル設定
- [`setup-relay`](skills/setup-relay/SKILL.md): 通信リレーサーバー・MCP リレーの設定
- [`setup-wizard`](skills/setup-wizard/SKILL.md): 対話型オンボーディングウィザードの実行

### 💼 Domain & Productivity Presets (8)
- [`cooking-coach`](skills/cooking-coach/SKILL.md): 食材や栄養バランスに応じたレシピ提案と手順ガイド
- [`library`](skills/library/SKILL.md): 書籍・文献管理、読書ログ、引用メタデータ整理
- [`zenn-publisher`](skills/zenn-publisher/SKILL.md): 技術記事（Zenn 等）の執筆・フォーマット検証・公開支援
- [`presentation-deck`](skills/presentation-deck/SKILL.md): スライド構成案、プレゼンテーション用アウトライン生成
- [`storyteller`](skills/storyteller/SKILL.md): キャラクター設定、世界観構築、短編シナリオ執筆
- [`portfolio-tracker`](skills/portfolio-tracker/SKILL.md): 資産配分、ポートフォリオのリバランス・損益トラッキング
- [`billing-invoice`](skills/billing-invoice/SKILL.md): 請求データからの適格請求書・インボイスフォーマット生成
- [`edgar-sec-filings`](skills/edgar-sec-filings/SKILL.md): 米国 SEC EDGAR からの企業開示情報・財務データの検索・取得

---

## ⚡ コマンド (Commands)

| コマンド | ファイル | 説明 |
| :--- | :--- | :--- |
| `/explain` | [`commands/explain.md`](commands/explain.md) | 指定されたコードや概念の詳細解説 |
| `/code-review-subagent` | [`commands/code-review-subagent.md`](commands/code-review-subagent.md) | 専門サブエージェント群による多面的な並列コードレビュー |
| `/retrospective-harness` | [`commands/retrospective-harness.md`](commands/retrospective-harness.md) | ハーネス自己診断と改善計画 (HIP) 策定 |
| `/update-harness` | [`commands/update-harness.md`](commands/update-harness.md) | 改善計画 (HIP) に基づくハーネス自動更新 |

---

## 📂 リポジトリ構成概要

```text
/
├── skills/              # Agent Skills Standard 準拠スキル (Master)
├── agents/              # 役割特化エージェント・ペルソナ定義 (Master)
├── hooks/               # 決定論的ライフサイクルフック (hooks.json 等)
├── commands/            # スラッシュコマンド・再利用可能プロンプト
├── instructions/        # コーディング規約・リポジトリ共通ルール
├── contexts/            # アーキテクチャおよびプロジェクトコンテキスト
├── scripts/             # セキュリティ監査 & APM 同期スクリプト
├── docs/                # 詳細カテゴリ別技術ドキュメント
├── .claude-plugin/      # Claude Code プラグインマニフェスト (Master)
├── .github/workflows/   # CI/CD パイプライン (security-audit.yml, ci.yml)
├── .apm/                # APM 下位互換レイヤー (Master から自動生成)
└── apm.yml              # APM マルチターゲット設定ファイル
```

---

## 🤝 コミュニティと貢献 (Contributing)

- [貢献ガイドライン (CONTRIBUTING.md)](CONTRIBUTING.md)
- [行動規範 (CODE_OF_CONDUCT.md)](CODE_OF_CONDUCT.md)
- [ライセンス (LICENSE - MIT License)](LICENSE)
