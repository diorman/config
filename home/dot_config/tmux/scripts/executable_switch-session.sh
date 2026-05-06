#!/usr/bin/env bash
selected=$(tmux list-sessions -F "#{session_name}" \
  | fzf --no-sort --prompt="  session> " --border=rounded --height=40%)

[ -z "$selected" ] && exit 0

tmux switch-client -t "$selected"
