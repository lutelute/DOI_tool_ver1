#!/bin/bash

echo "🚀 DOI Tool GUI クイック診断・修正"
echo "================================="

BASE_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"

# 権限設定
find "$BASE_DIR" -name "*.sh" -exec chmod +x {} \;

echo ""
echo "🔍 GUI問題の原因を特定します..."

echo ""
echo "1️⃣ Python・tkinter確認中..."

# Python環境チェック
PYTHON_VERSION=$(python3 --version 2>/dev/null || echo "Python3 not found")
echo "Python: $PYTHON_VERSION"

# tkinter チェック
TKINTER_STATUS=$(python3 -c "
try:
    import tkinter as tk
    root = tk.Tk()
    root.withdraw()
    root.destroy()
    print('OK')
except Exception as e:
    print(f'ERROR: {e}')
" 2>/dev/null)

echo "tkinter: $TKINTER_STATUS"

if [[ "$TKINTER_STATUS" == *"ERROR"* ]]; then
    echo ""
    echo "❌ tkinter に問題があります"
    echo "🔧 自動修正を試行します..."
    
    echo "📦 python-tk インストール中..."
    brew install python-tk 2>/dev/null || {
        echo "⚠️  brew でのインストール失敗"
        echo "💡 手動で実行してください: brew install python-tk"
    }
fi

echo ""
echo "2️⃣ GUI直接起動テスト..."

# 直接GUIテスト
echo "🖥️ 基本GUIテスト実行中..."
python3 -c "
import tkinter as tk
from tkinter import messagebox
import sys

try:
    root = tk.Tk()
    root.title('DOI Tool テスト')
    root.geometry('300x150')
    
    tk.Label(root, text='DOI Tool GUI テスト', font=('Arial', 14)).pack(pady=20)
    
    def success():
        messagebox.showinfo('成功', 'GUI正常動作確認!')
        root.quit()
        
    tk.Button(root, text='テスト成功', command=success, bg='green', fg='white').pack(pady=10)
    tk.Button(root, text='終了', command=root.quit).pack()
    
    print('✅ GUI テストウィンドウ表示中...')
    root.after(3000, root.quit)  # 3秒後自動終了
    root.mainloop()
    print('✅ GUI テスト完了')
    
except Exception as e:
    print(f'❌ GUI テスト失敗: {e}')
    sys.exit(1)
" 2>/dev/null

GUI_TEST_RESULT=$?

if [ $GUI_TEST_RESULT -eq 0 ]; then
    echo "✅ 基本GUI動作OK"
else
    echo "❌ 基本GUI動作エラー"
fi

echo ""
echo "3️⃣ アプリケーション状態確認..."

APP_PATH="$BASE_DIR/app_build/standalone/DOI Tool.app"

if [ -f "$APP_PATH/Contents/Resources/gui_main.py" ]; then
    echo "✅ アプリ内GUIスクリプト存在"
    
    # アプリ内GUIのテスト
    echo "🧪 アプリ内GUI起動テスト..."
    timeout 3 python3 "$APP_PATH/Contents/Resources/gui_main.py" >/dev/null 2>&1 &
    APP_GUI_PID=$!
    
    sleep 1
    if ps -p $APP_GUI_PID > /dev/null 2>&1; then
        echo "✅ アプリ内GUI起動OK"
        kill $APP_GUI_PID 2>/dev/null
    else
        echo "❌ アプリ内GUI起動エラー"
    fi
else
    echo "❌ アプリ内GUIスクリプトなし"
fi

echo ""
echo "📊 診断結果サマリー:"
echo "==================="

if [[ "$TKINTER_STATUS" == "OK" ]] && [ $GUI_TEST_RESULT -eq 0 ]; then
    echo "✅ Python・tkinter環境: 正常"
    echo "✅ 基本GUI機能: 正常"
    echo ""
    echo "🎯 推奨対処法:"
    echo "1. デバッグ版GUIで詳細確認:"
    echo "   python3 '$BASE_DIR/gui_main_debug.py'"
    echo ""
    echo "2. アプリから直接起動:"
    echo "   open '$APP_PATH'"
    echo ""
    echo "3. 完全なGUI問題解決:"
    echo "   $BASE_DIR/fix_gui_problems.sh"
    
else
    echo "❌ GUI環境に問題があります"
    echo ""
    echo "🔧 推奨修正手順:"
    
    if [[ "$TKINTER_STATUS" != "OK" ]]; then
        echo "1. tkinter修正:"
        echo "   brew install python-tk"
        echo "   または"
        echo "   pyenv install 3.x.x"
    fi
    
    if [ $GUI_TEST_RESULT -ne 0 ]; then
        echo "2. Python環境確認:"
        echo "   which python3"
        echo "   /usr/bin/python3 --version"
    fi
    
    echo "3. 詳細診断:"
    echo "   $BASE_DIR/diagnose_gui.sh"
fi

echo ""
echo "🚀 クイック起動コマンド:"
echo "------------------------"
echo "• 診断版GUI: python3 '$BASE_DIR/gui_main_debug.py'"
echo "• アプリ起動: open '$APP_PATH'"
echo "• 問題解決: $BASE_DIR/fix_gui_problems.sh"
echo ""

# 自動起動オプション
echo "💡 今すぐテストしますか？"
echo "1) デバッグ版GUI起動"
echo "2) アプリ起動"
echo "3) 詳細診断実行"
echo "4) 何もしない"
echo ""

read -p "選択 (1-4): " -n 1 -r
echo

case $REPLY in
    1)
        echo "🚀 デバッグ版GUI起動中..."
        python3 "$BASE_DIR/gui_main_debug.py"
        ;;
    2)
        echo "🚀 アプリ起動中..."
        open "$APP_PATH"
        ;;
    3)
        echo "🚀 詳細診断実行中..."
        "$BASE_DIR/fix_gui_problems.sh"
        ;;
    4)
        echo "✅ 診断完了"
        ;;
esac

echo ""
echo "✨ クイック診断完了!"
echo ""
