#!/bin/bash

echo "🔧 DOI Tool ファイルブラウザGUI 修正・統合"
echo "=========================================="

BASE_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"

# 1. 修正版ファイルを置き換え
echo "📝 修正版ファイルブラウザGUIに置き換え中..."
cp "$BASE_DIR/gui_file_browser_fixed.py" "$BASE_DIR/gui_file_browser.py"
echo "✅ ファイル置き換え完了"

# 2. 実行権限設定
chmod +x "$BASE_DIR/gui_file_browser.py"
chmod +x "$BASE_DIR"/*.sh

echo "✅ 実行権限設定完了"

# 3. テスト実行
echo ""
echo "🧪 修正版ファイルブラウザGUI テスト実行"
echo "------------------------------------"

python3 "$BASE_DIR/gui_file_browser.py" &
TEST_PID=$!

echo "📱 ファイルブラウザGUI起動中... (PID: $TEST_PID)"
echo "   ウィンドウが表示されるまで数秒お待ちください"

sleep 3

if ps -p $TEST_PID > /dev/null 2>&1; then
    echo "✅ ファイルブラウザGUI正常起動"
    echo "💡 ウィンドウを確認してテストしてください"
    echo "   テスト完了後、ウィンドウを閉じてください"
    
    # ユーザーの確認待ち
    echo ""
    read -p "テストが完了したらEnterキーを押してください..."
    
    # プロセス終了
    if ps -p $TEST_PID > /dev/null 2>&1; then
        kill $TEST_PID 2>/dev/null
    fi
    
    echo "✅ テスト完了"
    
else
    echo "❌ ファイルブラウザGUI起動失敗"
    echo "💡 エラー詳細を確認してください:"
    echo "   python3 '$BASE_DIR/gui_file_browser.py'"
    exit 1
fi

# 4. アプリケーションに統合
echo ""
echo "📱 アプリケーションに統合中..."

APP_PATH="$BASE_DIR/app_build/standalone/DOI Tool.app"
RESOURCES_DIR="$APP_PATH/Contents/Resources"

# バックアップ
if [ -f "$RESOURCES_DIR/gui_main.py" ]; then
    cp "$RESOURCES_DIR/gui_main.py" "$RESOURCES_DIR/gui_main_backup.py"
    echo "✅ 元のGUIをバックアップ"
fi

# 修正版GUIをアプリに統合
cp "$BASE_DIR/gui_file_browser.py" "$RESOURCES_DIR/gui_main.py"
echo "✅ ファイルブラウザGUIをアプリに統合"

# アプリのタイムスタンプ更新
touch "$APP_PATH"
touch "$APP_PATH/Contents/Info.plist"
touch "$RESOURCES_DIR"

echo "✅ アプリ統合完了"

# 5. 最終確認
echo ""
echo "🎉 修正・統合完了！"
echo ""
echo "📋 実行方法:"
echo "   1. アプリから起動:"
echo "      open \"$APP_PATH\""
echo ""
echo "   2. ターミナルから直接テスト:"
echo "      python3 \"$BASE_DIR/gui_file_browser.py\""
echo ""
echo "💡 機能確認:"
echo "   ✅ Finderライクなファイルブラウザ"
echo "   ✅ フォルダナビゲーション"
echo "   ✅ CSVファイル自動検出・強調"
echo "   ✅ 複数ファイル選択"
echo "   ✅ ワンクリック処理開始"
echo "   ✅ リアルタイム処理ログ"
echo ""

# 今すぐテスト実行
echo "🚀 今すぐアプリをテスト起動しますか？"
read -p "(y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 アプリ起動中..."
    open "$APP_PATH"
    echo "✅ アプリを起動しました！"
    echo "   Finderライクなインターフェースをお楽しみください"
else
    echo "👍 後で手動起動してください"
fi

echo ""
echo "✨ 修正・統合作業完了！"
