#!/bin/bash
set -e

TARGET_DIR="/1002xSHELL"
SRC_DIR="$(dirname "$(realpath "$0")")"

echo "📁 Creating target directory $TARGET_DIR if not exists..."
mkdir -p "$TARGET_DIR"

echo "📁 Moving 1002xSHELL contents to $TARGET_DIR ..."
shopt -s extglob
mv "$SRC_DIR"/!(installer.sh) "$TARGET_DIR"/

echo "✅ Setting permissions..."
chmod -R +x "$TARGET_DIR"/*.sh
chmod -R +x "$TARGET_DIR/commands"/*.sh

echo "📁 Creating virtual drive C: at $TARGET_DIR/Cx ..."
mkdir -p "$TARGET_DIR/Cx"
chmod 777 "$TARGET_DIR/Cx"

# Alias in /etc/bash.bashrc eintragen (wenn nicht schon vorhanden)
if ! grep -q "alias 1002xSHELL=" /etc/bash.bashrc; then
  echo "alias 1002xSHELL='$TARGET_DIR/xdos.sh'" >> /etc/bash.bashrc
  echo "alias cmd='$TARGET_DIR/xdos.sh'" >> /etc/bash.bashrc
  echo "✅ Added aliases 1002xSHELL and cmd to /etc/bash.bashrc"
  source /etc/bash.bashrc
fi

echo "📁 Creating menu entry for graphical desktop..."
cat > /usr/share/applications/1002xSHELL.desktop <<EOF
[Desktop Entry]
Name=1002xSHELL
Comment=DOS-like shell for Debian
Exec=$TARGET_DIR/xdos.sh
Icon=utilities-terminal
Terminal=true
Type=Application
Categories=Utility;System;
EOF

echo "✅ Installation completed successfully!"
echo "Run '1002xSHELL' or 'cmd' in your terminal to start the shell."

