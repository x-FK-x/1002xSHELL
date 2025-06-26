#!/bin/bash

BASE_DIR="$(dirname "$(realpath "$0")")"
LIST_FILE="$BASE_DIR/../list.txt"

if [ ! -f "$LIST_FILE" ]; then
  echo "Error: list.txt not found at $LIST_FILE"
  exit 1
fi

# Alle Befehle auflisten
if [ $# -eq 0 ]; then
  echo "1002xShell Help"
  echo "==============="
  while IFS=: read -r aliases script desc usage; do
    # aliases: copy/del/xyz
    cmds=$(echo "$aliases" | sed 's/\//, /g')
    echo -e "${cmds}\n   - ${desc}\n     Usage: ${usage}\n"
  done < "$LIST_FILE"
  exit 0
fi

# Hilfe zu bestimmtem Befehl anzeigen
cmd="${1,,}"

# Befehl finden: Exakter Match gegen Aliase
match=""
while IFS=: read -r aliases script desc usage; do
  IFS='/' read -ra alias_arr <<< "$aliases"
  for alias in "${alias_arr[@]}"; do
    if [[ "${alias,,}" == "$cmd" ]]; then
      match="$aliases:$script:$desc:$usage"
      break 2
    fi
  done
done < "$LIST_FILE"

if [ -n "$match" ]; then
  IFS=: read -r aliases script desc usage <<< "$match"
  cmds=$(echo "$aliases" | sed 's/\//, /g')
  echo "$cmds - $desc"
  echo "Usage: $usage"
else
  echo "No help available for command '$cmd'"
  exit 1
fi

