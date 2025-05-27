#!/bin/bash

set -x
set -v

# Funktion: AddAllChangesInDir
# Syntax: AddAllChangesInDir [-o] [Dir] [CommitMsg]
only_top_level=false
dir="."
msg="Auto-Commit"

# Argumentverarbeitung
while [[ "$1" =~ ^- ]]; do
  case "$1" in
    -o) only_top_level=true ;;
  esac
  shift
done

# Nächstes Argument: Directory?
if [[ -d "$1" ]]; then
  dir="$1"
  shift
fi

# Commit-Message, falls angegeben
if [[ "$1" ]]; then
  msg="$1"
fi

git add "$dir"
git commit -m "$msg"
git push

