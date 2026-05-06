#!/usr/bin/env bash
CODEPATH="$HOME/code"

# Find projects 3 levels deep: ~/code/github.com/user/project
selected=$(find "$CODEPATH" -mindepth 3 -maxdepth 3 -type d \
  | sed "s|$CODEPATH/||" \
  | sort --ignore-case \
  | fzf --no-sort --prompt="  project> " --border=rounded --height=40%)

[ -z "$selected" ] && exit 0

project_path="$CODEPATH/$selected"
# Session name: repo name only (last path component), sanitized
session_name=$(echo "$selected" | awk -F/ '{print $(NF-1)"/"$NF}' | tr '.' '_' | tr ':' '_')

if ! tmux has-session -t "=$session_name" 2>/dev/null; then
  tmux new-session -ds "$session_name" -c "$project_path"
fi

tmux switch-client -t "$session_name"
