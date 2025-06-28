#!/bin/bash

echo "🔧 DOI Tool ファイルブラウザGUI 最終修正・統合"
echo "=============================================="

BASE_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"

# 1. 最終版ファイルで置き換え
echo "📝 最終版ファイルブラウザGUIに置き換え中..."
cp "$BASE_DIR/gui_file_browser_final.py" "$BASE_DIR/gui_file_browser.py"
echo "✅ ファイル置き換え完了"

# 2. 実行権限設定
chmod +x "$BASE_DIR/gui_file_browser.py"
chmod +x "$BASE_DIR"/*.sh

echo "✅ 実行権限設定完了"

# 3. Python構文チェック
echo ""
echo "🔍 Python構文チェック中..."
python3 -m py_compile "$BASE_DIR/gui_file_browser.py"

if [ $? -eq 0 ]; then
    echo "✅ 構文チェック成功 - エラーなし"
else
    echo "❌ 構文エラーが残っています"
    echo "エラー詳細:"
    python3 "$BASE_DIR/gui_file_browser.py"
    exit 1
fi

# 4. 簡単な動作テスト
echo ""
echo "🧪 ファイルブラウザGUI 動作テスト"
echo "------------------------------"

# 3秒間の動作テスト
timeout 3 python3 "$BASE_DIR/gui_file_browser.py" >/dev/null 2>&1 &
TEST_PID=$!

echo "📱 ファイルブラウザGUI起動テスト中... (PID: $TEST_PID)"

sleep 1

if ps -p $TEST_PID > /dev/null 2>&1; then
    echo "✅ ファイルブラウザGUI正常起動"
    
    # プロセス終了
    kill $TEST_PID 2>/dev/null
    sleep 1
    
    echo "✅ 動作テスト成功"
    
else
    echo "❌ ファイルブラウザGUI起動失敗"
    echo "エラー詳細確認:"
    python3 "$BASE_DIR/gui_file_browser.py"
    exit 1
fi

# 5. アプリケーションに統合
echo ""
echo "📱 アプリケーションに統合中..."

APP_PATH="$BASE_DIR/app_build/standalone/DOI Tool.app"
RESOURCES_DIR="$APP_PATH/Contents/Resources"

# 安全なバックアップ
if [ -f "$RESOURCES_DIR/gui_main.py" ]; then
    backup_name="gui_main_backup_$(date +%Y%m%d_%H%M%S).py"
    cp "$RESOURCES_DIR/gui_main.py" "$RESOURCES_DIR/$backup_name"
    echo "✅ 既存GUIをバックアップ: $backup_name"
fi

# 新しいGUIを統合
cp "$BASE_DIR/gui_file_browser.py" "$RESOURCES_DIR/gui_main.py"
echo "✅ ファイルブラウザGUIをアプリに統合"

# アプリのタイムスタンプ更新
touch "$APP_PATH"
touch "$APP_PATH/Contents/Info.plist" 
touch "$RESOURCES_DIR"

echo "✅ アプリ統合完了"

# 6. 最終確認
echo ""
echo "🎉 最終修正・統合完了！"
echo ""
echo "📋 新機能:"
echo "   🖥️ Finderライクなファイルブラウザ"
echo "   📁 直感的なフォルダナビゲーション (◀ ⬆ 🏠)"
echo "   📄 CSVファイル自動検出・緑色強調表示"
echo "   🔢 複数ファイル選択対応 (Ctrl+クリック)"
echo "   🚀 ワンクリック処理開始"
echo "   📊 リアルタイム処理ログ"
echo "   📁 結果フォルダ自動オープン"
echo "   ⚡ クイックアクセス (デスクトップ・ドキュメント等)"
echo ""
echo "🚀 起動方法:"
echo "   1. アプリから起動 (推奨):"
echo "      open \"$APP_PATH\""
echo ""
echo "   2. ターミナルから直接テスト:"
echo "      python3 \"$BASE_DIR/gui_file_browser.py\""
echo ""
echo "📖 使用方法:"
echo "   1. アプリを起動"
echo "   2. サイドバーの「📄 デスクトップ」をクリック"
echo "   3. CSVファイルを探して選択 (緑色で強調表示)"
echo "   4. 「🚀 処理開始」ボタンをクリック"
echo "   5. 処理完了後、md_folderにMarkdownファイルが生成"
echo ""

# 7. 今すぐ起動オプション
echo "🧪 今すぐテストしますか？"
echo "1) アプリ起動 (推奨)"
echo "2) ターミナルでGUI起動"
echo "3) 後で手動起動"
echo ""

read -p "選択 (1-3): " -n 1 -r
echo

case $REPLY in
    1)
        echo "🚀 DOI Tool アプリ起動中..."
        open "$APP_PATH"
        echo ""
        echo "✅ アプリを起動しました！"
        echo ""
        echo "💡 アプリの使い方:"
        echo "   • 美しいFinderライクなインターフェースが表示されます"
        echo "   • 左サイドバーの「📄 デスクトップ」をクリック"
        echo "   • CSVファイルは緑色でハイライト表示されます"
        echo "   • 複数ファイル選択はCtrl+クリック"
        echo "   • CSVファイルをダブルクリックで即座に処理開始"
        echo "   • 処理完了後、結果フォルダが自動で開きます"
        echo ""
        ;;
    2)
        echo "🚀 ターミナルでGUI起動中..."
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
echo "🧪 テストコマンド: python3 \"$BASE_DIR/gui_file_browser.py\""
echo "📖 詳細ガイド: $BASE_DIR/FILE_BROWSER_GUIDE.md"
echo ""
echo "🎊 おめでとうございます！Finderライクなファイルブラウザが完成しました！"
