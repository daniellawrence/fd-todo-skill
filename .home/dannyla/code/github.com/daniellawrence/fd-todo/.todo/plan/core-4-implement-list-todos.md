---
id: core-4
type: core
status: plan
description: implement list todos by state and type
priority: high
agent_optimized: true
estimated_effort: 25m
---

# Implement List Todos Functionality

## Task Description
Create functions to list TODOs filtered by state (plan/doing/done) and optionally by type.

## Acceptance Criteria
- [ ] List all todos in a given state directory
- [ ] Filter by task type (code, review, design, etc.)
- [ ] Display minimal info for agent scanning (type, number, description, priority)
- [ ] Sort by ID number or creation order
- [ ] Support pagination if many items

## Agent Optimization Features
- List should show only essential metadata in output
- Agents can quickly scan without reading full file content
- Include count of todos per state/type

## Notes for Agent
Use `os.ReadDir` to list files, then parse filenames to extract type and description. Frontmatter parsing is optional here - use filename info for quick scanning.
