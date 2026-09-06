name: Feature Request
description: Suggest an idea, new skill, or agent persona for this registry
title: '[FEAT] '
labels: ['enhancement']
body:
  - type: markdown
    attributes:
      value: Have a proposal for a new agent skill, prompt, or harness feature? Let us know!
  - type: textarea
    id: feature-description
    attributes:
      label: Feature Proposal
      description: Describe the feature, new agent persona, or skill module you'd like to see.
    validations:
      required: true
  - type: textarea
    id: motivation
    attributes:
      label: Problem & Motivation
      description: Is your feature request related to a problem or cognitive friction in agent workflows?
    validations:
      required: false
  - type: textarea
    id: alternatives
    attributes:
      label: Alternatives Considered
      description: Any alternative solutions or workarounds you've considered.
    validations:
      required: false
