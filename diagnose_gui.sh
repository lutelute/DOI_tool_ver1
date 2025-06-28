#!/bin/bash

echo "🔍 DOI Tool GUI問題診断スクリプト"
echo "================================"

APP_PATH="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/standalone/DOI Tool.app"
GUI_SCRIPT="$APP_PATH/Contents/Resources/gui_main.py"

echo ""
echo "📋 システム環境確認:"

# 1. Python確認
echo "🐍 Python環境:"
python3 --version
which python3

# 2. tkinter確認
echo ""
echo "🖥️ tkinter確認:"
python3 -c "
import sys
try:
    import tkinter as tk
    print('✅ tkinter インポート成功')
    
    # 簡単なウィンドウテスト
    root = tk.Tk()
    root.title('テスト')
    root.geometry('200x100')
    root.withdraw()  # 隠す
    print('✅ tkinter ウィンドウ作成成功')
    root.destroy()
    print('✅ tkinter 基本動作OK')
    
except ImportError as e:
    print(f'❌ tkinter インポートエラー: {e}')
    sys.exit(1)
except Exception as e:
    print(f'❌ tkinter 動作エラー: {e}')
    sys.exit(1)
"

if [ $? -ne 0 ]; then
    echo ""
    echo "🚨 tkinter に問題があります"
    echo "💡 解決方法:"
    echo "   brew install python-tk"
    echo "   または"
    echo "   pyenv install 3.x.x (tkinter付きPython)"
    exit 1
fi

# 3. ディスプレイ環境確認
echo ""
echo "🖥️ ディスプレイ環境:"
echo "DISPLAY: ${DISPLAY:-未設定}"
echo "SSH接続: $(if [ -n "$SSH_CLIENT" ]; then echo "Yes"; else echo "No"; fi)"

# 4. GUI起動テスト
echo ""
echo "🧪 GUI起動テスト:"

# 直接Pythonスクリプトを実行
echo "📱 GUI起動試行中..."

# エラー出力を捕捉して実行
python3 "$GUI_SCRIPT" 2>&1 &
GUI_PID=$!

echo "   プロセスID: $GUI_PID"

# 3秒間プロセスを監視
sleep 3

if ps -p $GUI_PID > /dev/null 2>&1; then
    echo "✅ GUI プロセス実行中"
    echo "💡 ウィンドウが表示されない場合、Dockやアクティビティモニタを確認してください"
    
    # プロセスを終了
    kill $GUI_PID 2>/dev/null
    echo "🛑 テストプロセス終了"
else
    echo "❌ GUI プロセス異常終了"
    echo "🔍 エラー詳細確認のため直接実行します..."
fi

echo ""
echo "🔍 詳細エラー確認:"
echo "以下のコマンドを実行してエラー詳細を確認してください:"
echo ""
echo "python3 \"$GUI_SCRIPT\""
echo ""

# 5. 代替GUI確認
echo "🔧 代替確認 - 最小限GUIテスト:"

python3 -c "
import tkinter as tk
from tkinter import messagebox, filedialog
import sys

print('🧪 最小限GUI要素テスト開始...')

try:
    # ルートウィンドウ作成
    root = tk.Tk()
    root.title('DOI Tool テスト')
    root.geometry('300x200')
    
    # ラベル追加
    label = tk.Label(root, text='DOI Tool GUI テスト')
    label.pack(pady=20)
    
    # ボタン追加
    def test_dialog():
        result = messagebox.showinfo('テスト', 'GUI動作テスト成功!')
        print('✅ メッセージボックス表示成功')
        
        # ファイルダイアログテスト
        try:
            folder = filedialog.askdirectory(title='フォルダ選択テスト')
            if folder:
                print(f'✅ フォルダ選択成功: {folder}')
            else:
                print('📂 フォルダ選択キャンセル')
        except Exception as e:
            print(f'❌ フォルダ選択エラー: {e}')
        
        root.quit()
    
    button = tk.Button(root, text='テスト実行', command=test_dialog)
    button.pack(pady=10)
    
    close_button = tk.Button(root, text='終了', command=root.quit)
    close_button.pack(pady=5)
    
    print('✅ GUI要素作成成功')
    print('🖥️ ウィンドウ表示中 - テストボタンをクリックしてください')
    
    # メインループ開始（5秒でタイムアウト）
    root.after(5000, root.quit)  # 5秒後自動終了
    root.mainloop()
    
    print('✅ GUI基本テスト完了')
    
except Exception as e:
    print(f'❌ GUI テストエラー: {e}')
    import traceback
    traceback.print_exc()
    sys.exit(1)
"

echo ""
echo "📊 診断完了"
echo ""
echo "💡 問題が続く場合の対処法:"
echo "   1. ターミナルから直接実行して詳細エラー確認"
echo "   2. Python環境の再インストール"
echo "   3. 別のPython環境（pyenv等）の使用"
echo "   4. システムPythonの使用確認"
echo ""
