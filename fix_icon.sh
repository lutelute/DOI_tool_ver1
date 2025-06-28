#!/bin/bash

echo "🎨 DOI Tool アイコン修正スクリプト"
echo "================================="

APP_PATH="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/standalone/DOI Tool.app"
ICON_SOURCE="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/icons/DOI_Tool.icns"
RESOURCES_DIR="$APP_PATH/Contents/Resources"

echo ""
echo "🔍 現在の状況確認:"

# 1. アイコンファイルの存在確認
if [ -f "$RESOURCES_DIR/DOI_Tool.icns" ]; then
    size=$(stat -f%z "$RESOURCES_DIR/DOI_Tool.icns" 2>/dev/null || echo "0")
    echo "✅ アイコンファイル存在: DOI_Tool.icns (${size} bytes)"
else
    echo "❌ アイコンファイルなし"
fi

# 2. Info.plistの確認
if grep -q "CFBundleIconFile" "$APP_PATH/Contents/Info.plist"; then
    icon_name=$(grep -A1 "CFBundleIconFile" "$APP_PATH/Contents/Info.plist" | grep "<string>" | sed 's/.*<string>\(.*\)<\/string>.*/\1/')
    echo "✅ Info.plistアイコン設定: $icon_name"
else
    echo "❌ Info.plistアイコン設定なし"
fi

echo ""
echo "🔧 アイコン修正開始:"

# 3. アイコンファイルを再コピー（念のため）
echo "📁 アイコンファイル再配置中..."
if [ -f "$ICON_SOURCE" ]; then
    cp "$ICON_SOURCE" "$RESOURCES_DIR/"
    echo "✅ アイコンファイル再配置完了"
else
    echo "❌ ソースアイコンファイルが見つかりません: $ICON_SOURCE"
fi

# 4. Info.plistの拡張属性をクリア
echo "🗂️ Info.plist拡張属性クリア中..."
xattr -c "$APP_PATH/Contents/Info.plist" 2>/dev/null || true
echo "✅ Info.plist拡張属性クリア完了"

# 5. アプリバンドル全体の拡張属性をクリア
echo "📱 アプリバンドル拡張属性クリア中..."
xattr -cr "$APP_PATH" 2>/dev/null || true
echo "✅ アプリバンドル拡張属性クリア完了"

# 6. アプリのタイムスタンプを更新
echo "⏰ アプリタイムスタンプ更新中..."
touch "$APP_PATH"
touch "$APP_PATH/Contents"
touch "$APP_PATH/Contents/Info.plist"
touch "$RESOURCES_DIR/DOI_Tool.icns"
echo "✅ タイムスタンプ更新完了"

# 7. LaunchServicesデータベースを更新
echo "🔄 LaunchServicesデータベース更新中..."
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP_PATH"
echo "✅ LaunchServicesデータベース更新完了"

# 8. アイコンキャッシュをクリア
echo "🧹 アイコンキャッシュクリア中..."

# ユーザーレベルのアイコンキャッシュクリア
rm -rf ~/Library/Caches/com.apple.iconservices.store 2>/dev/null || true
rm -rf ~/Library/Caches/com.apple.IconServices 2>/dev/null || true

# Finderを再起動
echo "🔄 Finder再起動中..."
killall Finder 2>/dev/null || true

# Dockを再起動  
echo "🔄 Dock再起動中..."
killall Dock 2>/dev/null || true

sleep 2

echo "✅ キャッシュクリア完了"

# 9. アプリの権限を再設定
echo "🔐 アプリ権限再設定中..."
chmod +x "$APP_PATH/Contents/MacOS/DOI_Tool"
chmod 644 "$APP_PATH/Contents/Info.plist"
chmod 644 "$RESOURCES_DIR/DOI_Tool.icns"
echo "✅ アプリ権限再設定完了"

echo ""
echo "🎯 最終確認:"

# アイコンファイルサイズ確認
if [ -f "$RESOURCES_DIR/DOI_Tool.icns" ]; then
    size=$(stat -f%z "$RESOURCES_DIR/DOI_Tool.icns")
    echo "✅ アイコンファイル: ${size} bytes"
    
    # アイコンファイルの内容確認
    if file "$RESOURCES_DIR/DOI_Tool.icns" | grep -q "icon"; then
        echo "✅ アイコンファイル形式正常"
    else
        echo "⚠️  アイコンファイル形式要確認"
    fi
else
    echo "❌ アイコンファイル見つからず"
fi

echo ""
echo "🎉 アイコン修正完了！"
echo ""
echo "📋 確認方法:"
echo "   1. Finderでアプリケーションを表示"
echo "   2. アイコンが変更されているか確認"
echo "   3. 変更されていない場合は数分待つ"
echo ""
echo "💡 それでも表示されない場合:"
echo "   • Macを再起動"
echo "   • アプリを一度ゴミ箱に入れて戻す"
echo "   • 'sudo purge' でメモリキャッシュクリア"
echo ""
echo "🚀 アプリを開いて確認:"
open "$APP_PATH"
echo "   アプリケーションが起動しました"
echo ""
