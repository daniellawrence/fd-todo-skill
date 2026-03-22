---
id: task-2
type: implementation
status: done
description: implement YAML frontmatter parsing and updates
priority: high
agent_optimized: true
estimated_effort: 15m
---

# Implement Frontmatter Handler

## Task Description
Add functions to read/write YAML frontmatter in TODO files.

## Acceptance Criteria
- [ ] Extract content between `---` delimiters
- [ ] Parse key-value pairs from frontmatter
- [ ] Update specific fields (like status) when moving tasks
- [ ] Handle missing or malformed frontmatter gracefully

## Notes for Agent
Use sed/grep to extract and modify YAML. Keep it simple - no full YAML parser needed for MVP.
