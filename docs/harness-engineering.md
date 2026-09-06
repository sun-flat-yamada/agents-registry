# 🧠 Harness Engineering & 自己進化ガイド (Harness Engineering Guide)

本リポジトリの中核機能である **「Harness Engineering（ハーネス・エンジニアリング）」** および **「Retrospective Harness Optimization (RHO)」** の仕組みと運用手順を解説します。

---

## 1. 概念と背景

最先端の AI エージェント開発において、モデル自体の能力向上だけでなく、エージェントを取り巻く実行環境（ルール・プロンプト・ツール・フック・権限設定）を包括した **「Harness」** の最適化が決定的な成果をもたらすことが実証されています。

本リポジトリは、以下の公式規格・学術研究・コンテスト優勝知見を融合しています：

1. **Anthropic 公式 (`anthropics/claude-plugins-official`)**:
   - 決定論的フック（`hooks/hooks.json`）とプロンプト誘導の厳密な役割分離。
   - ポータブルなプラグインマニフェストと環境変数解決。
2. **Claude コンテスト優勝者 (`affaan-m/everything-claude-code`)**:
   - 失敗や対話の蓄積からルール・スキルを自己進化させる **`/evolve` パターン**。
   - Context Rot（文脈崩壊）を防ぐ多層エージェント分離と AgentShield ガードレール。
3. **学術研究: Retrospective Harness Optimization (`wbopan/retro-harness`)**:
   - 過去の実行軌跡（Trajectories）の自己検証と失敗分析による自己改善ループ（SWE-Bench Pro スコア 59% $\rightarrow$ 78% の飛躍的改善）。

---

## 2. 自己進化サイクル (Life Cycle)

```text
       ┌───────────────────────────────┐
       │   Agent Sessions / Failure    │
       │ (Tool errors, Lint breaks,    │
       │   Cognitive friction, etc.)   │
       └──────────────┬────────────────┘
                      │
                      ▼
       ┌───────────────────────────────┐
       │     retrospective-harness     │
       │   (Analyze logs vs standards, │
       │     produce plans/HIP.md)     │
       └──────────────┬────────────────┘
                      │
                      ▼
       ┌───────────────────────────────┐
       │        update-harness         │
       │   (Backup -> Atomic Apply ->  │
       │   Lint/Hook Test -> Sync APM) │
       └──────────────┬────────────────┘
                      │
                      ▼
       ┌───────────────────────────────┐
       │    Improved Durable Harness   │
       └───────────────────────────────┘
```

### ステップ 1: 診断・計画策定 (`/retrospective-harness`)
- **エージェント**: `retrospective-harness-agent.md`
- **スキル**: `skills/retrospective-harness/SKILL.md`
- **動作内容**:
  1. 最近のエージェント実行セッションにおけるツール実行エラー、パーミッション拒否、リント違反、人間の修正介入を走査。
  2. ベストプラクティス集（`references/best-practices.md`）と照合。
  3. ハーネス改善計画書 **`plans/harness-improvement-plan.md` (HIP)** を策定。

### ステップ 2: 安全な自動更新・検証 (`/update-harness`)
- **エージェント**: `update-harness-agent.md`
- **スキル**: `skills/update-harness/SKILL.md`
- **動作内容**:
  1. 承認された HIP に基づき、事前バックアップ（`.harness-backup/`）を即座に作成。
  2. ルール、フック、スキル、マニフェストへアトミックに変更を適用。
  3. 構文検証・フック dry-run・APM 同期検証を実施。
  4. 不整合やエラーが検知された場合は **自動ロールバック** を実行し、健全性を担保。

---

## 3. スラッシュコマンド一覧

Claude Code や対応環境から以下のコマンドで呼び出せます：

| コマンド | 説明 |
| :--- | :--- |
| `/retrospective-harness` | ハーネスの振り返り・自己診断を実行し、HIP 改善計画書を作成 |
| `/update-harness` | 承認された HIP に基づき、アトミックにハーネスを更新・検証 |
| `/explain` | コードやハーネス構造の詳細解説 |
| `/code-review-subagent` | 並列サブエージェントによる多角的レビュープロンプト |
