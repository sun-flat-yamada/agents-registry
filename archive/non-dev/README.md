# 📦 Archive: Non-Development Assets

このフォルダには、レジストリを「ソフトウェア開発の V 字モデル工程ごとにベストを 1 つ」という方針（[docs/v-model-skeleton.md](../../docs/v-model-skeleton.md)）に絞った際に、**開発外**と判断したエージェントとスキルを退避しています。

- 削除はしていません。内容は退避時点のまま残しています。
- `.claude-plugin/plugin.json` と `apm.yml` からは外しているため、プラグインや APM では**配信されません**。
- 再び使う場合は、元の `agents/` または `skills/` に戻し、両マニフェストに登録し直してください。

## 退避したもの（2026-10-28）

### Agents (`agents/`)

| 名前 | 内容 |
| :--- | :--- |
| `agent-accounting` | 会計・記帳 |
| `agent-artist` | ビジュアル・クリエイティブ |
| `agent-guide` | 旅行・イベント・手順ガイド |
| `agent-investor` | 投資リサーチ |
| `agent-office` | 業務文書・プレゼン |
| `agent-personal` | 個人の予定・タスク管理 |
| `agent-storyteller` | 物語づくり |
| `agent-tutor` | 学習支援 |
| `collection-architect` | 個人ワークスペースのデータアプリ設計 |
| `wiki-curator` | 個人ナレッジベース管理 |
| `workspace-agent` | 個人ワークスペース管理 |

### Skills (`skills/`)

| 名前 | 内容 |
| :--- | :--- |
| `billing-invoice` | 請求書・稼働管理 |
| `cooking-coach` | レシピ管理 |
| `edgar-sec-filings` | SEC 開示資料の取得・分析 |
| `library` | 読書記録 |
| `portfolio-tracker` | 投資ポートフォリオ管理 |
| `presentation-deck` | プレゼン資料作成 |
| `storyteller` | 物語づくり |
| `zenn-publisher` | 技術ブログ執筆 |
| `collection-builder` | 個人ワークスペースのデータアプリ構築 |
| `wiki-ingest` / `wiki-lint` / `wiki-promote` | 個人ナレッジベース管理 |
| `setup-wizard` | 個人ワークスペースの自動化設定 |
| `setup-relay` | 個人ワークスペースのメッセージ中継設定 |
| `automation-scheduler` | 個人ワークスペースの定期タスク設定 |
