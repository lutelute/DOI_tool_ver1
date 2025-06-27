#!/bin/bash

# diagnose.sh - DOI Tool 問題診断スクリプト

echo "🔍 DOI Tool 問題診断スクリプト"
echo "================================"
echo ""

# 基本情報収集
echo "📊 システム情報:"
echo "OS: $(uname -s) $(uname -r)"
echo "Python: $(python3 --version 2>/dev/null || echo '❌ Python3が見つかりません')"
echo "Python パス: $(which python3 2>/dev/null || echo '❌ Python3パスが見つかりません')"
echo ""

# 現在のディレクトリ確認
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "📁 ディレクトリ情報:"
echo "スクリプトディレクトリ: $SCRIPT_DIR"
echo "プロジェクトディレクトリ: $PROJECT_DIR"
echo ""

# ファイル存在確認
echo "📄 重要ファイルの確認:"
files_to_check=(
    "$SCRIPT_DIR/cli_gui.py"
    "$SCRIPT_DIR/gui_main.py" 
    "$SCRIPT_DIR/quick_install.sh"
    "$PROJECT_DIR/main.py"
    "$PROJECT_DIR/combine_scopus_csv.py"
    "$PROJECT_DIR/scopus_doi_to_json.py"
    "$PROJECT_DIR/json2tag_ref_scopus_async.py"
    "$PROJECT_DIR/add_abst_scopus.py"
)

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $(basename "$file")"
    else
        echo "❌ $(basename "$file") - 見つかりません: $file"
    fi
done
echo ""

# 実行権限確認
echo "🔐 実行権限の確認:"
executable_files=(
    "$SCRIPT_DIR/quick_install.sh"
    "$SCRIPT_DIR/cli_gui.py"
    "$SCRIPT_DIR/fix_tkinter.sh"
    "$SCRIPT_DIR/standalone_installer.py"
)

for file in "${executable_files[@]}"; do
    if [ -f "$file" ]; then
        if [ -x "$file" ]; then
            echo "✅ $(basename "$file") - 実行可能"
        else
            echo "⚠️  $(basename "$file") - 実行権限なし"
            chmod +x "$file" 2>/dev/null && echo "   → 実行権限を付与しました" || echo "   → 実行権限の付与に失敗"
        fi
    else
        echo "❌ $(basename "$file") - ファイルが存在しません"
    fi
done
echo ""

# Python モジュール確認
echo "🐍 Python モジュールの確認:"
modules=(
    "tkinter"
    "pandas"
    "requests"
    "nltk"
    "aiohttp"
    "subprocess"
    "threading"
    "os"
    "sys"
)

for module in "${modules[@]}"; do
    if python3 -c "import $module" 2>/dev/null; then
        echo "✅ $module"
    else
        echo "❌ $module - インストールされていません"
    fi
done
echo ""

# tkinter 詳細確認
echo "🖥️  tkinter 詳細診断:"
if python3 -c "import tkinter; tkinter.Tk().withdraw()" 2>/dev/null; then
    echo "✅ tkinter は完全に動作します"
    tkinter_status="OK"
else
    echo "❌ tkinter に問題があります"
    echo "エラー詳細:"
    python3 -c "import tkinter" 2>&1 | head -3 | sed 's/^/   /'
    tkinter_status="NG"
fi
echo ""

# 推奨実行方法
echo "💡 推奨実行方法:"
if [ "$tkinter_status" = "OK" ]; then
    echo "1. GUI版（tkinter）: ./quick_install.sh → 3を選択"
    echo "2. コマンドライン版: ./quick_install.sh → 4を選択"
    echo "3. スタンドアロンアプリ: ./quick_install.sh → 1を選択"
else
    echo "1. コマンドライン版（推奨）: ./quick_install.sh → 4を選択"
    echo "2. tkinter修正: ./quick_install.sh → 5を選択"
    echo "3. スタンドアロンアプリ: ./quick_install.sh → 1を選択"
fi
echo ""

# 簡単テスト実行
echo "🧪 簡単テスト:"
echo "1) コマンドライン版GUI テスト"
if [ -f "$SCRIPT_DIR/cli_gui.py" ]; then
    echo "   python3 cli_gui.py を実行してみます..."
    timeout 5 python3 "$SCRIPT_DIR/cli_gui.py" --help 2>/dev/null && echo "   ✅ cli_gui.py は実行可能です" || echo "   ⚠️  cli_gui.py でエラーが発生する可能性があります"
else
    echo "   ❌ cli_gui.py が見つかりません"
fi

echo ""
echo "2) メインスクリプト テスト"
if [ -f "$PROJECT_DIR/main.py" ]; then
    echo "   python3 main.py --help を実行してみます..."
    timeout 5 python3 "$PROJECT_DIR/main.py" --help 2>/dev/null && echo "   ✅ main.py は実行可能です" || echo "   ⚠️  main.py でエラーが発生する可能性があります"
else
    echo "   ❌ main.py が見つかりません"
fi

echo ""
echo "========================================"
echo "🎯 次のステップ:"
echo ""

if [ "$tkinter_status" = "NG" ]; then
    echo "tkinterに問題があるため、以下を試してください："
    echo ""
    echo "【方法1: コマンドライン版使用（推奨）】"
    echo "cd '$SCRIPT_DIR'"
    echo "python3 cli_gui.py"
    echo ""
    echo "【方法2: tkinter修正】"
    echo "cd '$SCRIPT_DIR'"
    echo "./fix_tkinter.sh"
    echo ""
else
    echo "システムは正常です。以下のいずれかを試してください："
    echo ""
    echo "【方法1: 簡単インストール】"
    echo "cd '$SCRIPT_DIR'"
    echo "./quick_install.sh"
    echo ""
    echo "【方法2: 直接実行】"
    echo "cd '$SCRIPT_DIR'"
    echo "python3 gui_main.py"
    echo ""
fi

echo "【方法3: 元のコマンドライン実行】"
echo "cd [CSVファイルがあるディレクトリ]"
echo "python3 '$PROJECT_DIR/main.py'"
echo ""

echo "🆘 まだ問題がある場合は、上記の診断結果をお知らせください。"
