#!/bin/bash

# quick_install.sh - DOI Tool 簡単インストール

echo "🚀 DOI Tool - 簡単インストール"
echo ""

# 現在のディレクトリ
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# tkinterの確認
echo "システム環境を確認中..."
python3 -c "import tkinter" 2>/dev/null && tkinter_ok=true || tkinter_ok=false

echo "インストール方法を選択してください："
echo "1) スタンドアロンアプリ（推奨・簡単）"
echo "2) py2app ビルド（完全版）"
if [ "$tkinter_ok" = true ]; then
    echo "3) GUI版で実行（tkinter）"
else
    echo "3) GUI版で実行（tkinter） - ❌ tkinter利用不可"
fi
echo "4) コマンドライン版で実行（tkinter不要）"
echo "5) tkinter問題の修正"
echo ""
echo -n "選択 (1-5): "
read choice

case $choice in
    1)
        echo ""
        echo "=== スタンドアロンアプリ作成 ==="
        python3 "$SCRIPT_DIR/standalone_installer.py"
        ;;
    2)
        echo ""
        echo "=== py2app ビルド ==="
        if [ ! -f "$SCRIPT_DIR/install_and_build.sh" ]; then
            echo "❌ install_and_build.sh が見つかりません"
            exit 1
        fi
        chmod +x "$SCRIPT_DIR/install_and_build.sh"
        "$SCRIPT_DIR/install_and_build.sh"
        ;;
    3)
        if [ "$tkinter_ok" = true ]; then
            echo ""
            echo "=== GUI版で実行 ==="
            echo "GUIアプリケーションを起動します..."
            python3 "$SCRIPT_DIR/gui_main.py"
        else
            echo ""
            echo "❌ tkinter が利用できません"
            echo "選択肢5で修正するか、選択肢4でコマンドライン版をお試しください"
        fi
        ;;
    4)
        echo ""
        echo "=== コマンドライン版で実行 ==="
        echo "コマンドライン版GUIを起動します..."
        python3 "$SCRIPT_DIR/cli_gui.py"
        ;;
    5)
        echo ""
        echo "=== tkinter問題の修正 ==="
        chmod +x "$SCRIPT_DIR/fix_tkinter.sh"
        "$SCRIPT_DIR/fix_tkinter.sh"
        ;;
    *)
        echo "無効な選択です"
        exit 1
        ;;
esac
