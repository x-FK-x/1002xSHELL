#!/bin/bash
set -e

TARGET_DIR="/1002xSHELL"

echo "🗑️ Removing 1002xSHELL directory at $TARGET_DIR ..."
rm -rf "$TARGET_DIR"

echo "🧹 Removing aliases from /etc/bash.bashrc ..."
sed -i '/alias 1002xSHELL=/d' /etc/bash.bashrc
sed -i '/alias cmd=/d' /etc/bash.bashrc
source /etc/bash.bashrc


echo "🗑️ Removing desktop entry /usr/share/applications/1002xSHELL.desktop ..."
rm -f /usr/share/applications/1002xSHELL.desktop

echo "✅ 1002xSHELL has been uninstalled successfully."
