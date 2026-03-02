#!/bin/bash
set -e

# Change these to your GitHub repo details
REPO_USER="mikeygnyc"
REPO_NAME="k8s-pvc-shrink"
TARGET="kubectl-pvc-shrink"
RAW_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/main"

if command -v brew >/dev/null 2>&1; then
    BIN_DIR="$(brew --prefix)/bin"
else
    BIN_DIR="/usr/local/bin"
fi

echo "🚀 Installing $TARGET to $BIN_DIR..."

if [[ -f "./$TARGET" ]]; then
    CMD="cp ./$TARGET"
else
    CMD="curl -fsSL $RAW_URL/$TARGET -o"
fi

if [ -w "$BIN_DIR" ]; then
    $CMD "$BIN_DIR/$TARGET" && chmod +x "$BIN_DIR/$TARGET"
else
    sudo $CMD "$BIN_DIR/$TARGET" && sudo chmod +x "$BIN_DIR/$TARGET"
fi

echo "✅ Installed! run 'kubectl pvc-shrink' to begin."