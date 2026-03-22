---
id: core-2
type: core
status: plan
description: implement file naming convention parser
priority: high
agent_optimized: true
estimated_effort: 15m
---

# Implement File Naming Convention Parser

## Task Description
Create functions to parse and validate the TODO file naming convention.

## File Naming Format
`<type>-<#>-<description>.md`

Examples:
- `code-1-basic-file-management.md`
- `review-2-review-code-changes.md`

## Acceptance Criteria
- [ ] Parse filename into components (type, number, description)
- [ ] Validate naming format
- [ ] Generate valid filenames
- [ ] Handle descriptions with hyphens properly

## Notes for Agent
Focus on robust parsing. Use regex or string manipulation to extract components. Ensure the parser handles edge cases like descriptions containing hyphens.
