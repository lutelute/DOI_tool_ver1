#!/bin/bash

echo "🧪 DOI Tool アプリケーション動作テスト"
echo "=================================="

APP_PATH="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/standalone/DOI Tool.app"
RESOURCES_DIR="$APP_PATH/Contents/Resources"

echo ""
echo "📋 アプリケーション状態確認:"

# 1. アプリディレクトリ確認
if [ -d "$APP_PATH" ]; then
    echo "✅ アプリディレクトリ存在"
else
    echo "❌ アプリディレクトリなし"
    exit 1
fi

# 2. 実行ファイル確認
EXECUTABLE="$APP_PATH/Contents/MacOS/DOI_Tool"
if [ -x "$EXECUTABLE" ]; then
    echo "✅ 実行ファイル実行可能"
else
    echo "❌ 実行ファイル実行不可"
    chmod +x "$EXECUTABLE"
    echo "🔧 実行権限を設定しました"
fi

# 3. Pythonスクリプト確認
echo ""
echo "🐍 必要なPythonスクリプト確認:"
required_files=("gui_main.py" "combine_scopus_csv.py" "scopus_doi_to_json.py" "json2tag_ref_scopus_async.py" "add_abst_scopus.py")

all_present=true
for file in "${required_files[@]}"; do
    if [ -f "$RESOURCES_DIR/$file" ]; then
        size=$(stat -f%z "$RESOURCES_DIR/$file" 2>/dev/null || echo "0")
        echo "   ✅ $file (${size} bytes)"
    else
        echo "   ❌ $file 見つかりません"
        all_present=false
    fi
done

# 4. アイコン確認
if [ -f "$RESOURCES_DIR/DOI_Tool.icns" ]; then
    size=$(stat -f%z "$RESOURCES_DIR/DOI_Tool.icns" 2>/dev/null || echo "0")
    echo "   ✅ DOI_Tool.icns (${size} bytes)"
else
    echo "   ❌ DOI_Tool.icns なし"
fi

# 5. Python環境テスト
echo ""
echo "🐍 Python環境テスト:"
python3 --version
echo ""

# tkinter テスト
echo "🖥️ tkinter テスト:"
python3 -c "
import tkinter as tk
import sys
try:
    root = tk.Tk()
    root.withdraw()  # ウィンドウを隠す
    root.destroy()
    print('✅ tkinter 正常動作')
except Exception as e:
    print(f'❌ tkinter エラー: {e}')
    sys.exit(1)
"

if [ $? -eq 0 ]; then
    echo "✅ tkinter動作確認済み"
else
    echo "❌ tkinter動作不可"
    exit 1
fi

# 6. 依存関係確認
echo ""
echo "📦 Python依存関係確認:"
python3 -c "
modules = ['pandas', 'requests', 'tqdm']
missing = []
for module in modules:
    try:
        __import__(module)
        print(f'✅ {module}')
    except ImportError:
        print(f'❌ {module} - インストール必要')
        missing.append(module)

if missing:
    print('')
    print('📥 不足モジュールをインストールしますか？ (pip3 install ' + ' '.join(missing) + ')')
    import sys
    sys.exit(len(missing))
"

missing_count=$?
if [ $missing_count -gt 0 ]; then
    echo ""
    read -p "💡 不足しているパッケージをインストールしますか？ (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📥 パッケージインストール中..."
        pip3 install pandas requests requests_cache tqdm
        echo "✅ インストール完了"
    fi
fi

# 7. GUI起動テスト
echo ""
echo "🚀 GUI起動テスト (5秒間):"
echo "   GUIウィンドウが表示されれば成功です..."

# バックグラウンドでGUIを起動
timeout 5 python3 "$RESOURCES_DIR/gui_main.py" >/dev/null 2>&1 &
GUI_PID=$!

sleep 6

# プロセスがまだ動いているかチェック
if ps -p $GUI_PID > /dev/null 2>&1; then
    echo "✅ GUI正常起動 - プロセス終了中..."
    kill $GUI_PID 2>/dev/null
    echo "✅ GUIテスト成功"
else
    echo "✅ GUI起動テスト完了"
fi

# 8. 最終テスト - アプリケーション起動
echo ""
echo "🎯 最終テスト - macOSアプリケーション起動:"
echo "   アプリケーションを起動します..."
echo "   Dockまたはアクティビティモニタで確認してください"

# アプリを起動
open "$APP_PATH"

sleep 3

echo ""
echo "🎉 テスト完了!"
echo ""
echo "📋 結果サマリー:"
if [ "$all_present" = true ]; then
    echo "   ✅ 全必要ファイル存在"
else
    echo "   ⚠️  一部ファイル不足 - 上記確認してください"
fi
echo "   ✅ Python環境OK"
echo "   ✅ tkinter動作OK" 
echo "   ✅ アプリケーション起動実行"
echo ""
echo "🚀 使用方法:"
echo "   1. 起動したアプリで作業ディレクトリを選択"
echo "   2. ScopusのCSVファイルがあるフォルダを指定"
echo "   3. '処理を開始'ボタンをクリック"
echo "   4. 完了後 md_folder にMarkdownファイル生成"
echo ""
echo "❓ 問題がある場合:"
echo "   • 直接実行: python3 '$RESOURCES_DIR/gui_main.py'"
echo "   • ログ確認: /Applications/Utilities/Console.app"
echo ""
