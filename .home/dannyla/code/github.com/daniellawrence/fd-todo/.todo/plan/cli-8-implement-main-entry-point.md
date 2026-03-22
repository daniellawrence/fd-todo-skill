---
id: cli-8
type: cli
status: plan
description: implement main entry point with CLI commands
priority: high
agent_optimized: true
estimated_effort: 30m
---

# Implement Main Entry Point and CLI Commands

## Task Description
Create the main Go application with command-line interface.

## Command Structure
```
fd-todo <command> [options]

Commands:
  list [state] [--type <type>]    List todos by state (plan|doing|done)
  get <filename>                  Get full details of a todo
  create <type> <description>     Create new todo in plan state
  move <filename> <to_state>      Move todo to different state
  status                          Show overview of all states
```

## Acceptance Criteria
- [ ] Parse command-line arguments (use `flag` package)
- [ ] Implement all CLI commands listed above
- [ ] Display user-friendly output for humans and agents
- [ ] Exit with appropriate error codes
- [ ] Provide help text (`fd-todo -h`)

## Notes for Agent
Use Go's standard `flag` package. Keep CLI simple and predictable. Each command should have clear, consistent output format.
