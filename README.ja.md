# Unified Agent & Skills Registry

[English](README.md) | [日本語](README.ja.md)

[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin%20Ready-blueviolet.svg)](https://docs.claude.com)
[![GitHub Copilot CLI](https://img.shields.io/badge/GitHub%20Copilot%20CLI-Supported-blue.svg)](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-marketplace)
[![Agent Skills Standard](https://img.shields.io/badge/Agent%20Skills-Standard%20Compliant-brightgreen.svg)](https://github.com)
[![Security Audited](https://img.shields.io/badge/Security-Cisco%20%26%20NVIDIA%20Audited-success.svg)](docs/security-audit.md)
[![Harness Engineering](https://img.shields.io/badge/Harness%20Engineering-RHO%20Enabled-orange.svg)](docs/harness-engineering.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-FFDD00?style=flat&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sun.flat.yamada)

本リポジトリは、ソフトウェア開発向けに厳選した Agent / Skills レジストリです。**V字モデルの工程ごとにベストを 1 つ**だけ登録し、より良い手法が出てきたら更新します。**Claude Code Plugin 形式 & Agent Skills Standard** を Master (Source of Truth) とし、**Claude Code** をメインに、同じプラグインを **GitHub Copilot CLI** にも導入できます。

最先端の **Harness Engineering (RHO)** による自律的自己診断・更新サイクル、および **Cisco & NVIDIA ツールによる強固なセキュリティ監査 CI/CD** を標準装備しています。

---

## 🏛️ アーキテクチャ構成

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                       Master (Source of Truth)                              │
│   .claude-plugin/plugin.json · skills/*/SKILL.md · agents/*.agent.md        │
│   commands/*.md · registry.yml (one best entry per V-model slot)            │
└──────────────────────┬───────────────────────────────┬──────────────────────┘
                       │                               │
                       ▼                               ▼
       ┌───────────────────────────────┐ ┌───────────────────────────────┐
       │      Claude Code (main)       │ │      GitHub Copilot CLI       │
       │  /plugin marketplace add      │ │  copilot plugin marketplace   │
       │  /plugin install              │ │  copilot plugin install       │
       │  (reads .claude-plugin/)      │ │  (reads .claude-plugin/ too)  │
       └───────────────────────────────┘ └───────────────────────────────┘
                       │                               │
                       └───────────────┬───────────────┘
                                       ▼
       ┌───────────────────────────────────────────────────────────────┐
       │         Automated Security Auditing & CI/CD Pipeline          │
       │    • Cisco AI Skill Scanner + NVIDIA SkillSpector + Linter    │
       │    • Copilot CLI plugin load check                            │
       │    • SARIF 2.1.0 output to GitHub Code Scanning               │
       └───────────────────────────────────────────────────────────────┘
```

---

## ⚡ クイックスタート

### 1. インストール

どちらのクライアントも、このリポジトリの同じ `.claude-plugin/` マニフェストを読み込みます。

**Claude Code**
```bash
/plugin marketplace add sun-flat-yamada/agents-registry
/plugin install agent-registry-bundle@agent-registry-marketplace
```

**GitHub Copilot CLI**
```bash
copilot plugin marketplace add sun-flat-yamada/agents-registry
copilot plugin install agent-registry-bundle@agent-registry-marketplace
```

X2（セキュリティ）枠の `claude-security` は Anthropic 公式プラグインで、Claude Code でのみ動きます：`/plugin install claude-security@claude-plugins-official`。クライアントごとに使える範囲は [docs/usage-and-deployment.md](docs/usage-and-deployment.md) を参照してください。

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

本レジストリは、ソフトウェア開発の **V字モデルの工程ごとに、ベストを 1 つだけ**登録します。枠の定義・選定基準・入れ替えルールは [docs/v-model-skeleton.md](docs/v-model-skeleton.md)、現在の割当・出典・選定理由は [`registry.yml`](registry.yml) を参照してください。

| 枠 | 工程 | 入口 | 内部で使うもの | 出典 |
| :--- | :--- | :--- | :--- | :--- |
| V1 | 要求定義 | [`requirements-definition`](skills/requirements-definition/SKILL.md) | — | in-house |
| V2 | 基本設計 | [`architecture-design`](skills/architecture-design/SKILL.md) | `code-explorer` | in-house |
| V3 | 詳細設計 | [`detailed-design`](skills/detailed-design/SKILL.md) | `code-architect`, `type-design-analyzer` | in-house |
| V4 | 実装 | [`implementation-loop`](skills/implementation-loop/SKILL.md) | `code-simplifier` | in-house |
| V5 | 単体テスト | [`unit-test-tdd`](skills/unit-test-tdd/SKILL.md) | `pr-test-analyzer` | in-house |
| V6 | 結合テスト | [`integration-test`](skills/integration-test/SKILL.md) | — | in-house |
| V7 | システムテスト | [`system-test`](skills/system-test/SKILL.md) | [`webapp-testing`](skills/webapp-testing/SKILL.md) | in-house |
| V8 | 受入テスト | [`acceptance-test`](skills/acceptance-test/SKILL.md) | — | in-house |
| X1 | 横断：コードレビュー | [`/code-review`](commands/code-review.md) | — | Anthropic 公式（取り込み） |
| X2 | 横断：セキュリティ | `claude-security` プラグイン | — | Anthropic 公式（`/plugin install claude-security@claude-plugins-official` で導入） |

工程間は ID でつながります。要求 `REQ-n`・受入基準 `AC-n`（V1 → V8）、システムテスト観点 `ST-n`（V2 → V7）、インターフェース `IF-n`・結合テスト観点 `IT-n`（V3 → V6）です。「内部で使うもの」のエージェントと `webapp-testing` は Anthropic 公式リポジトリから無改変で取り込んでいます（[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)）。

### 🧠 レジストリ運用ツール（枠外）
- [`retrospective-harness`](skills/retrospective-harness/SKILL.md) / [`retrospective-harness-agent`](agents/retrospective-harness-agent.agent.md): エージェント実行履歴の自己診断と Harness Improvement Plan (HIP) の策定。
- [`update-harness`](skills/update-harness/SKILL.md) / [`update-harness-agent`](agents/update-harness-agent.agent.md): 承認済み HIP のアトミックな適用と検証。
- [`meta-skill-manager`](skills/meta-skill-manager/SKILL.md): Agent Skills の作成・更新・監査。

### 📦 退避済み
- [`archive/non-dev/`](archive/non-dev/README.md): 個人・業務・専門ドメイン向け（会計、投資、料理、個人 Wiki/ワークスペースなど）。
- [`archive/dev-retired/`](archive/dev-retired/README.md): 開発関連のうち、枠のエントリに置き換えたもの（旧コードレビュー一式、`e2e-live`、`reviewer-security` など）と、どの枠にも入らないもの。

退避したものは内容をそのまま残していますが、配信対象からは外しています。

---

## ⚡ コマンド (Commands)

| コマンド | ファイル | 説明 |
| :--- | :--- | :--- |
| `/code-review` | [`commands/code-review.md`](commands/code-review.md) | X1 枠。PR を複数エージェントで並列レビューし、別エージェントが裏取りできた指摘だけを出します（Anthropic 公式）。 |
| `/retrospective-harness` | [`commands/retrospective-harness.md`](commands/retrospective-harness.md) | ハーネスの自己診断と Harness Improvement Plan (HIP) の策定。 |
| `/update-harness` | [`commands/update-harness.md`](commands/update-harness.md) | HIP に基づくハーネスの自動更新。 |

---

## 📂 リポジトリ構成概要

```text
/
├── registry.yml         # V字モデルの枠ごとの登録内容（各枠ベスト 1 つ）
├── archive/             # 退避したエージェント・スキル：non-dev/ と dev-retired/（配信対象外）
├── licenses/            # 取り込んだ公式ファイルのライセンス（THIRD_PARTY_NOTICES.md 参照）
├── skills/              # Agent Skills Standard 準拠スキル (Master)
├── agents/              # 役割特化エージェント・ペルソナ定義 (Master)
├── commands/            # スラッシュコマンド・再利用可能プロンプト
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
