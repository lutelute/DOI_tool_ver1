#!/bin/bash

echo "🔧 DOI Tool - 最終権限設定"
echo "=========================="

BASE_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"

echo "📝 実行権限を設定中..."

# メインアプリの実行ファイル
chmod +x "$BASE_DIR/app_build/standalone/DOI Tool.app/Contents/MacOS/DOI_Tool"

# 全てのシェルスクリプト
chmod +x "$BASE_DIR/complete_setup.sh"
chmod +x "$BASE_DIR/fix_permissions.sh"
chmod +x "$BASE_DIR/diagnose_app.sh"
chmod +x "$BASE_DIR/test_app.sh"
chmod +x "$BASE_DIR/setup_icon.sh"

# app_buildディレクトリ内のスクリプト
find "$BASE_DIR/app_build" -name "*.sh" -exec chmod +x {} \;

echo "✅ 権限設定完了"

echo ""
echo "📋 設定されたファイル:"
echo "   ✅ DOI Tool.app 実行ファイル"
echo "   ✅ complete_setup.sh"
echo "   ✅ diagnose_app.sh"  
echo "   ✅ test_app.sh"
echo "   ✅ その他全シェルスクリプト"

echo ""
echo "🚀 これで準備完了です！"
echo ""
echo "次のコマンドを実行してアプリをセットアップ・起動してください："
echo "   ./complete_setup.sh"
echo ""
