#!/bin/bash
set -e

TARGET_DIR="/1002xCMD"

echo "🗑️ Removing 1002xCMD directory at $TARGET_DIR ..."
rm -rf "$TARGET_DIR"

echo "🧹 Removing aliases from /etc/bash.bashrc ..."
sed -i '/alias 1002xCMD=/d' /etc/bash.bashrc
sed -i '/alias cmd=/d' /etc/bash.bashrc
source /etc/bash.bashrc


echo "🗑️ Removing desktop entry /usr/share/applications/1002xCMD.desktop ..."
rm -f /usr/share/applications/1002xCMD.desktop

echo "✅ 1002xCMD has been uninstalled successfully."
