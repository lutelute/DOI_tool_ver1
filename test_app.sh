#!/bin/bash

echo "🚀 DOI Tool macOSアプリのテスト開始"

APP_PATH="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/standalone/DOI Tool.app"
EXECUTABLE="$APP_PATH/Contents/MacOS/DOI_Tool"

echo "📱 アプリパス: $APP_PATH"

# 実行権限を設定
echo "🔧 実行権限を設定中..."
chmod +x "$EXECUTABLE"

# 権限確認
echo "✅ 実行権限確認:"
ls -la "$EXECUTABLE"

echo ""
echo "🎯 アプリ情報:"
echo "   - バンドル名: DOI Tool"
echo "   - 識別子: com.doitool.app" 
echo "   - バージョン: 1.0.0"
echo ""

# アプリケーションを起動
echo "🚀 アプリケーションを起動します..."
open "$APP_PATH"

echo ""
echo "✨ アプリが起動されました！"
echo "   Dockまたはアプリケーションフォルダで確認してください。"
echo ""
echo "📋 使用方法:"
echo "   1. 作業ディレクトリを選択"
echo "   2. CSVファイルが存在することを確認"
echo "   3. '処理を開始'ボタンをクリック"
echo ""
