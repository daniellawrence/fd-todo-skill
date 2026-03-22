---
name: todo-system
description: File-based TODO system for agents. List, create, get details, and move tasks between plan/doing/done states using markdown files with YAML frontmatter. Optimized for quick scanning without reading full content.
---

# Agent-Optimized TODO System

A file-based task management system designed for AI agents to pick up work efficiently.

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

## Quick Start

```bash
# List todos by state (default: plan)
/skill:todo list [plan|doing|done] [--type <type>]

# Get full details of a specific todo
/skill:todo get <filename>

# Create new todo (goes to plan state)
/skill:todo create <type> <description>

# Move todo between states
/skill:todo move <filename> <to_state>

# Auto-complete all tasks (worker)
/skill:todo worker [y/n]  # Prompts to continue after processing

# Auto-commit on completion (enabled by default for done state)
/skill:todo move <file> done    # Creates git commit when moving to done

# Show overview status
/skill:todo status
```

## Agent Usage Guidelines

1. **Quick Scanning**: Use `list` command to see all tasks without reading content
2. **Task Selection**: Pick a task based on your capabilities and priority  
3. **Full Context**: Call `get <filename>` only when you need complete details
4. **Completion Options**:
   - Manual: Use `/skill:todo move <file> done` for individual completion
   - Automated: Use `/skill:todo worker` to auto-process all pending tasks

### High-Priority Automation Tasks

When working on high-priority tasks (marked with `priority: high` in frontmatter), agents should consider:

- **Task-10** (automation): Implement auto-complete workflow for moving finished tasks
- This will reduce manual commands and ensure consistent completion patterns

## Why This Design?

- **No Unnecessary Reads**: Agents can scan filenames for basic info
- **Structured Metadata**: Frontmatter provides consistent, parseable data
- **Single Responsibility**: Each file contains one type of task only
- **Human & Machine Friendly**: Readable by both humans and AI agents

## Example Workflow

```bash
# See what tasks are available
/skill:todo list plan

# Get full details on a specific task
/skill:todo get code-1-implement-user-authentication.md

# After completing the task, move it to done
/skill:todo move code-1-implement-user-authentication.md done

# Create a new related task
/skill:todo create review Review PR for authentication implementation
```

## Files in This Skill

- `scripts/todo.sh` - Main CLI script with all commands
- `README.md` - Full documentation reference
