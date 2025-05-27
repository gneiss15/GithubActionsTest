#!/bin/bash

set -x

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

# Wenn Änderungen vorhanden sind
if ./AnyChangesInDir.sh $($only_top_level && echo "-o") "$dir"; then
  git add "$dir"
  git commit -m "$msg"
  git push
 fi



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
if [ -z "$(git status --porcelain "$dir")" ]; then
  exit 1
fi
if $only_top_level; then
  git status --porcelain "$dir" | grep -qE "^[ MARCUD?\!]{2} $(basename "$dir")/"
 else
  git status --porcelain "$dir" | grep -qE "^[ MARCUD?\!]{2}"
fi

