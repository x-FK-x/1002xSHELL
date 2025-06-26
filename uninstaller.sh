#!/bin/bash
set -e

TARGET_DIR="/XDOSshell"

echo "🗑️ Removing XDOSshell directory at $TARGET_DIR ..."
rm -rf "$TARGET_DIR"

echo "🧹 Removing aliases from /etc/bash.bashrc ..."
sed -i '/alias XDOSshell=/d' /etc/bash.bashrc
sed -i '/alias cmd=/d' /etc/bash.bashrc
source /etc/bash.bashrc


echo "🗑️ Removing desktop entry /usr/share/applications/xdosshell.desktop ..."
rm -f /usr/share/applications/xdosshell.desktop

echo "✅ XDOSshell has been uninstalled successfully."
