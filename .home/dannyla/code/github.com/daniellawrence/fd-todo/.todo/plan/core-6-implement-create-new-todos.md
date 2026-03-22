---
id: core-6
type: core
status: plan
description: implement creating new todo items
priority: high
agent_optimized: true
estimated_effort: 20m
---

# Implement Create New Todos Functionality

## Task Description
Create functions to generate new TODO files with proper naming and frontmatter.

## Acceptance Criteria
- [ ] Generate unique sequential ID numbers per type
- [ ] Validate description format (3-6 words, hyphenated)
- [ ] Auto-generate id field from filename components
- [ ] Set initial status to "plan"
- [ ] Create file in correct state directory

## Naming Convention Examples
- `code-10-setup-project.md`
- `review-5-review-pr-changes.md`
- `design-3-create-wireframe.md`

## Notes for Agent
Need a counter mechanism per type. Consider using separate counter files or parsing existing files to find next available number. Keep descriptions concise and descriptive.
