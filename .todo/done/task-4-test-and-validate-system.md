---
id: task-4
type: test
status: done
description: test all CLI commands and edge cases
priority: high
agent_optimized: true
estimated_effort: 20m
---

# Test and Validate System

## Task Description
Test the skill thoroughly to ensure it works as expected.

## Acceptance Criteria
- [ ] Test `list` command for all states (plan, doing, done)
- [ ] Test `get` command with valid and invalid filenames
- [ ] Test `create` command with various descriptions
- [ ] Test `move` command between all state combinations
- [ ] Test error handling (missing files, invalid formats)
- [ ] Verify agent can scan without reading full content

## Notes for Agent
Run each command manually and verify output. Check that filenames are parsed correctly even with hyphens in descriptions.
