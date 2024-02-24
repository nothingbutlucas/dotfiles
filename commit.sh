#!/bin/env bash

# Script made by the people of gum: https://github.com/charmbracelet/gum

TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
SCOPE=$(gum input --placeholder="scope(opcional)")

test -n "$SCOPE" && SCOPE="($SCOPE)"

SUMMARY=$(gum input --value="$TYPE$SCOPE: " --placeholder="Add an imperative subject line" --char-limit=50)
DESCRIPTION=$(gum write --placeholder="Body that explain why not how (CTRL+D to exit)" --width=72)

gum confirm "Commit changes?" && git commit -s -m "$SUMMARY" -m "$DESCRIPTION"
