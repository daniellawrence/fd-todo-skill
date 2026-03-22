# fd-todo - Agent-Optimized File-Based TODO System

A minimal, file-based task management system optimized for AI agents to efficiently pick up and complete work without reading unnecessary content.

## Overview

This system uses a simple directory structure with markdown files containing YAML frontmatter. Each task is designed to be self-contained and easily understood by agents.

**Key Design Principles:**
1. **Scan Before Reading**: Agents can quickly scan filenames for basic info
2. **Structured Metadata**: Frontmatter provides consistent, parseable data
3. **Single Responsibility**: Each file contains one type of task only
4. **Agent-Friendly**: Optimized for both human and AI consumption

## Directory Structure

```
todo/                          # Project TODO files (or .pi/skills/todo-system)
├── plan/                      # Tasks awaiting work (default state)
├── doing/                     # Tasks currently in progress
└── done/                      # Completed tasks
```

## File Naming Convention

```
<type>-<number>-<description>.md
```

**Examples:**
- `code-1-basic-file-management.md`
- `review-5-pr-review-tasks.md`
- `design-3-create-wireframe.md`

### Rules:
- **Type**: Lowercase letters only (e.g., `code`, `review`, `design`)
- **Number**: Sequential integer per type
- **Description**: 3-6 words, converted to hyphenated lowercase format

## Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `id` | Yes | Unique identifier (auto-generated from filename) |
| `type` | Yes | Task category (code, review, design, etc.) |
| `status` | Yes | Current state (plan, doing, done) |
| `description` | Yes | Brief task description |
| `priority` | No | high, medium, low (default: medium) |
| `agent_optimized` | Yes | Boolean for agent-friendly format |
| `estimated_effort` | No | Time estimate in minutes |

## CLI Commands

### List Todos
```bash
# List todos by state (default: plan)
/pi todo list [plan|doing|done] [--type <type>]

# Examples:
/pi todo list plan                    # Show all tasks awaiting work
/pi todo list doing                   # Show in-progress tasks
/pi todo list plan --type code        # Filter by type
```

### Get Full Details
```bash
# Read complete task content
/pi todo get <filename>

# Example:
/pi todo get code-1-basic-file-management.md
```

### Create New Todo
```bash
# Create new task (goes to plan state)
/pi todo create <type> <description>

# Examples:
/pi todo create code implement-user-authentication
/pi todo create review Review PR changes for auth module
```

### Move Between States
```bash
# Move task between states
/pi todo move <filename> <to_state>

# Examples:
/pi todo move code-1-task.md doing      # Start working on it
/pi todo move code-1-task.md done       # Mark as complete
```

### Worker (Auto-Complete)
```bash
# Automatically process and complete all pending tasks
/pi todo worker [y/n]  # Prompt to continue after each batch

# Examples:
/pi todo worker                              # Auto-complete all plan tasks
/pi todo worker n                            # Process once, don't continue
/pi todo worker y                            # Process, then ask to continue

# Features:
# - Automatically checks off unchecked acceptance criteria
# - Updates frontmatter status to "done"
# - Moves completed files to done state
# - Creates git commit for each completed task (auto-commit enabled)
# - Interactive prompt after processing (asks if should continue)

### Git Auto-Commit on Completion

Every time a task is moved to **done** state, the system automatically creates a git commit:

```bash
# Manual completion with auto-commit
/pi todo move code-1-task.md done
  ✓ Moved 'code-1-task.md' from plan to done
  ✓ Git commit created: Complete: implement authentication (#code-1)

# Worker auto-completes with commits for each task
/pi todo worker
  ✓ Moved 'task-x-description.md' to done state
  ✓ Git commit created: Complete: description (#task-x)
```

**Commit Message Format:** `Complete: <description> (#<id>)`

*Note: Commits are only created when in a git repository and when files have changes.*

### Show Status
```bash
# Overview of all states
/pi todo status
```

## Agent Usage Guidelines

### Best Practices for Agents

1. **Always scan first**: Use `list` to see available tasks before reading content
2. **Select carefully**: Choose tasks matching your capabilities and priority
3. **Read only when needed**: Call `get <filename>` only for complete context
4. **Complete atomically**: Move to "done" when task is fully completed

### Typical Workflow

```bash
# 1. See what's available
$ /pi todo list plan
=== TODOs in plan ===
  [code] 1-implement-auth: high (plan)
  [review] 2-review-pr: medium (plan)
Total: 2 task(s)

# 2. Read full details on selected task
$ /pi todo get code-1-implement-auth.md
=== code-1-implement-auth.md ===
--- Frontmatter ---
id: code-1
type: code
status: plan
description: implement user authentication
priority: high
agent_optimized: true
estimated_effort: 30m

# Implement User Authentication

## Task Description
Implement user authentication system with login/logout.

## Acceptance Criteria
- [ ] Create login form and handler
- [ ] Add password hashing
- [ ] Implement session management

...

# 3. Complete the task
$ /pi todo move code-1-implement-auth.md done
Moved 'code-1-implement-auth.md' from plan to done
```

## Quick Start

### For AI Agents
1. Run `/pi todo list` to see available tasks
2. Select a task based on your capabilities
3. Use `/pi todo get <filename>` for full details
4. After completion, use `/pi todo move <file> done`

### For Human Developers
```bash
# Clone this project
git clone <repository-url>
cd fd-todo

# Create a new task
/pi todo create code my-new-feature-description

# See all tasks
/pi todo list plan

# Get details on specific task
/pi todo get code-1-my-new-feature-description.md
```

## Why This Design?

### For Agents
- **Minimal Reading Overhead**: Filename contains type, number, and description
- **Structured Metadata**: Frontmatter is easily parseable
- **Clear Ownership**: Each file has one clear responsibility
- **No Hidden State**: Everything visible in filesystem

### For Humans
- **Readable Format**: Markdown with YAML frontmatter
- **Searchable**: Easy to grep/filter by type or number
- **Portable**: No database required, just files
- **Version-Friendly**: Works well with git

## Troubleshooting

### "Invalid filename format" error
Ensure filename follows pattern: `<type>-<number>-<description>.md`
- Type must be lowercase letters only
- Number must be a positive integer
- Description should be 3-6 words (converted to hyphens)

### Task not found
Check which state directory contains the file:
```bash
ls .todo/plan/*.md    # Check plan state
ls .todo/doing/*.md   # Check doing state
ls .todo/done/*.md    # Check done state
```

### Can't move from "done" state
Tasks in "done" state are final. Create a new task if you need to rework something.

## Examples

### Creating Tasks for Different Types

```bash
# Development work
/pi todo create code implement-api-endpoints
/pi todo create bug fix-null-pointer-exception
/pi todo create refactor optimize-database-queries

# Review tasks
/pi todo create review PR-for-authentication-module
/pi todo create review check-code-quality-pr-42

# Design tasks
/pi todo create design create-wireframe-dashboard
/pi todo create design mockup-user-profile-page

# Documentation
/pi todo create docs write-api-documentation
/pi todo create docs update-getting-started-guide
```

### Filtering and Searching

```bash
# List all code tasks in progress
/pi todo list doing --type code

# Check high priority items
/pi todo status  # Shows high priority tasks automatically

# Get details on specific task
/pi todo get code-15-implement-api-endpoints.md
```

## License

MIT
