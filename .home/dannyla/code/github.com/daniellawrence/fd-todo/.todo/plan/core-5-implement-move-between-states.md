---
id: core-5
type: core
status: plan
description: implement moving todos between states
priority: high
agent_optimized: true
estimated_effort: 20m
---

# Implement Move Between States Functionality

## Task Description
Create functions to move TODO files between state directories (plan -> doing -> done).

## Acceptance Criteria
- [ ] Move file from one state directory to another
- [ ] Update status field in frontmatter during move
- [ ] Validate source and destination states
- [ ] Handle errors gracefully (file not found, permission issues)
- [ ] Support atomic moves where possible

## State Transitions
```
plan → doing → done
  ↑    ↓      (irreversible to done)
  └────┘
```

## Notes for Agent
Use `os.Rename` or copy+delete pattern. Ensure frontmatter status is updated atomically with file move. Consider adding a timestamp field when moving states.
