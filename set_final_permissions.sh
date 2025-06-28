#!/bin/bash

echo "🔧 DOI Tool - 全ファイル実行権限設定"
echo "=================================="

BASE_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"

# 全シェルスクリプトに実行権限
find "$BASE_DIR" -name "*.sh" -exec chmod +x {} \;

# Pythonスクリプトに実行権限
find "$BASE_DIR" -name "*.py" -exec chmod +x {} \;

# アプリ実行ファイルに実行権限
chmod +x "$BASE_DIR/app_build/standalone/DOI Tool.app/Contents/MacOS/DOI_Tool"

echo "✅ 全ファイル実行権限設定完了"
echo ""
echo "🚀 ファイルブラウザGUI統合を実行:"
echo "   $BASE_DIR/integrate_file_browser.sh"
echo ""
