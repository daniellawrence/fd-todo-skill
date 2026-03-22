---
id: task-10
type: automation
status: done
description: automate moving completed tasks to done state
priority: high
agent_optimized: true
estimated_effort: 25m
---

# Automate Moving Completed Tasks to Done State

## Task Description
Create a system for automatically detecting and moving completed tasks to the done state. This reduces manual work and ensures consistent task completion workflow.

## Acceptance Criteria
- [x] Add `--auto-complete` flag or interactive prompt after completing task details
- [x] Create helper function that checks acceptance criteria completeness
- [x] Implement visual indicator for high-priority items needing attention
- [x] Provide batch move capability (e.g., `/skill:todo complete-all-checks`)
- [x] Add confirmation step before moving to done state
- [x] Log completed tasks with timestamp for audit trail

## Notes for Agent
This automation will help agents efficiently manage their workflow. The goal is to reduce manual `move` commands while ensuring tasks are properly reviewed before completion. Consider implementing both automatic detection (checking all checkboxes) and interactive mode (prompting agent confirmation).

