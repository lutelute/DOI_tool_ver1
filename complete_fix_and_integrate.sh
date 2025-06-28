#!/bin/bash

echo "🔧 DOI Tool ファイルブラウザGUI 完全修正・統合"
echo "============================================="

BASE_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"

# 1. 完全版ファイルで置き換え
echo "📝 完全版ファイルブラウザGUIに置き換え中..."
cp "$BASE_DIR/gui_file_browser_complete.py" "$BASE_DIR/gui_file_browser.py"
echo "✅ ファイル置き換え完了"

# 2. 実行権限設定
chmod +x "$BASE_DIR/gui_file_browser.py"
chmod +x "$BASE_DIR"/*.sh

echo "✅ 実行権限設定完了"

# 3. 構文チェック
echo ""
echo "🔍 Python構文チェック中..."
python3 -m py_compile "$BASE_DIR/gui_file_browser.py"

if [ $? -eq 0 ]; then
    echo "✅ 構文チェック成功"
else
    echo "❌ 構文エラーが残っています"
    exit 1
fi

# 4. テスト実行
echo ""
echo "🧪 ファイルブラウザGUI テスト実行"
echo "------------------------------"

# バックグラウンドで起動
python3 "$BASE_DIR/gui_file_browser.py" &
TEST_PID=$!

echo "📱 ファイルブラウザGUI起動中... (PID: $TEST_PID)"
echo "   3秒間動作確認します..."

sleep 3

if ps -p $TEST_PID > /dev/null 2>&1; then
    echo "✅ ファイルブラウザGUI正常動作"
    echo "💡 GUIウィンドウが表示されていることを確認してください"
    
    # プロセス終了
    kill $TEST_PID 2>/dev/null
    sleep 1
    
    echo "✅ テスト完了"
    
else
    echo "❌ ファイルブラウザGUI起動失敗"
    exit 1
fi

# 5. アプリケーションに統合
echo ""
echo "📱 アプリケーションに統合中..."

APP_PATH="$BASE_DIR/app_build/standalone/DOI Tool.app"
RESOURCES_DIR="$APP_PATH/Contents/Resources"

# バックアップ作成
if [ -f "$RESOURCES_DIR/gui_main.py" ]; then
    cp "$RESOURCES_DIR/gui_main.py" "$RESOURCES_DIR/gui_main_backup_$(date +%Y%m%d_%H%M%S).py"
    echo "✅ 既存GUIをバックアップ"
fi

# 新しいGUIを統合
cp "$BASE_DIR/gui_file_browser.py" "$RESOURCES_DIR/gui_main.py"
echo "✅ ファイルブラウザGUIをアプリに統合"

# アプリのタイムスタンプ更新
touch "$APP_PATH"
touch "$APP_PATH/Contents/Info.plist"
touch "$RESOURCES_DIR"

echo "✅ アプリ統合完了"

# 6. 最終動作確認
echo ""
echo "🎉 完全修正・統合完了！"
echo ""
echo "📋 新機能:"
echo "   🖥️ Finderライクなファイルブラウザ"
echo "   📁 直感的なフォルダナビゲーション"
echo "   📄 CSVファイル自動検出・強調表示"
echo "   🔢 複数ファイル選択対応"
echo "   🚀 ワンクリック処理開始"
echo "   📊 リアルタイム処理ログ"
echo "   📁 結果フォルダ自動オープン"
echo ""
echo "🚀 起動方法:"
echo "   1. アプリから起動:"
echo "      open \"$APP_PATH\""
echo ""
echo "   2. ターミナルから直接テスト:"
echo "      python3 \"$BASE_DIR/gui_file_browser.py\""
echo ""
echo "📖 使用方法:"
echo "   1. アプリを起動"
echo "   2. フォルダを移動してCSVファイルを探す"
echo "   3. CSVファイルを選択 (複数選択可能)"
echo "   4. 「🚀 処理開始」ボタンをクリック"
echo "   5. 処理完了後、md_folderにMarkdownファイルが生成"
echo ""

# 7. 今すぐテスト実行
echo "🧪 今すぐアプリをテスト起動しますか？"
echo "1) アプリ起動 (推奨)"
echo "2) ターミナルでテスト"
echo "3) 後で手動起動"
echo ""

read -p "選択 (1-3): " -n 1 -r
echo

case $REPLY in
    1)
        echo "🚀 アプリ起動中..."
        open "$APP_PATH"
        echo ""
        echo "✅ DOI Tool アプリを起動しました！"
        echo "   美しいFinderライクなインターフェースをお楽しみください"
        echo ""
        echo "💡 使用のヒント:"
        echo "   • サイドバーの「📄 デスクトップ」をクリックしてファイルを探す"
        echo "   • CSVファイルは緑色で強調表示されます"
        echo "   • 複数ファイル選択はCtrl+クリック"
        echo "   • ダブルクリックで即座に処理開始"
        ;;
    2)
        echo "🚀 ターミナルでテスト起動中..."
        python3 "$BASE_DIR/gui_file_browser.py"
        ;;
    3)
        echo "👍 後で以下のコマンドで起動してください:"
        echo "   open \"$APP_PATH\""
        ;;
esac

echo ""
echo "✨ DOI Tool ファイルブラウザGUI 完成！"
echo ""
echo "📱 アプリ場所: $APP_PATH"
echo "🧪 テストスクリプト: python3 \"$BASE_DIR/gui_file_browser.py\""
echo "📖 詳細ガイド: $BASE_DIR/FILE_BROWSER_GUIDE.md"
echo ""
