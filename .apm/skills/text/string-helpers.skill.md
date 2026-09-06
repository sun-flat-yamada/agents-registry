---
description: Custom skill providing modular string utility operations.
---
# String Helpers Skill

This skill exposes capabilities for performing complex text transformations and utility operations.

## Available Functions

### 1. `truncate_text`
- **Description**: Safely truncates a string to a specified length without cutting off words.
- **Parameters**:
  - `text` (string): The text to truncate.
  - `max_length` (integer): Maximum character length.
  - `suffix` (string, optional): String to append to the end. Defaults to `...`.

### 2. `extract_regex`
- **Description**: Extracts patterns matching a regular expression from text.
- **Parameters**:
  - `text` (string): Target text.
  - `pattern` (string): Regex pattern.
  - `flags` (string, optional): Regex flags (e.g. `g`, `i`, `m`).
