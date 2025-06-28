#!/bin/bash

echo "🔧 最終実行権限設定"

BASE_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"

# 全シェルスクリプトに実行権限付与
find "$BASE_DIR" -name "*.sh" -exec chmod +x {} \;

# アプリ実行ファイルに実行権限付与  
chmod +x "$BASE_DIR/app_build/standalone/DOI Tool.app/Contents/MacOS/DOI_Tool"

echo "✅ 全実行権限設定完了"
echo ""
echo "🚀 アプリ起動・テスト実行:"
echo "   $BASE_DIR/final_test_and_launch.sh"
echo ""
