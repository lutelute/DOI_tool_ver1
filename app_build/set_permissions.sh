#!/bin/bash

# set_permissions.sh - 実行権限設定

echo "=== 実行権限設定 ==="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 実行権限を付与
chmod +x "$SCRIPT_DIR/quick_install.sh"
chmod +x "$SCRIPT_DIR/install_and_build.sh"
chmod +x "$SCRIPT_DIR/build_app.sh"
chmod +x "$SCRIPT_DIR/fix_tkinter.sh"
chmod +x "$SCRIPT_DIR/standalone_installer.py"
chmod +x "$SCRIPT_DIR/cli_gui.py"

echo "✅ 実行権限を設定しました"
echo ""
echo "次のコマンドでインストールを開始してください："
echo "  ./quick_install.sh"
echo ""
echo "💡 tkinterエラーが発生した場合は、選択肢4（コマンドライン版）をお試しください"
