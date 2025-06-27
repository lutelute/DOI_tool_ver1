#!/bin/bash

# quick_progress.sh - 進捗バー付きDOI Tool 簡単起動

echo "🚀 DOI Tool - 進捗バー付きバージョン"
echo "======================================"
echo ""

# 現在のディレクトリ
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# tkinterの確認
echo "システム環境を確認中..."
python3 -c "import tkinter" 2>/dev/null && tkinter_ok=true || tkinter_ok=false

echo ""
echo "実行方法を選択してください："
echo ""
echo "🎯 進捗バー付きバージョン:"
echo "1) コマンドライン版 - 美しい進捗バー付き（推奨）"
if [ "$tkinter_ok" = true ]; then
    echo "2) GUI版 - 進捗バー付きGUI"
else
    echo "2) GUI版 - 進捗バー付きGUI（❌ tkinter利用不可）"
fi
echo ""
echo "🔧 従来バージョン:"
echo "3) シンプル実行版"
echo "4) 緊急時実行"
echo "5) tkinter問題の修正"
echo "6) 終了"
echo ""
echo -n "選択 (1-6): "
read choice

case $choice in
    1)
        echo ""
        echo "=== 進捗バー付きコマンドライン版 ==="
        echo "美しい進捗バー付きのターミナルGUIを起動します..."
        echo ""
        python3 "$SCRIPT_DIR/progress_cli.py"
        ;;
    2)
        if [ "$tkinter_ok" = true ]; then
            echo ""
            echo "=== 進捗バー付きGUI版 ==="
            echo "進捗バー付きGUIアプリケーションを起動します..."
            echo ""
            python3 "$SCRIPT_DIR/gui_progress.py" 2>/dev/null || {
                echo "GUI版の起動に失敗しました。代わりにコマンドライン版を起動します..."
                python3 "$SCRIPT_DIR/progress_cli.py"
            }
        else
            echo ""
            echo "❌ tkinter が利用できません"
            echo "代わりにコマンドライン版を起動します..."
            python3 "$SCRIPT_DIR/progress_cli.py"
        fi
        ;;
    3)
        echo ""
        echo "=== シンプル実行版 ==="
        if [ -f "$SCRIPT_DIR/simple_run.py" ]; then
            python3 "$SCRIPT_DIR/simple_run.py"
        else
            echo "❌ simple_run.py が見つかりません"
        fi
        ;;
    4)
        echo ""
        echo "=== 緊急時実行 ==="
        if [ -f "$SCRIPT_DIR/emergency_run.sh" ]; then
            chmod +x "$SCRIPT_DIR/emergency_run.sh"
            "$SCRIPT_DIR/emergency_run.sh"
        else
            echo "❌ emergency_run.sh が見つかりません"
        fi
        ;;
    5)
        echo ""
        echo "=== tkinter問題の修正 ==="
        if [ -f "$SCRIPT_DIR/fix_tkinter.sh" ]; then
            chmod +x "$SCRIPT_DIR/fix_tkinter.sh"
            "$SCRIPT_DIR/fix_tkinter.sh"
        else
            echo "❌ fix_tkinter.sh が見つかりません"
        fi
        ;;
    6)
        echo "終了します"
        exit 0
        ;;
    *)
        echo "無効な選択です"
        exit 1
        ;;
esac

echo ""
echo "🎉 DOI Toolをご利用いただき、ありがとうございました！"
