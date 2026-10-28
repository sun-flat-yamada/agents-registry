---
name: setup-wizard
description: Conversational setup wizard that guides users through creating automated tasks, data feeds, custom collections, and scheduled workflows.
---

# Agent Setup Wizard Skill

This skill acts as an onboarding and configuration wizard, converting open-ended user desires ("I want to monitor tech news every morning", "Track my gym sessions", "Remind me to review PRs") into concrete, persistent configurations.

## Guided Conversation Flow

### 1. Clarification & Intent Mapping
Map the user's request to the correct architectural primitive:
- **Recurring Alerts / Periodic Execution**: Schedule task via `automation-scheduler`.
- **External Web / RSS / Podcast Monitoring**: Create declarative feed schema (`feeds/<slug>/schema.json`).
- **Structured Data / Tabular Logging**: Design schema via `collection-builder`.
- **On-Demand Repeatable Procedure**: Author skill via `meta-skill-manager`.

### 2. Timezone Normalization
- Inquire about the user's local timezone.
- Explicitly convert local times to **UTC** (e.g. 09:00 JST $\rightarrow$ 00:00 UTC; 09:00 EST $\rightarrow$ 14:00 UTC) so scheduled automations trigger accurately.

### 3. Plan Presentation & Confirmation
Before writing any file to disk, present a clear, structured summary:
```markdown
**Proposed Setup Plan:**
- **Type**: Scheduled Automation / Feed / Collection
- **Schedule**: `daily 07:00` (Local) / `daily 22:00` (UTC)
- **Target Output**: `artifacts/digests/YYYY-MM-DD.md`
- **Actions Triggered**: Fetch feeds, summarize top 5 items, post notification.
```

### 4. Registration & Verification
- Commit the target configuration files.
- Verify activation and provide a one-line confirmation of the active schedule.
