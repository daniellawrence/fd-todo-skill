#!/bin/bash
# Agent-Optimized TODO System CLI
# File-based task management with YAML frontmatter

# Don't exit on errors - handle them explicitly
# set -e  # Disabled for better error handling

TODO_DIR=".todo"
PLAN_DIR="$TODO_DIR/plan"
DOING_DIR="$TODO_DIR/doing"
DONE_DIR="$TODO_DIR/done"

# Initialize directories if they don't exist
init_dirs() {
    mkdir -p "$PLAN_DIR" "$DOING_DIR" "$DONE_DIR"
}

# Parse filename into components: type-number-description.md
parse_filename() {
    local filename="$1"
    # Remove .md extension
    local base="${filename%.md}"
    # Split by hyphen, but only first two (description can contain hyphens)
    local type=$(echo "$base" | cut -d'-' -f1)
    local number=$(echo "$base" | cut -d'-' -f2)
    local description=$(echo "$base" | cut -d'-' -f3- | sed 's/^-*//')  # Remove leading hyphens
    
    echo "type=$type"
    echo "number=$number"
    echo "description=$description"
}

# Validate filename format
validate_filename() {
    local filename="$1"
    if [[ ! "$filename" =~ ^[a-z]+-[0-9]+-.+\.md$ ]]; then
        echo "Error: Invalid filename format. Expected: <type>-<number>-<description>.md" >&2
        echo "Example: code-1-basic-file-management.md" >&2
        return 1
    fi
    
    # Check file exists in expected directory
    local state=$(get_state_from_filename "$filename")
    if [[ -z "$state" ]]; then
        echo "Error: File not found in any state directory." >&2
        return 1
    fi
    
    return 0
}

# Get state from filename by checking which directory it's in
get_state_from_filename() {
    local filename="$1"
    
    if [[ -f "$PLAN_DIR/$filename" ]]; then
        echo "plan"
    elif [[ -f "$DOING_DIR/$filename" ]]; then
        echo "doing"
    elif [[ -f "$DONE_DIR/$filename" ]]; then
        echo "done"
    fi
}

# Get the next number for a given type in a state directory
get_next_number() {
    local state_dir="$1"
    local type="$2"
    
    # Find existing numbers for this type and get max + 1
    local max_num=0
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            local num=$(echo "$file" | grep -oP "^[a-z]+-\K[0-9]+" || echo "0")
            if [[ "$num" =~ ^[0-9]+$ ]] && (( num > max_num )); then
                max_num=$num
            fi
        fi
    done < <(find "$state_dir" -name "${type}-*.md" 2>/dev/null)
    
    echo $((max_num + 1))
}

# Parse YAML frontmatter (simple implementation)
parse_frontmatter() {
    local file="$1"
    # Extract content between first and second ---
    sed -n '/^---$/,/^---$/p' "$file" | tail -n +2 | head -n -1
}

# Get field value from frontmatter
get_field() {
    local field="$1"
    parse_frontmatter "$2" | grep "^${field}:" | sed "s/^${field}:[[:space:]]*//" || echo ""
}

# List todos in a state directory
list_todos() {
    init_dirs
    
    local state="${1:-plan}"
    local type_filter=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --type)
                type_filter="$2"
                shift 2
                ;;
            *)
                if [[ ! "$1" =~ ^(plan|doing|done)$ ]]; then
                    echo "Error: Unknown state '$1'. Use plan, doing, or done." >&2
                    exit 1
                fi
                state="$1"
                shift
                ;;
        esac
    done
    
    local state_dir=""
    case "$state" in
        plan) state_dir="$PLAN_DIR";;
        doing) state_dir="$DOING_DIR";;
        done) state_dir="$DONE_DIR";;
    esac
    
    echo "=== TODOs in $state ==="
    echo ""
    
    local count=0
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            filename=$(basename "$file")
            
            # Get type from frontmatter for filtering (same as display)
            local ft_from_frontmatter=$(get_field "type" "$file")
            local ftype="${ft_from_frontmatter:-$(echo "$filename" | cut -d'-' -f1)}"
            
            # Apply type filter if specified, using actual task type from frontmatter
            if [[ -n "$type_filter" ]] && [[ "$ftype" != "$type_filter" ]]; then
                continue
            fi
            
            local fnum=$(echo "$filename" | cut -d'-' -f2)
            local fnum=$(echo "$filename" | cut -d'-' -f2)
            local fdesc=$(echo "$filename" | cut -d'-' -f3- | sed 's/^-*//')
            
            # Try to get type and priority from frontmatter, fallback to filename parsing
            local ft_from_frontmatter=$(get_field "type" "$file")
            if [[ -n "$ft_from_frontmatter" ]]; then
                ftype="$ft_from_frontmatter"
            fi
            
            # Try to get priority from frontmatter, default to "low"
            local fpriority=$(get_field "priority" "$file")
            if [[ -z "$fpriority" ]]; then
                fpriority="low"
            fi
            
            printf "  [%s] %s-%s: %s (%s)\n" "$ftype" "$fnum" "$fdesc" "$fpriority" "$state"
            ((count++))
        fi
    done < <(find "$state_dir" -name "*.md" | sort)
    
    if [[ $count -eq 0 ]]; then
        echo "  (no tasks)"
    else
        echo ""
        echo "Total: $count task(s)"
    fi
    
    echo ""
}

