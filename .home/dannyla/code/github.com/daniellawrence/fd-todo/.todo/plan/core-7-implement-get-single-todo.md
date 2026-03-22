---
id: core-7
type: core
status: plan
description: implement reading full todo details by id or filename
priority: medium
agent_optimized: true
estimated_effort: 15m
---

# Implement Get Single Todo Functionality

## Task Description
Create functions to read complete TODO file content when needed.

## Acceptance Criteria
- [ ] Read full markdown content including frontmatter
- [ ] Parse and return structured data from frontmatter
- [ ] Support lookup by filename or ID number
- [ ] Return error if file not found
- [ ] Cache frontmatter to avoid re-parsing on subsequent calls

## Agent Usage Pattern
1. Call `ListTodos()` for overview (no full reads)
2. When agent needs details, call `GetTodo(filename)` once
3. Process the complete task description and any additional fields

## Notes for Agent
Implement caching mechanism if possible. Frontmatter parsing should be done once per file read and cached in memory during program execution.
