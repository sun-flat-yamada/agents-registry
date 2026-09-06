---
name: meta-skill-manager
description: Creates, updates, lists, and audits Agent Skills (SKILL.md). Distills successful conversation workflows and developer procedures into standardized, reusable agent capabilities.
---

# Meta-Skill Manager

This skill serves as the self-expansion mechanism for AI agents. It allows agents to introspect on workflows that worked well and encapsulate them into permanent, version-controlled `SKILL.md` modules adhering to the Agent Skills Standard.

## Trigger Scenarios
- "Make this a skill" / "Save this workflow as a skill" / "skill 化して"
- "Audit existing skills" / "List skills"
- "Update the deployment skill to add a staging verification step"

## Core Workflow: Skill-ifying a Procedure

### 1. Workflow Distillation
- Analyze the chat transcript or requested operation.
- Distill specific parameters (hardcoded paths, session IDs, temporary filenames) into generalized inputs and step-by-step instructions.
- Write instructions in imperative, second-person voice: ("1. Run linter... 2. Inspect output...").

### 2. Standardized Layout & Frontmatter
Format the new skill following the Agent Skills Standard:
```markdown
---
name: <kebab-case-slug>
description: <Concise, third-person explanation of what this skill does and when to invoke it>
---

# <Skill Title>

[Clear rationale and capability definition]

## Inputs & Prerequisites
- [List expected parameters or context]

## Step-by-Step Execution
1. ...
2. ...

## Edge Cases & Error Recovery
- [How to recover if a step fails]
```

### 3. Registry Registration
- Save the skill under `skills/<kebab-case-slug>/SKILL.md`.
- Register the skill in the primary manifest (`.claude-plugin/plugin.json`) and package index (`apm.yml`).
- Confirm registration with a one-line summary and example invocation syntax.
