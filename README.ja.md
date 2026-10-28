# Unified Agent & Skills Registry

[English](README.md) | [日本語](README.ja.md)

[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin%20Ready-blueviolet.svg)](https://docs.claude.com)
[![Agent Package Manager](https://img.shields.io/badge/Microsoft%20APM-Multi--Harness-blue.svg)](https://github.com/microsoft/apm)
[![Agent Skills Standard](https://img.shields.io/badge/Agent%20Skills-Standard%20Compliant-brightgreen.svg)](https://github.com)
[![Security Audited](https://img.shields.io/badge/Security-Cisco%20%26%20NVIDIA%20Audited-success.svg)](docs/security-audit.md)
[![Harness Engineering](https://img.shields.io/badge/Harness%20Engineering-RHO%20Enabled-orange.svg)](docs/harness-engineering.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sun.flat.yamada)

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
| [🧭 **V字モデル骨格と選定基準**](docs/v-model-skeleton.md) | 工程ごとの枠、選定基準、ベスト 1 つを入れ替えるルール。 |
| [🛡️ **セキュリティ監査ガイド**](docs/security-audit.md) | Cisco AI Skill Scanner、NVIDIA SkillSpector、Built-in Linter の統合仕様、CLI リファレンス、およびスキル新規追加時の CI/CD 自動稼働パイプライン |
| [🧠 **Harness Engineering ガイド**](docs/harness-engineering.md) | Retrospective Harness Optimization (RHO) に基づくエージェント環境の自己診断・改善計画 (HIP) 策定・安全な自動更新サイクル |
| [🚀 **インストールとマルチハーネス配信**](docs/usage-and-deployment.md) | Claude Code での利用方法、Microsoft APM (`apm.yml`) によるマルチプラットフォーム配信、および Master レイヤー自動同期手順 |

---

## 🧭 V字モデルの枠（工程ごとにベストを 1 つ）

本レジストリは、ソフトウェア開発の **V字モデルの工程ごとに、ベストを 1 つだけ**登録します。枠の定義・選定基準・入れ替えルールは [docs/v-model-skeleton.md](docs/v-model-skeleton.md)、現在の割当は [`registry.yml`](registry.yml) を参照してください。

| 枠 | 工程 | 現在の登録 | 状態 |
| :--- | :--- | :--- | :--- |
| V1 | 要求定義 | — | empty |
| V2 | 基本設計 | — | empty |
| V3 | 詳細設計 | — | empty |
| V4 | 実装 | — | empty |
| V5 | 単体テスト | — | empty |
| V6 | 結合テスト | — | empty |
| V7 | システムテスト | [`e2e-live`](skills/e2e-live/SKILL.md) | provisional |
| V8 | 受入テスト | — | empty |
| X1 | 横断：コードレビュー | [`code-review`](skills/code-review/SKILL.md)（オーケストレーター＋レビュアー群） | provisional |
| X2 | 横断：セキュリティ | [`reviewer-security`](agents/reviewer-security.md) | provisional |

*provisional* = 既存資産からの暫定割当で、公式ソースとの比較は未実施です。

### 🧠 レジストリ運用ツール（枠外）
- [`retrospective-harness`](skills/retrospective-harness/SKILL.md) / [`retrospective-harness-agent`](agents/retrospective-harness-agent.md): エージェント実行履歴の自己診断と Harness Improvement Plan (HIP) の策定。
- [`update-harness`](skills/update-harness/SKILL.md) / [`update-harness-agent`](agents/update-harness-agent.md): 承認済み HIP のアトミックな適用と検証。
- [`meta-skill-manager`](skills/meta-skill-manager/SKILL.md): Agent Skills の作成・更新・監査。

### 🗂️ 未割当
`archive-shipped-plans`、`make-e2e-live`、`setup-app`、`setup-ollama-local`、`string-helpers`、`explain` は開発関連ですが、まだ枠に割り当てていません。次の選定 PR で、枠への割当・既存エントリへの統合・退避のいずれかを決めます。

### 📦 退避済み（開発外）
個人・業務・専門ドメイン向けのエージェントとスキル（会計、投資、料理、個人 Wiki/ワークスペースなど）は [`archive/non-dev/`](archive/non-dev/README.md) に退避しました。内容はそのまま残していますが、配信対象からは外しています。

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
├── registry.yml         # V字モデルの枠ごとの登録内容（各枠ベスト 1 つ）
├── archive/non-dev/     # 退避した開発外のエージェント・スキル（配信対象外）
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

---

## 🤝 Contribution & Support

Contributions are welcome! If you find this tool useful, please consider supporting its development.

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sun.flat.yamada)
