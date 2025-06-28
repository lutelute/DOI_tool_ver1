#!/bin/bash

# quick_file_browser.sh - Finderライクなファイル選択付きDOI Tool起動スクリプト

echo "🔍 DOI Tool - Finderライクなファイル選択付きバージョン"
echo "=================================================="
echo ""

# 現在のディレクトリ
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# tkinterの確認
echo "システム環境を確認中..."
python3 -c "import tkinter" 2>/dev/null && tkinter_ok=true || tkinter_ok=false

echo ""
echo "🔍 Finderライクなファイル選択機能:"
echo "  - ディレクトリツリー表示"
echo "  - 複数CSVファイル選択"
echo "  - 作業ディレクトリ設定"
echo "  - リアルタイム進捗表示"
echo ""

echo "実行方法を選択してください："
echo ""
echo "🎯 ファイルブラウザ付きバージョン:"
echo "1) コマンドライン版 - ターミナル内ファイルブラウザ（推奨）"
if [ "$tkinter_ok" = true ]; then
    echo "2) GUI版 - Finderライクなファイルツリー"
else
    echo "2) GUI版 - Finderライクなファイルツリー（❌ tkinter利用不可）"
fi
echo ""
echo "🔧 その他のバージョン:"
echo "3) 進捗バー付きコマンドライン版"
echo "4) 進捗バー付きGUI版"
echo "5) シンプル実行版"
echo "6) 終了"
echo ""
echo -n "選択 (1-6): "
read choice

case $choice in
    1)
        echo ""
        echo "=== ファイルブラウザ付きコマンドライン版 ==="
        echo "ターミナル内Finderライクなファイルブラウザを起動します..."
        echo ""
        python3 "$SCRIPT_DIR/file_browser.py"
        ;;
    2)
        if [ "$tkinter_ok" = true ]; then
            echo ""
            echo "=== ファイルブラウザ付きGUI版 ==="
            echo "Finderライクなファイルツリー付きGUIを起動します..."
            echo ""
            python3 "$SCRIPT_DIR/gui_file_browser.py" 2>/dev/null || {
                echo "GUI版の起動に失敗しました。代わりにコマンドライン版を起動します..."
                python3 "$SCRIPT_DIR/file_browser.py"
            }
        else
            echo ""
            echo "❌ tkinter が利用できません"
            echo "代わりにコマンドライン版を起動します..."
            python3 "$SCRIPT_DIR/file_browser.py"
        fi
        ;;
    3)
        echo ""
        echo "=== 進捗バー付きコマンドライン版 ==="
        if [ -f "$SCRIPT_DIR/progress_cli.py" ]; then
            python3 "$SCRIPT_DIR/progress_cli.py"
        else
            echo "❌ progress_cli.py が見つかりません"
        fi
        ;;
    4)
        if [ "$tkinter_ok" = true ]; then
            echo ""
            echo "=== 進捗バー付きGUI版 ==="
            if [ -f "$SCRIPT_DIR/gui_progress.py" ]; then
                python3 "$SCRIPT_DIR/gui_progress.py" 2>/dev/null || {
                    echo "GUI版の起動に失敗しました。代わりにコマンドライン版を起動します..."
                    python3 "$SCRIPT_DIR/progress_cli.py"
                }
            else
                echo "❌ gui_progress.py が見つかりません"
            fi
        else
            echo ""
            echo "❌ tkinter が利用できません"
            echo "代わりにコマンドライン版を起動します..."
            python3 "$SCRIPT_DIR/progress_cli.py"
        fi
        ;;
    5)
        echo ""
        echo "=== シンプル実行版 ==="
        if [ -f "$SCRIPT_DIR/simple_run.py" ]; then
            python3 "$SCRIPT_DIR/simple_run.py"
        else
            echo "❌ simple_run.py が見つかりません"
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
echo ""
echo "💡 Tips:"
echo "  - ファイルブラウザ版なら、Finderのように直感的にファイル選択ができます"
echo "  - 複数のCSVファイルを同時に選択して一括処理が可能です"
echo "  - 作業ディレクトリを指定して、結果をお好みの場所に保存できます"
