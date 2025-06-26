#!/bin/bash

LIST_FILE="$(dirname "$0")/../list.txt"

cmd="${1,,}"  # Kommando in Kleinbuchstaben
shift
args=("$@")

# Variable VIRTUAL_C muss von xdos.sh exportiert oder gesetzt werden
: "${VIRTUAL_C:=/tmp/Cx}"  # Default falls nicht gesetzt

function show_help_for_cmd() {
  local c="$1"
  local line
  # Greife auf den ersten passenden Eintrag in list.txt zu (case insensitive)
  line=$(grep -iE "^$c(:|/)" "$LIST_FILE" | head -n1)
  if [[ -z "$line" ]]; then
    echo "No help available for command '$c'"
    return
  fi
  IFS=':' read -r cmds script desc usage <<< "$line"
  # Großschreibung usage (DOS-Stil)
  usage_dos=$(echo "$usage" | awk '{for(i=1;i<=NF;i++){$i=toupper($i)} print}')
  echo "Error: Invalid usage."
  echo "$cmds - $desc"
  echo "Usage: $usage_dos"
}

case "$cmd" in
  copy)
    if cp -iv "${args[@]}" 2>/dev/null; then :; else show_help_for_cmd copy; fi
    ;;
  del)
    if rm -v "${args[@]}" 2>/dev/null; then :; else show_help_for_cmd del; fi
    ;;
  move|ren|rename)
    if mv -iv "${args[@]}" 2>/dev/null; then :; else show_help_for_cmd move; fi
    ;;
  md|mkdir)
    if mkdir -pv "${args[@]}" 2>/dev/null; then :; else show_help_for_cmd md; fi
    ;;
  rd|rmdir)
    if rmdir -v "${args[@]}" 2>/dev/null; then :; else show_help_for_cmd rd; fi
    ;;
  type)
    if cat "${args[@]}" 2>/dev/null; then :; else show_help_for_cmd type; fi
    ;;
  linux)
    # Einfach nur "/" ausgeben, xdos.sh sollte dann das prompt anpassen
    echo "/"
    ;;
  c)
    echo "$VIRTUAL_C"
    ;;
  *)
    echo "Unknown file command: $cmd" >&2
    ;;
esac

