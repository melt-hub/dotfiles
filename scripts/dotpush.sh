#!/bin/bash

MSG="${1:-Auto-update: $(date +'%Y-%m-%d %H:%M')}"

cd "$HOME/dotfiles" || exit 1

if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "$MSG"
    git push origin main
fi