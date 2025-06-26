#!/bin/bash

update() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "You are not root. Trying with sudo..."
    sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoclean && sudo apt-get autoremove -y && clear
  else
    apt-get update && apt-get upgrade -y && apt-get autoclean && apt-get autoremove -y && clear
  fi
}

ssh_cmd() {
  if [ $# -eq 0 ]; then
    echo "Usage: ssh user@host"
    return 1
  fi
  ssh "$@"
}

scp_cmd() {
  if [ $# -lt 2 ]; then
    echo "Usage: scp source destination"
    return 1
  fi
  scp "$@"
}

cmd="$1"
shift

case "${cmd,,}" in
  update)
    update
    ;;
  ssh)
    ssh_cmd "$@"
    ;;
  scp)
    scp_cmd "$@"
    ;;
  *)
    echo "Unknown command: $cmd"
    ;;
esac
