#!/bin/env bash

# Script made by the people of gum: https://github.com/charmbracelet/gum

TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
SCOPE=$(gum input --placeholder="scope(opcional)")

test -n "$SCOPE" && SCOPE="($SCOPE)"

SUMMARY=$(gum input --value="$TYPE$SCOPE: " --placeholder="Titulo de este cambio")
DESCRIPTION=$(gum write --placeholder="Detalles de este cambio (CTRL+D para salir)")

gum confirm "Commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION"
