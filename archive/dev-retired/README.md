# 📦 Archive: Retired Development Assets

開発関連ではあるものの、V字モデルの枠ごとに「ベストを 1 つ」選んだ結果（[registry.yml](../../registry.yml)）、**より良いものに置き換えた**か、**どの枠にも入らない**と判断したものを退避しています。

- 削除はしていません。内容は退避時点のまま残しています。
- `.claude-plugin/plugin.json` と `apm.yml` から外しているため、**配信されません**。
- 再び使う場合は元の場所に戻し、両マニフェストに登録し直してください。

## 退避したもの（2026-10-28）

| 元の場所 | 理由 | 置き換え先 |
| :--- | :--- | :--- |
| `skills/code-review`, `agents/code-review-orchestrator`, `agents/code-reviewer`, `agents/reviewer-effective`, `agents/reviewer-memory-safety`, `agents/reviewer-style-quality`, `commands/code-review-subagent` | 指摘の裏取りがなく誤検知を減らせない | X1: 公式 `commands/code-review.md` |
| `agents/reviewer-security` | 短いチェックリスト型で、検証やパッチ提案がない | X2: 公式 `claude-security` プラグイン |
| `skills/e2e-live`, `skills/make-e2e-live` | 特定アプリ（チャット・Wiki 画面）向けで汎用性がない | V7: `skills/system-test` + 公式 `webapp-testing` |
| `chatmodes/architect` | 10 行の VS Code 向けチャットモードで、手順がない | V2: `skills/architecture-design` |
| `instructions/typescript-rules` | 特定言語のルールで、枠の入口にならない | V4: `skills/implementation-loop`（プロジェクト自身のルールに従う） |
| `contexts/project-structure` | 架空のモノレポ構成を前提にしたサンプル | なし |
| `commands/explain` | 汎用の説明プロンプトで、工程に対応しない | なし（枠外） |
| `skills/archive-shipped-plans` | 特定の `plans/` 運用を前提にした後片付け | なし（枠外） |
| `skills/setup-app`, `skills/setup-ollama-local` | 特定アプリ・ローカル LLM の環境構築で、工程に対応しない | なし（枠外） |
| `skills/string-helpers` | 文字列処理の小さなユーティリティで、工程に対応しない | なし（枠外） |
