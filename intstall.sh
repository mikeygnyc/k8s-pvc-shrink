#!/bin/bash
set -e

REPO_USER="mikeygnyc"
REPO_NAME="k8s-pvc-shrink"
TARGET="kubectl-pvc-shrink"
RAW_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main"

# Detect Path
if command -v brew >/dev/null 2>&1; then
    BIN_DIR="$(brew --prefix)/bin"
else
    BIN_DIR="/usr/local/bin"
fi

echo "🚀 Installing $TARGET to $BIN_DIR..."

# Added quotes to variables below to satisfy SC2086
if [[ -f "./$TARGET" ]]; then
    cp "./$TARGET" "$BIN_DIR/$TARGET"
else
    curl -fsSL "$RAW_URL/$TARGET" -o "$BIN_DIR/$TARGET"
fi

if [ -w "$BIN_DIR" ]; then
    chmod +x "$BIN_DIR/$TARGET"
else
    sudo chmod +x "$BIN_DIR/$TARGET"
fi

echo "✅ Installed! Run 'kubectl pvc-shrink' to start."