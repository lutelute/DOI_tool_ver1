#!/bin/bash

echo "🎯 DOI Tool - Finderライク ファイルブラウザGUI 統合"
echo "=================================================="

BASE_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"
APP_PATH="$BASE_DIR/app_build/standalone/DOI Tool.app"
RESOURCES_DIR="$APP_PATH/Contents/Resources"

echo ""
echo "🔧 ファイルブラウザGUI統合開始..."

# 1. 新しいファイルブラウザGUIをアプリに統合
echo "📱 1. ファイルブラウザGUIをアプリにコピー中..."

# 元のGUIをバックアップ
if [ -f "$RESOURCES_DIR/gui_main.py" ]; then
    cp "$RESOURCES_DIR/gui_main.py" "$RESOURCES_DIR/gui_main_simple.py"
    echo "✅ 元のGUIをgui_main_simple.pyとしてバックアップ"
fi

# 新しいファイルブラウザGUIをメインGUIとして設定
cp "$BASE_DIR/gui_file_browser.py" "$RESOURCES_DIR/gui_main.py"
echo "✅ ファイルブラウザGUIをメインGUIとして設定"

# 2. アプリの実行スクリプト確認・更新
echo "📝 2. アプリ実行スクリプト確認中..."

EXEC_SCRIPT="$APP_PATH/Contents/MacOS/DOI_Tool"

cat > "$EXEC_SCRIPT" << 'EOF'
#!/bin/bash
# DOI Tool ファイルブラウザ 実行スクリプト

# アプリケーションのディレクトリを取得
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESOURCES_DIR="$APP_DIR/Contents/Resources"

# Pythonパスを設定
export PYTHONPATH="$RESOURCES_DIR:$PYTHONPATH"

# Resourcesディレクトリに移動
cd "$RESOURCES_DIR"

# Python3でファイルブラウザGUIを起動
python3 gui_main.py
EOF

chmod +x "$EXEC_SCRIPT"
echo "✅ アプリ実行スクリプト更新完了"

# 3. アプリのタイムスタンプ更新
echo "⏰ 3. アプリタイムスタンプ更新中..."
touch "$APP_PATH"
touch "$APP_PATH/Contents"
touch "$APP_PATH/Contents/Info.plist"
touch "$RESOURCES_DIR"
echo "✅ タイムスタンプ更新完了"

# 4. テスト用スタンドアロン起動スクリプト作成
echo "🧪 4. テスト用起動スクリプト作成中..."

cat > "$BASE_DIR/test_file_browser.sh" << EOF
#!/bin/bash

echo "🧪 DOI Tool ファイルブラウザGUI テスト起動"
echo "========================================="

cd "$BASE_DIR"

echo "🚀 ファイルブラウザGUI起動中..."
python3 gui_file_browser.py

echo "✅ ファイルブラウザGUI終了"
EOF

chmod +x "$BASE_DIR/test_file_browser.sh"
echo "✅ テスト用起動スクリプト作成完了"

# 5. 使用方法説明
echo ""
echo "🎉 ファイルブラウザGUI統合完了！"
echo ""
echo "📋 新機能一覧:"
echo "   🖥️ Finderライクなファイルブラウザ"
echo "   📁 フォルダナビゲーション (戻る/上へ/ホーム)"
echo "   📄 CSVファイル自動検出・強調表示"
echo "   🔍 ファイル詳細表示 (サイズ・種類・更新日時)"
echo "   ⚡ クイックアクセス (ホーム・デスクトップ・ドキュメント等)"
echo "   📊 リアルタイム選択情報表示"
echo "   🚀 ワンクリック処理開始"
echo "   📈 詳細な処理ログ表示"
echo ""
echo "🚀 起動方法:"
echo "   1. アプリから起動:"
echo "      open \"$APP_PATH\""
echo ""
echo "   2. ターミナルから直接テスト:"
echo "      $BASE_DIR/test_file_browser.sh"
echo ""
echo "   3. Python直接実行:"
echo "      python3 \"$BASE_DIR/gui_file_browser.py\""
echo ""
echo "📖 使用方法:"
echo "   1. アプリ起動後、フォルダを移動してCSVファイルを探す"
echo "   2. ScopusのCSVファイルを選択 (複数選択可能)"
echo "   3. 「🚀 処理開始」ボタンをクリック"
echo "   4. 処理完了後、md_folderにMarkdownファイルが生成される"
echo ""
echo "💡 特徴:"
echo "   • Finderのような直感的操作"
echo "   • CSVファイルの自動識別・強調"
echo "   • リアルタイム処理ログ"
echo "   • エラーハンドリング"
echo "   • 結果フォルダの自動オープン"
echo ""

# 6. 今すぐテスト起動オプション
echo "🧪 今すぐテストしますか？"
echo "1) アプリ起動"
echo "2) ターミナルでテスト"
echo "3) 後で手動起動"
echo ""

read -p "選択 (1-3): " -n 1 -r
echo

case $REPLY in
    1)
        echo "🚀 アプリ起動中..."
        open "$APP_PATH"
        echo "✅ アプリを起動しました！"
        ;;
    2)
        echo "🚀 ターミナルでテスト起動中..."
        "$BASE_DIR/test_file_browser.sh"
        ;;
    3)
        echo "👍 後で手動起動してください"
        ;;
esac

echo ""
echo "✨ 統合作業完了！"
echo ""
echo "📱 アプリ場所: $APP_PATH"
echo "🧪 テストスクリプト: $BASE_DIR/test_file_browser.sh" 
echo "📖 説明書: $BASE_DIR/APP_SETUP_COMPLETE.md"
echo ""
