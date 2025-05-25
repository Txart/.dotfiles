#!/bin/bash
# Open recently modified files

# Find files modified in the last 7 days
RECENT_FILES=$(find "$HOME" -type f -mtime -7 2>/dev/null | head -100)

FILE=$(echo "$RECENT_FILES" | 
       fzf --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {} 2>/dev/null' \
           --preview-window=right:50% \
           --height=80% \
           --border \
           --prompt="Recent files: ")

if [ -n "$FILE" ]; then
    xdg-open "$FILE" 2>/dev/null || ${EDITOR:-vim} "$FILE"
fi

