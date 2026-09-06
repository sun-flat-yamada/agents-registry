name: Bug Report
description: Report a bug or issue in agent skills, hooks, or synchronization
title: '[BUG] '
labels: ['bug']
body:
  - type: markdown
    attributes:
      value: Thank you for taking the time to report a bug!
  - type: textarea
    id: description
    attributes:
      label: Bug Description
      description: A clear and concise description of what the bug is.
    validations:
      required: true
  - type: textarea
    id: reproduce
    attributes:
      label: Steps to Reproduce
      description: Steps to reproduce the behavior.
      placeholder: |
        1. Run command '/...'
        2. Harness triggers error '...'
    validations:
      required: true
  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
      description: A clear and concise description of what you expected to happen.
    validations:
      required: true
  - type: dropdown
    id: environment
    attributes:
      label: Target Environment
      options:
        - Claude Code
        - Microsoft APM
        - Cursor / GitHub Copilot
        - Google Gemini / Antigravity
        - Other
    validations:
      required: true
