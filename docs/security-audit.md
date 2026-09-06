# 🛡️ Skills & Agent セキュリティ監査ガイド (Security Audit Guide)

本リポジトリでは、AI エージェントおよびスキルのサプライチェーン攻撃、プロンプトインジェクション、機密データ持ち出し、不正なリモートコード実行を防止するため、**業界標準の 2 大セキュリティスキャナー（Cisco AI Skill Scanner & NVIDIA SkillSpector）** とビルトイン監査機構を統合した多層防御セキュリティ監査パイプラインを標準搭載しています。

---

## 1. 統合セキュリティエンジン

本パイプラインは以下の 3 つのレイヤーで検査を実行します：

| エンジン | 提供元 | 検査方式と主なカバー領域 |
| :--- | :--- | :--- |
| **Cisco AI Skill Scanner** (`cisco-ai-skill-scanner`) | Cisco AI Defense | YARA シグネチャ、AST/バイトコード解析、振る舞いデータフロー解析。Claude Code / Cursor 形式の `--lenient` モードに対応。 |
| **NVIDIA SkillSpector** (`skillspector`) | NVIDIA | 17 カテゴリ・71 種の脆弱性パターン（プロンプトインジェクション、MCP ツール汚染、テイント追跡、特権昇格、危険なコード実行、OSV.dev リアルタイム CVE 連携）。 |
| **Built-in Security Linter** | 本リポジトリ内製 | オフライン即時稼働。ハードコードされたトークン (`sk-`, `ghp_`, `AKIA...`)、危険なシェル (`curl \| sh`, `rm -rf /`)、フロントマター整合性を検証。 |

---

## 2. 前提環境と依存関係

- **Python バージョン**: **Python 3.12+**（NVIDIA SkillSpector の動作要件）
- **推奨ツール**: 高速パッケージマネージャー [`uv`](https://github.com/astral-sh/uv)

依存定義ファイル: [`scripts/requirements-security.txt`](../scripts/requirements-security.txt)
```text
cisco-ai-skill-scanner>=2.0.14
skillspector @ git+https://github.com/NVIDIA/skillspector.git
pyyaml>=6.0
```

手動インストールの例:
```bash
uv pip install -r scripts/requirements-security.txt
# または pip install -r scripts/requirements-security.txt
```

---

## 3. ローカルでの実行方法

プロジェクトルートから、OS に応じたラッパースクリプトを実行します。仮想環境の自動検出・構築も内蔵されています。

### Windows (PowerShell)
```powershell
# 1. 全スキル・エージェントのフルスキャン
powershell -ExecutionPolicy Bypass -File ./scripts/audit-security.ps1

# 2. 変更・追加されたアセットのみスキャン (PR 作成前の確認に最適)
powershell -ExecutionPolicy Bypass -File ./scripts/audit-security.ps1 -ChangedOnly

# 3. 特定のスキルまたはエージェントを個別スキャン
powershell -ExecutionPolicy Bypass -File ./scripts/audit-security.ps1 -Target skills/automation-scheduler/
powershell -ExecutionPolicy Bypass -File ./scripts/audit-security.ps1 -Target agents/reviewer-security.md

# 4. レポートファイル (JSON, Markdown, SARIF) を出力
powershell -ExecutionPolicy Bypass -File ./scripts/audit-security.ps1 `
  -OutputJson report.json `
  -OutputMarkdown report.md `
  -OutputSarif report.sarif
```

### Linux / macOS (Bash)
```bash
# 実行権限の付与 (初回のみ)
chmod +x ./scripts/audit-security.sh

# 1. 全アセットのフルスキャン
./scripts/audit-security.sh

# 2. 変更・追加分のみスキャン
./scripts/audit-security.sh --changed-only

# 3. 個別ターゲットのスキャン
./scripts/audit-security.sh --target skills/code-review/
```

---

## 4. オーケストレーター CLI リファレンス (`scripts/security-audit.py`)

Python から直接実行する際のオプション一覧です：

```bash
python scripts/security-audit.py [OPTIONS]
```

| オプション | 引数 | 説明 | デフォルト値 |
| :--- | :--- | :--- | :--- |
| `--target` | `<path>` | スキャン対象のスキルディレクトリまたはエージェントファイル | 全件 |
| `--changed-only` | なし | Git 差分から新規追加・修正されたアセットのみを抽出して検査 | 無効 |
| `--base-ref` | `<ref>` | `--changed-only` で比較するベースブランチ | `origin/main` |
| `--scanners` | `cisco nvidia builtin all` | 実行するスキャナーエンジン（複数指定可） | `all` |
| `--fail-on` | `critical high medium low any` | 終了コード 1（ビルド失敗）とする閾値重大度 | `high` |
| `--strict` | なし | 警告 (WARNING) レベルでもビルドを失敗させる | 無効 |
| `--output-json` | `<file>` | JSON レポート出力先パス | 出力なし |
| `--output-markdown`| `<file>` | GitHub PR 要約向け Markdown 出力先パス | 出力なし |
| `--output-sarif` | `<file>` | GitHub Code Scanning 向け SARIF 2.1.0 出力先パス | 出力なし |
| `--verbose` | なし | 詳細なデバッグ・ログを出力 | 無効 |

---

## 5. CI/CD 自動稼働パイプライン (`.github/workflows/security-audit.yml`)

スキルやエージェントが新規追加・変更された場合、GitHub Actions により自動的にセキュリティ監査が稼働します。

### 自動起動トリガー
1. **Pull Request / Push**:
   - 監視パス: `skills/**`, `agents/**`, `commands/**`, `instructions/**`, `scripts/**`, `.github/workflows/**`, `apm.yml`
   - 対象ブランチ: `main`, `master`
2. **週次定期スキャン (Cron)**:
   - 毎週月曜 02:00 UTC（新着 CVE やシグネチャの更新を既存アセットに再適用）
3. **手動実行 (`workflow_dispatch`)**:
   - GitHub Actions Web UI から任意パラメーターで即時トリガー可能。

### パイプラインの動作フロー
```text
[Git Push / PR (skills/**, agents/**)]
                 │
                 ▼
[Checkout Code (fetch-depth: 0)]
                 │
                 ▼
[Setup Python 3.12 & uv with caching]
                 │
                 ▼
[Install Cisco AI Skill Scanner & NVIDIA SkillSpector]
                 │
                 ▼
[Execute security-audit.py]
  • PR 時: --changed-only で差分アセットのみ高速検査
  • Push / 定期時: レジストリ全体を完全検査
  • 閾値: 重大度 HIGH 以上の検知でビルドブロック
                 │
                 ├───────────────────────────────┬───────────────────────────────┐
                 ▼                               ▼                               ▼
     [Markdown PR Step Summary]         [GitHub Code Scanning]          [Workflow Artifacts]
      ($GITHUB_STEP_SUMMARY に           (SARIF 2.1.0 をアップロードし    (JSON, Markdown, SARIF
       テーブル形式で可視化)              セキュリティタブで警告管理)      を 14 日間保持)
```

---

## 6. セキュリティポリシーと閾値運用

- **ブロック基準**: 原則として重大度 `HIGH` および `CRITICAL`（プロンプトインジェクション、認証情報のハードコード、任意シェル実行等）が 1 件でも検知された場合、CI は失敗ステータスとなりマージがブロックされます。
- **誤検知（False Positive）対応**: 意図した検証コード等の正当な記述である場合は、NVIDIA SkillSpector のベースライン機能（`skillspector baseline <target> -o .skillspector-baseline.yaml`）または Built-in ルールへの除外設定を行い管理します。
