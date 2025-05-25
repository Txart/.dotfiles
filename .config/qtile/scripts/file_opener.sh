#!/bin/bash

# Set search directory (default to home, can be customized)
SEARCH_DIR="${1:-$HOME}"

# Use fd if available (faster), otherwise fall back to find
if command -v fd &> /dev/null; then
    FILE=$(fd . "$SEARCH_DIR" --type f --hidden --exclude .git | 
           fzf --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {} 2>/dev/null || echo "Binary file"' \
               --preview-window=right:50% \
               --height=80% \
               --border \
               --prompt="Open file: ")
else
    FILE=$(find "$SEARCH_DIR" -type f -not -path '*/\.*' 2>/dev/null | 
           fzf --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || cat {} 2>/dev/null || echo "Binary file"' \
               --preview-window=right:50% \
               --height=80% \
               --border \
               --prompt="Open file: ")
fi

# Open the selected file if one was chosen
if [ -n "$FILE" ]; then
    # Determine how to open the file based on type
    if command -v xdg-open &> /dev/null; then
        xdg-open "$FILE"
    elif command -v mimeo &> /dev/null; then
        mimeo "$FILE"
    else
        # Fallback to basic file type detection
        case "${FILE##*.}" in
            txt|md|py|sh|conf|config|yaml|yml|json|xml|html|css|js)
                ${EDITOR:-vim} "$FILE"
                ;;
            pdf)
                ${PDF_VIEWER:-zathura} "$FILE" &
                ;;
            jpg|jpeg|png|gif|bmp)
                ${IMAGE_VIEWER:-feh} "$FILE" &
                ;;
            mp4|mkv|avi|mov)
                ${VIDEO_PLAYER:-mpv} "$FILE" &
                ;;
            *)
                ${EDITOR:-vim} "$FILE"
                ;;
        esac
    fi
fi