# Get full details of a todo
get_todo() {
    local filename="$1"
    
    if [[ -z "$filename" ]]; then
        echo "Error: Please specify a filename." >&2
        echo "Usage: /skill:todo get <filename>" >&2
        exit 1
    fi
    
    # Validate and find file
    validate_filename "$filename" || exit 1
    
    local full_path=""
    if [[ -f "$PLAN_DIR/$filename" ]]; then
        full_path="$PLAN_DIR/$filename"
    elif [[ -f "$DOING_DIR/$filename" ]]; then
        full_path="$DOING_DIR/$filename"
    elif [[ -f "$DONE_DIR/$filename" ]]; then
        full_path="$DONE_DIR/$filename"
    fi
    
    echo "=== $filename ==="
    echo ""
    
    # Show frontmatter
    echo "--- Frontmatter ---"
    if grep -q "^---$" "$full_path"; then
        sed -n '/^---$/,/^---$/p' "$full_path" | tail -n +2 | head -n -1
    else
        echo "(no frontmatter found)"
    fi
    
    echo ""
    
    # Show body content (after frontmatter)
    # Extract line number of second --- delimiter and show everything after it
    local second_delim=$(grep -n "^---$" "$full_path" | sed -n '2p' | cut -d: -f1)
    if [[ -n "$second_delim" ]]; then
        tail -n +$((second_delim + 1)) "$full_path"
    fi
    
    echo ""
}

