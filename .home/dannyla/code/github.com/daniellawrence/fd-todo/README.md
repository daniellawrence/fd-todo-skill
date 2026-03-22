# fd-todo - Agent-Optimized File-Based TODO System

A minimal, file-based TODO system optimized for AI agents to pick up and complete tasks without reading unnecessary content.

## Overview

This system uses a simple directory structure with markdown files containing YAML frontmatter. Each task is designed to be self-contained and easily understood by agents.

## Directory Structure

```
.todo/
├── plan/      # Tasks awaiting work (default state)
├── doing/     # Tasks currently in progress
└── done/      # Completed tasks
```

## File Naming Convention

```
<type>-<number>-<description>.md
```

Examples:
- `code-1-basic-file-management.md`
- `review-5-pr-review-tasks.md`
- `design-3-create-wireframe.md`

## Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `id` | Yes | Unique identifier (auto-generated) |
| `type` | Yes | Task category (code, review, design, etc.) |
| `status` | Yes | Current state (plan, doing, done) |
| `description` | Yes | Brief task description |
| `priority` | No | high, medium, low |
| `agent_optimized` | Yes | Boolean for agent-friendly format |
| `estimated_effort` | No | Time estimate in minutes |

## CLI Commands

```bash
# List todos by state (default: plan)
fd-todo list [plan|doing|done] [--type <type>]

# Get full details of a specific todo
fd-todo get <filename>

# Create new todo (goes to plan state)
fd-todo create <type> <description>

# Move todo between states
fd-todo move <filename> <to_state>

# Show overview status
fd-todo status

# Help
fd-todo -h
```

## Agent Usage Guidelines

1. **Quick Scanning**: Use `list` command to see all tasks without reading content
2. **Task Selection**: Pick a task based on your capabilities and priority
3. **Full Context**: Call `get <filename>` only when you need complete details
4. **Completion**: Move completed tasks to "done" state using the `move` command

## Why This Design?

- **No Unnecessary Reads**: Agents can scan filenames for basic info
- **Structured Metadata**: Frontmatter provides consistent, parseable data
- **Single Responsibility**: Each file contains one type of task only
- **Human & Machine Friendly**: Readable by both humans and AI agents

## Quick Start

```bash
# Create new code task
fd-todo create code implement-user-authentication

# List all plan tasks
fd-todo list plan

# Get full details
fd-todo get code-1-implement-user-authentication.md

# Mark as done when complete
fd-todo move code-1-implement-user-authentication.md done
```

## License

MIT
