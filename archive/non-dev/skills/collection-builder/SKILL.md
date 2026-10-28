---
name: collection-builder
description: Builds lightweight, declarative data-driven apps (Collections) using plain files — generates schema.json (fields, relations, UI views, action buttons) and manages item records (<id>.json). (The Workspace is the Database paradigm).
---

# Collection Builder Skill

This skill embodies the declarative data-first philosophy:
> **The workspace is the database. Files are the source of truth. You are the intelligent interface.**

A **Collection** is a self-contained data application defined by a single declarative `schema.json` and a directory of JSON records (`data/<name>/items/<id>.json`). The host UI renders interactive tables, detail panels, calendar views, computed fields, and action buttons purely from the schema with zero server-side database dependencies.

## Anatomy of a Collection

```text
skills/<collection-slug>/
  SKILL.md                  # Natural-language instructions for operating the collection
  schema.json               # Declarative DSL: fields, relations, views, and action buttons
  templates/*.md            # Action prompt templates for per-record operations

data/<collection-slug>/items/
  <id-1>.json               # Individual record file
  <id-2>.json
```

## Schema Specification (`schema.json`)

A minimal `schema.json` contains:
```json
{
  "name": "book-inventory",
  "displayName": "Book Inventory",
  "itemTitleField": "title",
  "fields": {
    "title": { "type": "string", "label": "Title", "required": true },
    "author": { "type": "string", "label": "Author" },
    "status": {
      "type": "select",
      "label": "Reading Status",
      "options": ["To Read", "In Progress", "Completed"]
    },
    "rating": { "type": "number", "label": "Rating (1-5)" },
    "notes": { "type": "markdown", "label": "Notes" }
  },
  "views": {
    "default": {
      "type": "table",
      "columns": ["title", "author", "status", "rating"]
    }
  },
  "actions": {
    "summarize": {
      "label": "Generate Summary",
      "template": "templates/summarize.md"
    }
  }
}
```

## Operations Workflow

1. **Schema Design**: When the user requests a tracker, registry, or inventory (e.g., "Create an invoice tracker" or "Make a workout log"), design the field types and relations into `schema.json`.
2. **Item CRUD**:
   - Create: Write a unique `<uuid>.json` into `data/<collection-slug>/items/`.
   - Read: Parse and filter item JSON files.
   - Update: Modify specific record files atomically.
   - Delete: Remove item JSON files with confirmation.
3. **Action Triggers**: Execute natural-language templates on selected records to produce LLM outputs (e.g. summaries, auto-categorizations, reports).
