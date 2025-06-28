#!/bin/bash

echo "🔧 実行権限設定スクリプト"

# メインの実行ファイル
chmod +x "/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/standalone/DOI Tool.app/Contents/MacOS/DOI_Tool"

# テストスクリプト
chmod +x "/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/test_app.sh"

# その他のスクリプトファイル
chmod +x "/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build"/*.sh
chmod +x "/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"/*.sh

echo "✅ 全ての実行権限が設定されました"

# 権限確認
echo "📋 実行ファイルの権限確認:"
ls -la "/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/standalone/DOI Tool.app/Contents/MacOS/DOI_Tool"
