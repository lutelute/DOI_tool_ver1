#!/bin/bash

echo "🔧 実行権限一括設定"

# プロジェクトのベースディレクトリ
BASE_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"

# メインアプリの実行権限
chmod +x "$BASE_DIR/app_build/standalone/DOI Tool.app/Contents/MacOS/DOI_Tool"

# セットアップスクリプトの実行権限
chmod +x "$BASE_DIR/complete_setup.sh"
chmod +x "$BASE_DIR/test_app.sh"
chmod +x "$BASE_DIR/setup_icon.sh"

# その他のシェルスクリプト
find "$BASE_DIR" -name "*.sh" -exec chmod +x {} \;

echo "✅ 全ての実行権限が設定されました"

# 実行可能ファイルの一覧表示
echo ""
echo "📋 実行可能ファイル確認:"
ls -la "$BASE_DIR/app_build/standalone/DOI Tool.app/Contents/MacOS/DOI_Tool"
ls -la "$BASE_DIR/complete_setup.sh"

echo ""
echo "🚀 セットアップを実行するには:"
echo "   $BASE_DIR/complete_setup.sh"
