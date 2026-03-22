---
id: core-3
type: core
status: plan
description: implement frontmatter parsing and generation
priority: high
agent_optimized: true
estimated_effort: 20m
---

# Implement Frontmatter Parser

## Task Description
Create functions to read/write YAML frontmatter in TODO files.

## Required Fields
- `id`: Unique identifier (auto-generated)
- `type`: Task type (code, review, design, etc.)
- `status`: Current state (plan, doing, done)
- `description`: Brief description of the task
- `priority`: Priority level (high, medium, low)
- `agent_optimized`: Boolean for agent-friendly format
- `estimated_effort`: Time estimate

## Acceptance Criteria
- [ ] Parse YAML frontmatter from markdown files
- [ ] Generate proper YAML frontmatter with correct delimiters (`---`)
- [ ] Handle missing or malformed frontmatter gracefully
- [ ] Support adding/removing fields dynamically

## Notes for Agent
Use the `gopkg.in/yaml.v3` package or implement simple parsing. Since we're using standard library, consider implementing a minimal YAML parser or use text manipulation for this MVP.
