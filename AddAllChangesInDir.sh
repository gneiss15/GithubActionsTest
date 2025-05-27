#!/bin/bash

set -x
set -v

# Funktion: AnyChangesInDir
# Syntax: AnyChangesInDir [-o] [Dir]
AnyChangesInDir()
 {
  local only_top_level=false
  local dir="."

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
 }

# Funktion: AddAllChangesInDir
# Syntax: AddAllChangesInDir [-o] [Dir] [CommitMsg]
AddAllChangesInDir() 
 {
  local only_top_level=""
  local dir="."
  local msg="Auto-Commit"

  # Argumentverarbeitung
  while [[ "$1" =~ ^- ]]; do
    case "$1" in
      -o) only_top_level="-o" ;;
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
  if AnyChangesInDir $only_top_level "$dir"; then
    git add "$dir"
    git commit -m "$msg"
    git push
  fi
 }

AddAllChangesInDir "$@"
