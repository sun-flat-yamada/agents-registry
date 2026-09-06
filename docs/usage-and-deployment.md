# 🚀 インストールとマルチハーネス配信ガイド (Usage & Deployment Guide)

本リポジトリは、**Claude Code Plugin 形式および Agent Skills Standard を Master (Source of Truth)** としながら、**Microsoft APM (Agent Package Manager)** を通じたマルチハーネス配信（Claude Code, Cursor, GitHub Copilot, Google Gemini）を完全サポートしています。

---

## 1. Claude Code で利用する

### A. プラグインとして直接インストール
公開リポジトリまたはフォーク先から直接プラグインとして組み込みます：
```bash
/plugin install github:sun-flat-yamada/agents-registry
```

### B. ローカル開発・検証モード
リポジトリを手元で開発・検証する際は、`--plugin-dir` オプションを指定して起動します：
```bash
claude --plugin-dir /path/to/agents-registry
```

### C. マーケットプレイス経由でカタログ追加
プラグインマーケットプレイスとして追加し、必要なスキルを適宜有効化します：
```bash
/plugin marketplace add github:sun-flat-yamada/agents-registry
```

---

## 2. Microsoft APM (Agent Package Manager) で利用する

### A. 他プロジェクトからの依存関係追加 (`apm.yml`)
利用側のプロジェクトの `apm.yml` に本リポジトリを依存として宣言します：
```yaml
name: my-target-project
version: 1.0.0
dependencies:
  apm:
    - github:sun-flat-yamada/agents-registry#v1.1.0
targets:
  - claude
  - cursor
  - copilot
  - gemini
```

### B. パッケージのインストールと各ハーネス向けコンパイル
```bash
apm install
apm compile
```
コンパイルにより、Cursor ルール (`.cursorrules`)、Copilot 設定、Gemini 設定が自動生成されます。

---

## 3. Master と .apm レイヤーの自動同期

リポジトリ内のスキルやエージェントを追加・変更した際は、以下の同期スクリプトで Master から `.apm/` 下位互換レイヤーを自動更新・検証します。

### Windows (PowerShell)
```powershell
# 同期と自動更新を実行
powershell -ExecutionPolicy Bypass -File ./scripts/sync-apm.ps1

# 整合性チェックのみを実行 (CI検証など)
powershell -ExecutionPolicy Bypass -File ./scripts/sync-apm.ps1 -VerifyOnly
```

### Linux / macOS (Bash)
```bash
# 実行権限の付与 (初回のみ)
chmod +x ./scripts/sync-apm.sh

# 同期と自動更新を実行
./scripts/sync-apm.sh

# 整合性チェックのみを実行 (CI検証など)
./scripts/sync-apm.sh --verify
```

---

## 4. 提供プリミティブ一覧

| カテゴリ | パス | 説明 |
| :--- | :--- | :--- |
| **Skills** | `skills/` | Agent Skills Standard 準拠の自律スキル（コードレビュー、LLM-Wiki、Collection、スケジューラー等） |
| **Agents** | `agents/` | 役割特化エージェント（セキュリティ監査、メモリ安全性、品質レビュー、Wiki キュレーター等） |
| **Commands** | `commands/` | `/retrospective-harness`, `/update-harness`, `/explain` 等のスラッシュコマンド |
| **Hooks** | `hooks/` | `PreToolUse` やコミット前検証を行う決定論的フック |
| **MCP** | `.mcp.json` | Filesystem および Memory サーバー連携設定 |
