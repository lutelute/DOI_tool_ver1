#!/bin/bash

echo "📱 DOI Tool アイコン設定スクリプト"

ICON_SOURCE="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/icons/DOI_Tool.icns"
RESOURCES_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/standalone/DOI Tool.app/Contents/Resources"

echo "🎨 アイコンファイルをコピー中..."

# アイコンファイルをResourcesディレクトリにコピー
cp "$ICON_SOURCE" "$RESOURCES_DIR/"

echo "✅ アイコンファイルがコピーされました"

# アイコンファイルの確認
echo "📋 コピー結果確認:"
ls -la "$RESOURCES_DIR/DOI_Tool.icns"

echo ""
echo "🔄 Finderのアイコンキャッシュをクリア..."
sudo find /private/var/folders/ -name "com.apple.dock.iconcache" -exec rm {} \;
killall Dock

echo "✨ アイコン設定完了！"
echo "   Dockが再起動され、新しいアイコンが表示されます。"
