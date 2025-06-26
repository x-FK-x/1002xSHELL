#!/bin/bash

# random.sh – graphical app launcher (currently supports only 'firefox')

CMD="$1"

function is_root() {
    [[ "$(id -u)" -eq 0 ]]
}

function run_as_root() {
    if is_root; then
        "$@"
    else
        sudo "$@"
    fi
}

function install_package_if_missing() {
    local pkg="$1"
    if ! dpkg -s "$pkg" &>/dev/null; then
        echo "Package '$pkg' is not installed."
        read -p "Do you want to install $pkg? (y/n): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            run_as_root apt-get update
            run_as_root apt-get install -y "$pkg"
        else
            echo "$pkg not installed. Aborting."
            exit 1
        fi
    fi
}

case "$CMD" in
firefox)
    install_package_if_missing xinit
    install_package_if_missing firefox-esr
    echo "Starting Firefox (firefox-esr) via xinit..."
    xinit firefox-esr &
    ;;
*)
    echo "Invalid usage. Supported: firefox"
    echo "Usage: firefox"
    ;;
esac
