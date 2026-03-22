# fd-todo - File-Based Task Manager for Coding Agents

A simple task system where each task is a markdown file. Optimized for coding agent environments to quickly find and complete work.

## How It Works

Tasks are stored as files in `.todo/` with three states:

```
.todo/
├── plan/    # Tasks waiting to be done
├── doing/   # Tasks being worked on
└── done/    # Completed tasks
```

Each file has a name like `code-1-add-login.md`:
- **type** (code, review, design)
- **number** (sequential ID)
- **description** (what to do)

## Quick Start

### For Coding Agents
```python
# See available tasks in a state
list_tasks('plan')  # or 'doing', 'done'

# Read a task's full details
get_task('code-1-add-login.md')

# Mark complete when done
move_task('code-1-add-login.md', 'done')
```

### For Humans
```bash
# Create a new task
/skill:todo create code add-user-authentication

# View all tasks in plan state
/skill:todo list plan
```

## Common Commands

| Command | Description |
|---------|-------------|
| `list_tasks([plan\|doing\|done])` | Show tasks in a state (for agents) |
| `get_task(<file>)` | Read full task details (for agents) |
| `move_task(<file>, <state>)` | Change task status (for agents) |
| `/skill:todo create <type> <desc>` | Add new task (CLI for humans) |
| `/skill:todo list [plan\|doing\|done]` | Show tasks in a state (CLI for humans) |

## Task Format

Files use YAML frontmatter for metadata:

```markdown
---
id: code-1
type: code
status: plan
description: add user authentication
priority: high
agent_optimized: true
estimated_effort: 30
---

Task details go here...
```

## Best Practices

**For Coding Agents:**
1. Scan filenames first (contains type, number, description)
2. Read full content only when needed (`get_task()`)
3. Move to "done" when complete using `move_task()`

**For Humans:**
Use the `/skill:todo` CLI commands listed above to manage tasks interactively.

**Naming Rules:**
- Type: lowercase letters only (`code`, `review`, `design`)
- Number: sequential integer
- Description: 3-6 words, hyphenated

## License

MIT
