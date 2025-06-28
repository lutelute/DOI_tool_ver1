#!/bin/bash

echo "🔧 DOI Tool GUI問題解決スクリプト"
echo "================================="

BASE_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"
APP_PATH="$BASE_DIR/app_build/standalone/DOI Tool.app"
RESOURCES_DIR="$APP_PATH/Contents/Resources"

# 実行権限設定
chmod +x "$BASE_DIR/diagnose_gui.sh"
chmod +x "$BASE_DIR/gui_main_debug.py"

echo ""
echo "🔍 問題: FinderでGUIが表示されない・フォルダ選択ができない"
echo ""
echo "💡 解決手順:"

echo ""
echo "ステップ1: GUI環境診断"
echo "------------------------"
echo "実行コマンド: $BASE_DIR/diagnose_gui.sh"
echo ""
read -p "診断を実行しますか？ (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    "$BASE_DIR/diagnose_gui.sh"
fi

echo ""
echo "ステップ2: デバッグ版GUI直接テスト"
echo "-----------------------------------"
echo "より詳細なデバッグ情報付きでGUIをテストします"
echo ""
read -p "デバッグ版GUIを起動しますか？ (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 デバッグ版GUI起動中..."
    python3 "$BASE_DIR/gui_main_debug.py"
fi

echo ""
echo "ステップ3: アプリ内GUIの修正"
echo "----------------------------"
echo "アプリ内のGUIスクリプトをデバッグ版に置換します"
echo ""
read -p "アプリ内GUIを修正しますか？ (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔄 GUI修正中..."
    
    # 元のGUIをバックアップ
    cp "$RESOURCES_DIR/gui_main.py" "$RESOURCES_DIR/gui_main_original.py"
    echo "✅ 元のGUIをバックアップ: gui_main_original.py"
    
    # デバッグ版をコピー
    cp "$BASE_DIR/gui_main_debug.py" "$RESOURCES_DIR/gui_main.py"
    echo "✅ デバッグ版GUIを適用"
    
    # アプリのタイムスタンプを更新
    touch "$APP_PATH"
    echo "✅ アプリタイムスタンプ更新"
fi

echo ""
echo "ステップ4: Python環境の確認・修正"
echo "-----------------------------------"

# Python環境確認
echo "🐍 現在のPython環境:"
which python3
python3 --version

echo ""
echo "🖥️ tkinter確認:"
python3 -c "
try:
    import tkinter as tk
    print('✅ tkinter 利用可能')
    
    # 基本テスト
    root = tk.Tk()
    root.withdraw()
    root.destroy()
    print('✅ tkinter 基本動作OK')
    
except Exception as e:
    print(f'❌ tkinter エラー: {e}')
    print('💡 解決方法:')
    print('   brew install python-tk')
    print('   または system Python を使用')
"

echo ""
echo "ステップ5: 代替起動方法"
echo "------------------------"

echo "方法A: ターミナルから直接GUI起動"
echo "python3 '$RESOURCES_DIR/gui_main.py'"
echo ""

echo "方法B: アプリバンドル経由で起動" 
echo "open '$APP_PATH'"
echo ""

echo "方法C: システムPython使用"
echo "/usr/bin/python3 '$RESOURCES_DIR/gui_main.py'"
echo ""

echo "🧪 どの方法でテストしますか？"
echo "1) 方法A - 直接起動"
echo "2) 方法B - アプリ起動"  
echo "3) 方法C - システムPython"
echo "4) すべてテスト"
echo ""

read -p "選択 (1-4): " -n 1 -r
echo

case $REPLY in
    1)
        echo "🚀 方法A実行中..."
        python3 "$RESOURCES_DIR/gui_main.py"
        ;;
    2) 
        echo "🚀 方法B実行中..."
        open "$APP_PATH"
        ;;
    3)
        echo "🚀 方法C実行中..."
        /usr/bin/python3 "$RESOURCES_DIR/gui_main.py"
        ;;
    4)
        echo "🚀 全方法テスト中..."
        
        echo "📱 方法A - 直接起動:"
        timeout 5 python3 "$RESOURCES_DIR/gui_main.py" &
        sleep 2
        
        echo "📱 方法B - アプリ起動:"
        open "$APP_PATH"
        sleep 2
        
        echo "📱 方法C - システムPython:"
        timeout 5 /usr/bin/python3 "$RESOURCES_DIR/gui_main.py" &
        
        echo "✅ 複数方法で起動試行完了"
        ;;
esac

echo ""
echo "ステップ6: よくある問題と対処法"
echo "--------------------------------"

echo ""
echo "❓ 問題: ウィンドウが表示されない"
echo "💡 対処法:"
echo "   • Dockでアプリアイコンを確認"
echo "   • Command+Tab でアプリを切り替え"
echo "   • アクティビティモニタでプロセス確認"
echo ""

echo "❓ 問題: フォルダ選択ダイアログが開かない"
echo "💡 対処法:"
echo "   • システム環境設定 > セキュリティとプライバシー"
echo "   • アクセシビリティ・ファイルとフォルダの権限確認"
echo "   • ターミナルにフルディスクアクセス許可"
echo ""

echo "❓ 問題: tkinter エラー"
echo "💡 対処法:"
echo "   • brew install python-tk"
echo "   • pyenv install 3.x.x (tkinter含む版)"
echo "   • Xcode Command Line Tools 再インストール"
echo ""

echo "📋 追加確認コマンド:"
echo "• GUI診断: $BASE_DIR/diagnose_gui.sh"
echo "• 直接実行: python3 '$BASE_DIR/gui_main_debug.py'"
echo "• システム情報: system_profiler SPDeveloperToolsDataType"
echo ""

echo "🎯 推奨解決順序:"
echo "1. ターミナルから直接GUI起動してエラー確認"
echo "2. tkinter問題の場合はPython環境修正"
echo "3. 権限問題の場合はシステム設定確認"
echo "4. アプリ版GUIをデバッグ版に置換"
echo ""

echo "✨ 問題解決スクリプト完了"
echo ""
echo "💬 まだ問題が続く場合は、上記の診断結果を確認して"
echo "   具体的なエラーメッセージを教えてください。"
echo ""
