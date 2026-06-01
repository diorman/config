#!/bin/sh
# Build a tmux window name from the @winname option each pane records: fish sets
# @winname to the running command, or "-" when idle (see config.fish). We join
# every non-idle pane with " | " so a window advertises everything running
# across its panes, e.g. "claude | nvim", and fall back to "-" when all panes
# are idle. Invoked by fish on command start/stop and by tmux's
# window-layout-changed hook (which covers panes opening and closing).
w=${1:-$(tmux display-message -p '#{window_id}')}
title=$(tmux list-panes -t "$w" -F '#{@winname}' 2>/dev/null \
    | grep -vE '^-?$' \
    | awk 'NR>1{printf " | "}{printf "%s", $0}')
[ -z "$title" ] && title=-
tmux rename-window -t "$w" -- "$title"
