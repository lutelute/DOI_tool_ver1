#!/bin/bash

echo "🎨 DOI Tool アイコン強制適用スクリプト"
echo "====================================="

APP_PATH="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/standalone/DOI Tool.app"
ICON_SOURCE="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/icons/DOI_Tool.icns"

echo ""
echo "🔍 問題診断:"

# 1. アイコンファイルの詳細確認
echo "📁 アイコンファイル詳細:"
if [ -f "$ICON_SOURCE" ]; then
    ls -la "$ICON_SOURCE"
    file "$ICON_SOURCE"
    echo ""
else
    echo "❌ ソースアイコンファイルなし"
    exit 1
fi

# 2. 現在のアプリアイコン確認
echo "📱 現在のアプリアイコン:"
if [ -f "$APP_PATH/Contents/Resources/DOI_Tool.icns" ]; then
    ls -la "$APP_PATH/Contents/Resources/DOI_Tool.icns"
    file "$APP_PATH/Contents/Resources/DOI_Tool.icns"
else
    echo "❌ アプリアイコンファイルなし"
fi

echo ""
echo "🔧 アイコン強制適用開始:"

# 方法1: アイコンファイルを再作成
echo "1️⃣ アイコンファイル再作成..."

# 元のiconsetから.icnsを再生成
ICONSET_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/icons/DOI_Tool.iconset"
if [ -d "$ICONSET_DIR" ]; then
    echo "   iconsetから.icns再生成中..."
    iconutil -c icns "$ICONSET_DIR" -o "/tmp/DOI_Tool_new.icns"
    
    if [ -f "/tmp/DOI_Tool_new.icns" ]; then
        echo "   ✅ 新しい.icnsファイル生成成功"
        
        # 新しいアイコンをアプリにコピー
        cp "/tmp/DOI_Tool_new.icns" "$APP_PATH/Contents/Resources/DOI_Tool.icns"
        echo "   ✅ 新しいアイコンをアプリに適用"
        
        # 一時ファイルクリーンアップ
        rm "/tmp/DOI_Tool_new.icns"
    else
        echo "   ❌ .icns再生成失敗"
    fi
else
    echo "   ⚠️  iconsetディレクトリなし、既存ファイルを使用"
    cp "$ICON_SOURCE" "$APP_PATH/Contents/Resources/DOI_Tool.icns"
fi

# 方法2: Info.plistを完全に書き直し
echo ""
echo "2️⃣ Info.plist更新..."

cat > "$APP_PATH/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>DOI_Tool</string>
    <key>CFBundleIconFile</key>
    <string>DOI_Tool</string>
    <key>CFBundleIconName</key>
    <string>DOI_Tool</string>
    <key>CFBundleIdentifier</key>
    <string>com.doitool.app</string>
    <key>CFBundleName</key>
    <string>DOI Tool</string>
    <key>CFBundleDisplayName</key>
    <string>DOI処理ツール</string>
    <key>CFBundleVersion</key>
    <string>1.0.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>DOIT</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2025, DOI Tool</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.14</string>
</dict>
</plist>
EOF

echo "   ✅ Info.plist更新完了"

# 方法3: システムキャッシュ完全クリア
echo ""
echo "3️⃣ システムキャッシュ完全クリア..."

# より徹底的なキャッシュクリア
sudo rm -rf /Library/Caches/com.apple.iconservices.store 2>/dev/null || true
rm -rf ~/Library/Caches/com.apple.iconservices.store 2>/dev/null || true
rm -rf ~/Library/Caches/com.apple.IconServices 2>/dev/null || true

# LaunchServicesの再構築
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

echo "   ✅ システムキャッシュクリア完了"

# 方法4: アプリバンドルのメタデータ更新
echo ""
echo "4️⃣ アプリメタデータ更新..."

# PkgInfoファイル作成（古い方法だが確実）
echo "APPLDOIT" > "$APP_PATH/Contents/PkgInfo"

# バンドル構造の権限再設定
find "$APP_PATH" -type f -exec chmod 644 {} \;
find "$APP_PATH" -type d -exec chmod 755 {} \;
chmod +x "$APP_PATH/Contents/MacOS/DOI_Tool"

echo "   ✅ アプリメタデータ更新完了"

# 方法5: 強制的なシステム通知
echo ""
echo "5️⃣ システム強制更新..."

# アプリのタイムスタンプを現在時刻に更新
touch "$APP_PATH"
touch "$APP_PATH/Contents"
touch "$APP_PATH/Contents/Info.plist"
touch "$APP_PATH/Contents/Resources"
touch "$APP_PATH/Contents/Resources/DOI_Tool.icns"

# LaunchServicesに強制登録
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP_PATH"

# より強力なFinderリセット
killall Finder
killall Dock

echo "   ✅ システム強制更新完了"

echo ""
echo "🔄 最終処理..."
sleep 3

echo ""
echo "🎉 アイコン強制適用完了！"
echo ""
echo "📋 確認手順:"
echo "   1. 約30秒待つ（システム更新時間）"
echo "   2. Finderでアプリを表示"
echo "   3. アイコンの変更を確認"
echo ""
echo "💡 まだ変更されない場合:"
echo "   • Macを再起動してください"
echo "   • 'sudo purge' でメモリキャッシュをクリア"
echo "   • アプリを他の場所に移動して戻す"
echo ""
echo "🎯 アプリを開いて動作確認:"
sleep 2
open "$APP_PATH"
echo "   ✅ アプリケーション起動"
echo ""

# 最終確認情報表示
echo "📊 最終状態:"
echo "   アプリ: $APP_PATH"
echo "   アイコン: $(ls -la "$APP_PATH/Contents/Resources/DOI_Tool.icns" | awk '{print $5}') bytes"
echo "   Info.plist: ✅ 更新済み"
echo ""