# Create a new todo
create_todo() {
    local type="$1"
    local description="$2"
    
    if [[ -z "$type" || -z "$description" ]]; then
        echo "Error: Usage: /skill:todo create <type> <description>" >&2
        echo "Example: /skill:todo create code implement-user-authentication" >&2
        exit 1
    fi
    
    # Validate type (lowercase letters only)
    if [[ ! "$type" =~ ^[a-z]+$ ]]; then
        echo "Error: Type must be lowercase letters only." >&2
        exit 1
    fi
    
    init_dirs
    
    local next_num=$(get_next_number "$PLAN_DIR" "$type")
    
    # Validate description (3-6 words, convert to hyphenated format)
    local word_count=$(echo "$description" | wc -w)
    if (( word_count < 3 || word_count > 6 )); then
        echo "Warning: Description should be 3-6 words. Current: $word_count words." >&2
    fi
    
    # Convert description to hyphenated format (lowercase, replace spaces with hyphens)
    local desc_slug=$(echo "$description" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
    
    local filename="${type}-${next_num}-${desc_slug}.md"
    local filepath="$PLAN_DIR/$filename"
    
    # Check if description already exists (avoid duplicates)
    while [[ -f "$filepath" ]]; do
        echo "Warning: File $filename already exists, trying next number..." >&2
        ((next_num++))
        filename="${type}-${next_num}-${desc_slug}.md"
        filepath="$PLAN_DIR/$filename"
    done
    
    # Create the file with frontmatter
    cat > "$filepath" << EOF
---
id: $type-$next_num
type: $type
status: plan
description: $description
priority: medium
agent_optimized: true
estimated_effort: 15m
---

# $description

## Task Description

TODO: Add task details here.

## Acceptance Criteria

- [ ] Create acceptance criteria for this task

## Notes for Agent

Add any relevant context or notes for the agent working on this task.

EOF
    
    echo "Created new TODO:"
    echo "  File: $filename"
    echo "  Type: $type"
    echo "  Description: $description"
    echo ""
}

# Move a todo between states
move_todo() {
    local filename="$1"
    local to_state="$2"
    
    if [[ -z "$filename" || -z "$to_state" ]]; then
        echo "Error: Usage: /skill:todo move <filename> <to_state>" >&2
        echo "Example: /skill:todo move code-1-task.md done" >&2
        exit 1
    fi
    
    # Validate state
    if [[ ! "$to_state" =~ ^(plan|doing|done)$ ]]; then
        echo "Error: Invalid state '$to_state'. Use plan, doing, or done." >&2
        exit 1
    fi
    
    # Find source file
    local src_dir=""
    local full_path=""
    
    if [[ -f "$PLAN_DIR/$filename" ]]; then
        src_dir="$PLAN_DIR"
        full_path="$PLAN_DIR/$filename"
    elif [[ -f "$DOING_DIR/$filename" ]]; then
        src_dir="$DOING_DIR"
        full_path="$DOING_DIR/$filename"
    elif [[ -f "$DONE_DIR/$filename" ]]; then
        echo "Error: File '$filename' is already in 'done' state and cannot be moved further." >&2
        exit 1
    else
        echo "Error: File not found." >&2
        exit 1
    fi
    
    # Determine destination directory
    local dest_dir=""
    case "$to_state" in
        plan) dest_dir="$PLAN_DIR";;
        doing) dest_dir="$DOING_DIR";;
        done) dest_dir="$DONE_DIR";;
    esac
    
    # Update frontmatter status field
    if grep -q "^---$" "$full_path"; then
        sed -i "s/^status: .*/status: $to_state/" "$full_path"
    fi
    
    # Move the file (rename to keep same filename)
    mv "$full_path" "$dest_dir/$filename"
    
    echo "Moved '$filename' from $(basename $src_dir) to $to_state"
    
    # Create git commit if moving to done state and in a git repository
    if [[ "$to_state" == "done" ]]; then
        create_commit_for_task "$full_path" "$filename"
    fi
}

# Create git commit for completed task
create_commit_for_task() {
    local filepath="$1"
    local filename="$2"
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "  (Not in a git repository, skipping commit)"
        return 0
    fi
    
    # Stage all changes first to ensure file is tracked
    git add . > /dev/null 2>&1
    
    if [[ $? -ne 0 ]]; then
        echo "  (Git staging failed, skipping commit)"
        return 0
    fi
    
    # Extract task description from frontmatter for commit message
    local task_desc=$(get_field "description" "$filepath")
    local task_id=$(grep "^id:" "$filepath" | head -1 | sed 's/^id:[[:space:]]*//' || echo "unknown")
    
    if [[ -z "$task_desc" ]]; then
        task_desc=$(basename "$filename" .md)
    fi
    
    # Create commit message referencing the task
    local commit_msg="Complete: $task_desc (#$task_id)"
    
    # Stage all changes and create commit
    git add . > /dev/null 2>&1
    if git commit -m "$commit_msg" > /dev/null 2>&1; then
        echo "  ✓ Git commit created: $commit_msg"
    else
        echo "  (Git commit failed, but task is complete)"
    fi
    
    return 0
}

# Show overall status
show_status() {
    init_dirs
    
    local plan_count=$(find "$PLAN_DIR" -name "*.md" 2>/dev/null | wc -l)
    local doing_count=$(find "$DOING_DIR" -name "*.md" 2>/dev/null | wc -l)
    local done_count=$(find "$DONE_DIR" -name "*.md" 2>/dev/null | wc -l)
    
    echo "=== TODO System Status ==="
    echo ""
    printf "  %-10s %d tasks\n" "plan:" "$plan_count"
    printf "  %-10s %d tasks\n" "doing:" "$doing_count"
    printf "  %-10s %d tasks\n" "done:" "$done_count"
    echo ""
    echo "Total: $((plan_count + doing_count + done_count)) task(s)"
    echo ""
    
    # Show high priority items in plan
    if (( plan_count > 0 )); then
        local high_priority=$(find "$PLAN_DIR" -name "*.md" | while read f; do
            if grep -q "^priority: high$" "$f"; then
                basename "$f"
            fi
        done)
        
        if [[ -n "$high_priority" ]]; then
            echo "High priority items:"
            for item in $high_priority; do
                echo "  * $item"
            done
            echo ""
        fi
    fi
}

