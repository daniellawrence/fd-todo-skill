---
id: test-9
type: test
status: plan
description: write unit tests for core functionality
priority: medium
agent_optimized: true
estimated_effort: 45m
---

# Write Unit Tests

## Task Description
Create comprehensive unit tests for all core functionality.

## Test Coverage Requirements
- [ ] Filename parsing (valid and invalid cases)
- [ ] Frontmatter parsing and generation
- [ ] List todos functionality
- [ ] Move between states
- [ ] Create new todos with unique IDs
- [ ] Get single todo by filename/ID

## Acceptance Criteria
- [ ] All core functions have test coverage
- [ ] Test edge cases (malformed files, missing directories)
- [ ] Use Go's standard `testing` package only
- [ ] Tests are deterministic and reproducible
- [ ] Include example test data in tests

## Notes for Agent
Use `t.Run()` for subtests. Create temporary directories for integration-style tests. Keep tests isolated and fast-running.
