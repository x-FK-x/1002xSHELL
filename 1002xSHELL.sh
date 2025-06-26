#!/bin/bash

clear
echo "1002XSHELL loaded"
BASE_DIR="$(dirname "$(realpath "$0")")"
LIST_FILE="$BASE_DIR/list.txt"
COMMANDS_DIR="$BASE_DIR/commands"

# Virtuelles C:-Laufwerk bestimmen
if [[ $EUID -ne 0 && -d "/home/$USER" ]]; then
  VIRTUAL_C="/home/$USER/.Cx"
else
  VIRTUAL_C="/1002xSHELL/Cx"
fi

mkdir -p "$VIRTUAL_C"
export VIRTUAL_C

echo "Virtual drive C: is at $VIRTUAL_C"
cd "$VIRTUAL_C" || exit

# Hauptloop
while true; do
  prompt="C:\\>"
  [[ "$PWD" == "/" ]] && prompt="LINUX:\\>"

  read -e -a input -p "$prompt "
  [[ -z "${input[0]}" ]] && continue

  cmd="${input[0],,}"
  args=("${input[@]:1}")

  # ? Autovervollständigung
  if [[ "$cmd" == *"?" ]]; then
    guess="${cmd%\?}"
    "$COMMANDS_DIR/autofill.sh" "$guess"
    continue
  fi

  # Interne Shell-Kommandos
  case "$cmd" in
    exit) exit 0 ;;
    cls) clear ;;
    ver) echo "XDOS Shell v1.0" ;;
    pause) read -rp "Press any key to continue..." ;;
    cd) cd "${args[0]:-$HOME}" || echo "Directory not found" ;;
    dir) ls -alh "${args[0]:-.}" ;;
    help)
      "$COMMANDS_DIR/help.sh" "${args[@]}"
      ;;
    *)
      # Befehl in list.txt suchen
      if [[ ! -f "$LIST_FILE" ]]; then
        echo "Error: list.txt not found at $LIST_FILE"
        continue
      fi

      found=""
      while IFS=: read -r aliases script desc usage; do
        IFS='/' read -ra alias_arr <<< "$aliases"
        for alias in "${alias_arr[@]}"; do
          if [[ "$alias" == "$cmd" ]]; then
            found="$script"
            break 2
          fi
        done
      done < "$LIST_FILE"

      if [[ -n "$found" ]]; then
        script_path="$COMMANDS_DIR/$found.sh"
        if [[ -f "$script_path" ]]; then
          bash "$script_path" "$cmd" "${args[@]}"
        else
          echo "Command handler script '$found.sh' not found."
        fi
      else
        echo "Bad command or file name"
      fi
      ;;
  esac
done