# Worker function - auto-completes tasks and moves to done
worker() {
    init_dirs
    
    echo "=== TODO System Worker ==="
    echo ""
    echo "Starting automated task completion workflow..."
    echo ""
    
    # Get list of plan tasks
    local plan_tasks=$(find "$PLAN_DIR" -name "*.md" 2>/dev/null | sort)
    
    if [[ -z "$plan_tasks" ]]; then
        echo "No pending tasks in plan state."
        return 0
    fi
    
    local task_count=0
    local completed=0
    
    while IFS= read -r filepath; do
        if [[ -n "$filepath" ]]; then
            task_count=$((task_count + 1))
            filename=$(basename "$filepath")
            
            echo "=== Processing: $filename ==="
            
            # Check acceptance criteria in the file (trim whitespace)
            local unchecked=$(grep -c "^\- \[ \]" "$filepath" 2>/dev/null | tr -d '[:space:]')
            local checked=$(grep -c "^\- \[x\]$" "$filepath" 2>/dev/null | tr -d '[:space:]')
            
            # Default to 0 if empty
            unchecked=${unchecked:-0}
            checked=${checked:-0}
            
            if [[ "$unchecked" =~ ^[0-9]+$ ]] && [[ "$unchecked" -gt 0 ]]; then
                echo "Acceptance criteria status: $checked/$((checked + unchecked)) completed"
                
                # Auto-check remaining acceptance criteria
                sed -i 's/^\- \[ \]/- [x]/g' "$filepath"
                echo "Auto-completed remaining acceptance criteria"
            fi
            
            # Update frontmatter status to done
            if grep -q "^---$" "$filepath"; then
                sed -i "s/^status: .*/status: done/" "$filepath"
            fi
            
            # Move file to done state
            mv "$filepath" "$DONE_DIR/$filename"
            
            completed=$((completed + 1))
            echo "✓ Moved '$filename' to done state"
            
            # Create git commit for this task
            create_commit_for_task "$DONE_DIR/$filename" "$filename"
        else
            continue
        fi
        
        echo ""
    done <<< "$plan_tasks"
    
    echo "=== Worker Summary ==="
    echo "Tasks processed: $task_count"
    echo "Tasks completed: $completed"
    echo ""
    
    # Check if there are more tasks to process
    local remaining=$(find "$PLAN_DIR" -name "*.md" 2>/dev/null | wc -l)
    
    if [[ "$remaining" -gt 0 ]]; then
        echo "There are $remaining task(s) remaining in plan state."
        read -p "Should the worker continue with next task? (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Starting next batch..."
            worker
        else
            echo "Worker stopped. You can resume anytime by running: /skill:todo worker"
        fi
    elif (( completed > 0 )); then
        echo "All tasks have been processed!"
        bash .pi/skills/todo-system/scripts/todo.sh status
    fi
    
    echo ""
}

# Print usage/help
print_help() {
    cat << EOF
Agent-Optimized TODO System

Usage: /skill:todo <command> [options]

Commands:
  list [state] [--type <type>]    List todos by state (plan|doing|done)
                                  Optionally filter by type
  
  get <filename>                  Get full details of a specific todo
  
  create <type> <description>     Create new todo in plan state
                                  Description should be 3-6 words
  
  move <filename> <to_state>      Move todo to different state (plan|doing|done)
  
  status                          Show overview of all states
  
  worker                          Auto-complete tasks and move to done

Examples:
  /skill:todo list plan                           # List all plan tasks
  /skill:todo list doing --type code              # List code tasks in progress
  /skill:todo get code-1-implement-auth.md        # Get full task details
  /skill:todo create review Review PR changes     # Create new review task
  /skill:todo move code-1-task.md done            # Mark as complete
  /skill:todo status                              # Show system overview

For more information, see SKILL.md documentation.
EOF
}

# Main command dispatcher
main() {
    local cmd="${1:-help}"
    
    case "$cmd" in
        list)
            shift
            list_todos "$@"
            ;;
        get)
            shift
            get_todo "$@"
            ;;
        create)
            shift
            create_todo "$@"
            ;;
        move)
            shift
            move_todo "$@"
            ;;
        worker)
            worker
            ;;
        status)
            show_status
            ;;
        help|--help|-h)
            print_help
            ;;
        *)
            echo "Error: Unknown command '$cmd'" >&2
            print_help
            exit 1
            ;;
    esac
}

# Run main with all arguments
main "$@"
