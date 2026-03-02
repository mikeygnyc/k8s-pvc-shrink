#!/bin/bash
set -e

REPO_USER="mikeygnyc"
REPO_NAME="k8s-pvc-shrink"
TARGET="kubectl-pvcshrink"
RAW_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main"

if command -v brew >/dev/null 2>&1; then
    BIN_DIR="$(brew --prefix)/bin"
else
    BIN_DIR="/usr/local/bin"
fi

echo "🚀 Installing $TARGET to $BIN_DIR..."

if [[ -f "./$TARGET" ]]; then
    cp "./$TARGET" "$BIN_DIR/$TARGET"
else
    curl -fsSL "$RAW_URL/$TARGET" -o "$BIN_DIR/$TARGET"
fi

chmod +x "$BIN_DIR/$TARGET"

echo "✅ Installed! Run 'kubectl pvc-shrink' to start."