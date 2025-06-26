#!/bin/bash

# Autofill-Vorschläge auf Basis von list.txt und Teil-Eingabe
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIST_FILE="$SCRIPT_DIR/../list.txt"

if [[ ! -f "$LIST_FILE" ]]; then
  echo "Error: list.txt not found at $LIST_FILE"
  exit 1
fi

partial="${1,,}"

# Liste aller Befehle auslesen
matches=()
while IFS=: read -r aliases script desc usage; do
  IFS='/' read -ra alias_list <<< "$aliases"
  for alias in "${alias_list[@]}"; do
    if [[ "$alias" == "$partial"* ]]; then
      matches+=("$alias - $desc")
    fi
  done
done < "$LIST_FILE"

if [[ ${#matches[@]} -eq 0 ]]; then
  echo "No matches found."
else
  echo "Possible matches:"
  for m in "${matches[@]}"; do
    echo "  $m"
  done
fi

