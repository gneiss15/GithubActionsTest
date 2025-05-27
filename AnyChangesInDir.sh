#!/bin/bash

set -x
set -v

# Funktion: AnyChangesInDir
# Syntax: AnyChangesInDir [-o] [Dir]
only_top_level=false
dir="."

# Argumente verarbeiten
while [[ "$1" ]]; do
  case "$1" in
    -o) only_top_level=true ;;
    *) dir="$1" ;;
  esac
  shift
done

# Prüfe Änderungen im Verzeichnis
if $only_top_level; then
  git status --porcelain "$dir" | grep -qE "^[ MARCUD?\!]{2} $(basename "$dir")/"
 else
  git status --porcelain "$dir" | grep -qE "^[ MARCUD?\!]{2}"
fi

