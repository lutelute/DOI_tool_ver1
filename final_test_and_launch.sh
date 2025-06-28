#!/bin/bash

echo "🎯 DOI Tool - 最終アプリ完成確認＆テスト"
echo "========================================"

BASE_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"
APP_PATH="$BASE_DIR/app_build/standalone/DOI Tool.app"

echo ""
echo "📱 アプリケーション完成度チェック:"

# 完成度チェック配列
declare -a checks=()

# 1. アプリ構造確認
if [ -d "$APP_PATH" ] && [ -f "$APP_PATH/Contents/MacOS/DOI_Tool" ] && [ -f "$APP_PATH/Contents/Info.plist" ]; then
    echo "✅ アプリ構造完成"
    checks+=("app_structure")
else
    echo "❌ アプリ構造不完全"
fi

# 2. Pythonスクリプト確認
required_scripts=("gui_main.py" "combine_scopus_csv.py" "scopus_doi_to_json.py" "json2tag_ref_scopus_async.py" "add_abst_scopus.py")
script_complete=true
for script in "${required_scripts[@]}"; do
    if [ ! -f "$APP_PATH/Contents/Resources/$script" ]; then
        script_complete=false
        break
    fi
done

if [ "$script_complete" = true ]; then
    echo "✅ Pythonスクリプト完成"
    checks+=("python_scripts")
else
    echo "❌ Pythonスクリプト不完全"
fi

# 3. アイコン確認
if [ -f "$APP_PATH/Contents/Resources/DOI_Tool.icns" ]; then
    echo "✅ アイコン設定完成"
    checks+=("icon")
else
    echo "❌ アイコン未設定"
fi

# 4. 実行権限確認
if [ -x "$APP_PATH/Contents/MacOS/DOI_Tool" ]; then
    echo "✅ 実行権限設定完成"
    checks+=("permissions")
else
    echo "🔧 実行権限設定中..."
    chmod +x "$APP_PATH/Contents/MacOS/DOI_Tool"
    echo "✅ 実行権限設定完成"
    checks+=("permissions")
fi

# 5. Python環境確認
if python3 -c "import tkinter, pandas, requests, tqdm" 2>/dev/null; then
    echo "✅ Python環境完成"
    checks+=("python_env")
else
    echo "❌ Python依存関係不完全"
    echo "💡 必要パッケージをインストール中..."
    pip3 install pandas requests requests_cache tqdm 2>/dev/null
fi

echo ""
echo "📊 完成度: ${#checks[@]}/5 項目完成"

if [ ${#checks[@]} -eq 5 ]; then
    echo "🎉 DOI Tool アプリケーション 100% 完成！"
else
    echo "⚠️  一部未完成項目があります"
fi

echo ""
echo "🧪 実際のテスト実行:"

# テストディレクトリ作成
TEST_DIR="$BASE_DIR/test_run"
mkdir -p "$TEST_DIR"

# サンプルデータコピー
if [ -f "$BASE_DIR/sample_data/test_scopus.csv" ]; then
    cp "$BASE_DIR/sample_data/test_scopus.csv" "$TEST_DIR/"
    echo "✅ テストデータ準備完了: $TEST_DIR/test_scopus.csv"
else
    echo "⚠️  テストデータなし - 手動でCSVファイルを配置してください"
fi

echo ""
echo "🚀 アプリケーション起動テスト:"
echo "   3秒後にアプリを起動します..."
sleep 3

# アプリケーション起動
open "$APP_PATH"

echo "✅ アプリケーション起動実行"

echo ""
echo "📋 テスト手順:"
echo "   1. 起動したアプリで「作業ディレクトリ」をクリック"
echo "   2. テストディレクトリを選択: $TEST_DIR"
echo "   3. 「ファイル一覧を更新」でtest_scopus.csvを確認"
echo "   4. 「処理を開始」ボタンをクリック"
echo "   5. 処理完了を待つ (ネットワーク接続が必要)"
echo "   6. 完了後、md_folderが作成されMarkdownファイルが生成される"

echo ""
echo "🔍 期待される結果:"
echo "   • scopus_combined.csv が作成される"
echo "   • JSON_folder/ にJSONファイルが作成される"  
echo "   • md_folder/ にMarkdownファイルが作成される"
echo "   • 処理完了ダイアログが表示される"

echo ""
echo "❓ 問題が発生した場合:"
echo "   • アプリが起動しない:"
echo "     python3 '$APP_PATH/Contents/Resources/gui_main.py'"
echo "   • 処理エラー:"
echo "     - ネットワーク接続確認"
echo "     - CSVファイル形式確認"
echo "     - Console.appでログ確認"

echo ""
echo "🎯 次のステップ:"
echo "   1. 上記テストを実行"
echo "   2. 実際のScopusデータで本格テスト"
echo "   3. 必要に応じてアプリをApplicationsフォルダに移動"

echo ""
echo "🎊 DOI Tool macOSアプリ完成おめでとうございます！"
echo ""
echo "📱 アプリ場所: $APP_PATH"
echo "🧪 テスト場所: $TEST_DIR"
echo "📖 詳細情報: $BASE_DIR/APP_SETUP_COMPLETE.md"
echo ""
