---
id: task-1
type: implementation
status: done
description: implement file naming parser in bash
priority: high
agent_optimized: true
estimated_effort: 10m
---

# Implement File Naming Parser

## Task Description
Add robust filename parsing to the todo.sh script.

## Acceptance Criteria
- [ ] Parse `<type>-<number>-<description>.md` format correctly
- [ ] Handle descriptions with multiple hyphens (e.g., "basic-file-management")
- [ ] Validate that type is lowercase letters only
- [ ] Extract number as integer for sorting/comparison

## Notes for Agent
The parser should split by first two hyphens only, keeping the rest as description. Use `cut` or parameter expansion in bash.
