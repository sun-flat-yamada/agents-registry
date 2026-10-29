# 🚀 インストールと利用ガイド (Usage & Deployment Guide)

本リポジトリは **Claude Code Plugin 形式と Agent Skills Standard** を Master (Source of Truth) とし、**Claude Code** をメインのクライアントにしています。GitHub Copilot CLI も `.claude-plugin/` のマニフェストを読み込めるため、同じリポジトリをそのまま **GitHub Copilot CLI** のプラグインとして導入できます。

---

## 1. Claude Code で利用する

### A. マーケットプレイスから導入（推奨）
```bash
/plugin marketplace add sun-flat-yamada/agents-registry
/plugin install agent-registry-bundle@agent-registry-marketplace
```

X2（セキュリティ）枠は Anthropic 公式マーケットプレイスから別に導入します：
```bash
/plugin marketplace add anthropics/claude-plugins-official
/plugin install claude-security@claude-plugins-official
```

### B. ローカル開発・検証モード
```bash
claude --plugin-dir /path/to/agents-registry
```

---

## 2. GitHub Copilot CLI で利用する

### A. マーケットプレイスから導入（推奨）
```bash
copilot plugin marketplace add sun-flat-yamada/agents-registry
copilot plugin install agent-registry-bundle@agent-registry-marketplace
```

導入後は `copilot skill list` でスキル、対話モードの `/agent` でエージェントを確認できます。

### B. ローカル開発・検証モード
```bash
copilot --plugin-dir /path/to/agents-registry
```

Copilot CLI はプラグインをキャッシュから読み込むため、マーケットプレイス経由で導入した場合は、変更後に `copilot plugin update agent-registry-bundle` で更新してください。

---

## 3. クライアントごとの対応範囲

| 要素 | Claude Code | GitHub Copilot CLI | 備考 |
| :--- | :--- | :--- | :--- |
| V1〜V8 のスキル (`skills/`) | ✅ | ✅ | Agent Skills Standard の `SKILL.md`。CI で Copilot CLI への読み込みを確認しています |
| エージェント (`agents/*.agent.md`) | ✅ | ✅ | Copilot CLI がエージェントとして読むのは `NAME.agent.md` 形式のため、この名前にそろえています。`model: sonnet` など Claude 固有の指定は、Copilot CLI では効かない場合があります |
| X1 `/code-review` (`commands/`) | ✅ | ⚠️ 読み込みは可 | 手順の中で Claude のモデル名（haiku / sonnet / opus）と `gh` CLI を使います。Copilot CLI では同じ手順を既定のモデルで実行します |
| X2 `claude-security` | ✅ | ❌ | Claude Code のワークフロー機能を使う公式プラグインです。Copilot CLI では Claude Code で実行してください |

### エージェントファイルの命名

`agents/` のファイルは `NAME.agent.md` で統一しています。Claude Code は `.md` で終わるファイルをすべてエージェントとして読み、名前はフロントマターの `name` で決まるため、この命名でもそのまま動きます。Anthropic 公式から取り込んだエージェントも、内容は変えずにファイル名だけを `.agent.md` にしています。

---

## 4. Master と .apm レイヤーの同期

APM（Agent Package Manager）向けの `.apm/` は Master から自動生成します。スキルやエージェントを追加・変更したら、以下で同期・検証してください。APM の配信先 (`apm.yml` の `targets`) は `claude`、`copilot`、`agent-skills` です。

### Windows (PowerShell)
```powershell
powershell -ExecutionPolicy Bypass -File ./scripts/sync-apm.ps1
powershell -ExecutionPolicy Bypass -File ./scripts/sync-apm.ps1 -VerifyOnly
```

### Linux / macOS (Bash)
```bash
./scripts/sync-apm.sh
./scripts/sync-apm.sh --verify
```

---

## 5. 配信しないもの

以前はプラグインに含めていた次のものは、利用者の環境に常に影響するため配信から外し、[`archive/dev-retired/`](../archive/dev-retired/README.md) に退避しました。

- `hooks/`：`package.json` に lint / format があると、すべての Bash 実行の前に `npm run lint` と `npm run format` を走らせる PreToolUse フック
- `.mcp.json`：Filesystem / Memory の MCP サーバー（どの枠にも対応しない）
