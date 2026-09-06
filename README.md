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
