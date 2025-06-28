#!/bin/bash

echo "🔍 DOI Tool アプリ デバッグ・診断スクリプト"
echo "=============================================="

APP_PATH="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/standalone/DOI Tool.app"
EXECUTABLE="$APP_PATH/Contents/MacOS/DOI_Tool"
RESOURCES_DIR="$APP_PATH/Contents/Resources"

echo ""
echo "📋 システム情報:"
echo "   macOS バージョン: $(sw_vers -productVersion)"
echo "   Python バージョン: $(python3 --version)"
echo "   実行ユーザー: $(whoami)"

echo ""
echo "📱 アプリケーション構造チェック:"

if [ -d "$APP_PATH" ]; then
    echo "   ✅ アプリディレクトリ存在: $APP_PATH"
else
    echo "   ❌ アプリディレクトリなし: $APP_PATH"
    exit 1
fi

if [ -f "$EXECUTABLE" ]; then
    echo "   ✅ 実行ファイル存在: $EXECUTABLE"
    echo "   権限: $(ls -la "$EXECUTABLE" | awk '{print $1, $3, $4}')"
else
    echo "   ❌ 実行ファイルなし: $EXECUTABLE"
fi

if [ -f "$APP_PATH/Contents/Info.plist" ]; then
    echo "   ✅ Info.plist存在"
    echo "   バンドル名: $(defaults read "$APP_PATH/Contents/Info.plist" CFBundleName 2>/dev/null || echo "不明")"
    echo "   バンドルID: $(defaults read "$APP_PATH/Contents/Info.plist" CFBundleIdentifier 2>/dev/null || echo "不明")"
else
    echo "   ❌ Info.plistなし"
fi

echo ""
echo "🐍 Pythonスクリプトチェック:"
required_scripts=("gui_main.py" "combine_scopus_csv.py" "scopus_doi_to_json.py" "json2tag_ref_scopus_async.py" "add_abst_scopus.py")

for script in "${required_scripts[@]}"; do
    if [ -f "$RESOURCES_DIR/$script" ]; then
        file_size=$(stat -f%z "$RESOURCES_DIR/$script" 2>/dev/null || echo "0")
        echo "   ✅ $script (${file_size} bytes)"
    else
        echo "   ❌ $script"
    fi
done

echo ""
echo "🎨 アイコンファイルチェック:"
if [ -f "$RESOURCES_DIR/DOI_Tool.icns" ]; then
    file_size=$(stat -f%z "$RESOURCES_DIR/DOI_Tool.icns" 2>/dev/null || echo "0")
    echo "   ✅ DOI_Tool.icns (${file_size} bytes)"
else
    echo "   ❌ DOI_Tool.icns なし"
fi

echo ""
echo "📦 Python依存関係チェック:"
python3 -c "
import sys
modules = [
    ('tkinter', 'GUI framework'),
    ('pandas', 'データ処理'),
    ('requests', 'HTTP通信'),
    ('tqdm', 'プログレスバー'),
    ('json', '標準ライブラリ'),
    ('os', '標準ライブラリ'),
    ('subprocess', '標準ライブラリ'),
    ('threading', '標準ライブラリ')
]

missing = []
for module, desc in modules:
    try:
        __import__(module)
        print(f'   ✅ {module} ({desc})')
    except ImportError:
        print(f'   ❌ {module} ({desc}) - インストール必要')
        missing.append(module)

if missing:
    print('')
    print('🚨 不足モジュール:', ', '.join(missing))
    print('   インストール: pip3 install', ' '.join(m for m in missing if m not in ['tkinter']))
"

echo ""
echo "🧪 アプリケーション動作テスト:"

echo "   1. GUI起動テスト (5秒後に自動終了)..."
timeout 5 python3 "$RESOURCES_DIR/gui_main.py" >/dev/null 2>&1 &
TEST_PID=$!
sleep 1

if ps -p $TEST_PID > /dev/null 2>&1; then
    echo "   ✅ GUIアプリケーション正常起動"
    kill $TEST_PID 2>/dev/null
else
    echo "   ❌ GUIアプリケーション起動失敗"
    echo "   詳細確認: python3 '$RESOURCES_DIR/gui_main.py'"
fi

echo ""
echo "   2. 実行スクリプトテスト..."
if [ -x "$EXECUTABLE" ]; then
    echo "   ✅ 実行スクリプト実行可能"
else
    echo "   ❌ 実行スクリプト実行不可"
    echo "   修正: chmod +x '$EXECUTABLE'"
fi

echo ""
echo "🚀 推奨アクション:"

if [ ! -f "$RESOURCES_DIR/DOI_Tool.icns" ]; then
    echo "   1. アイコン設定: ./setup_icon.sh"
fi

echo "   2. 完全セットアップ: ./complete_setup.sh"
echo "   3. アプリ起動: open '$APP_PATH'"
echo "   4. 直接起動: python3 '$RESOURCES_DIR/gui_main.py'"

echo ""
echo "📞 トラブルシューティング:"
echo "   • アプリが起動しない → Pythonとtkinterの確認"
echo "   • アイコンが表示されない → Dockの再起動 (killall Dock)"
echo "   • 処理エラー → ネットワーク接続とCSVファイル形式の確認"

echo ""
echo "✨ 診断完了！"
