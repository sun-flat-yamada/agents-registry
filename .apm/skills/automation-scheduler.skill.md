---
name: automation-scheduler
description: Configures, lists, and manages background recurring tasks and automated agent runs (daily cron schedules, periodic intervals) for system health, digests, data polling, and maintenance.
---

# Automation Scheduler Skill

This skill enables agents to establish, audit, and orchestrate autonomous recurring jobs. It configures scheduled tasks that awaken the agent at designated intervals or daily times to perform continuous background operations.

## Frequency Guidelines

When users request recurring execution, recommend an appropriate cadence:
- **News / RSS / Alert Feeds**: `interval 1h` or `interval 2h` (frequently updating content)
- **Daily Digests / Summaries / Journals**: `daily 23:00` (UTC) (once per day)
- **Wiki Maintenance / Lint / Health Checks**: `interval 168h` (weekly background audit)
- **Data Backup / Registry Sync**: `interval 24h`

> [!NOTE]
> All daily schedules are configured and compared in **UTC**. For example, a request for 08:00 JST (UTC+9) corresponds to `daily 23:00` UTC.

## Core Operations

### 1. Registering an Automation
Create or append an automation task entry to `config/scheduler/tasks.json`:
```json
{
  "id": "wiki-weekly-lint",
  "schedule": "interval 168h",
  "prompt": "Run wiki-lint and report any structural or semantic issues.",
  "enabled": true
}
```

### 2. Collection-Specific Ingest vs. Global Scheduler
- If the objective is to refresh records within a **single collection** (e.g. stock quotes, API feeds), place an `ingest` block directly inside that collection's `schema.json`.
- If the objective is a **system-wide or cross-domain action** (digest, email roundup, global health check), register a task via this scheduler skill.

### 3. Verification & Auditing
- List active tasks with their next execution triggers.
- Provide a clear one-line confirmation when a task is registered, paused, or decommissioned.
