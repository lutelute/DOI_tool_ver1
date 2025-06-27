#!/bin/bash

# fix_tkinter.sh - tkinter問題の解決

echo "=== tkinter問題の診断と修正 ==="
echo ""

# 現在のPython環境を確認
echo "現在のPython環境:"
echo "Python: $(which python3)"
echo "Version: $(python3 --version)"
echo ""

# tkinterのテスト
echo "tkinterの確認中..."
python3 -c "import tkinter; print('✅ tkinter は利用可能です')" 2>/dev/null && tkinter_available=true || tkinter_available=false

if [ "$tkinter_available" = true ]; then
    echo "tkinterは正常に動作します。他の問題の可能性があります。"
    exit 0
fi

echo "❌ tkinter が見つかりません"
echo ""

# Homebrewかどうかを確認
if [[ "$(which python3)" == *"homebrew"* ]] || [[ "$(which python3)" == *"/opt/homebrew"* ]]; then
    echo "Homebrew Python が検出されました"
    echo ""
    
    echo "解決方法を試します..."
    echo ""
    
    # 方法1: python-tk をインストール
    echo "=== 方法1: python-tk パッケージのインストール ==="
    if command -v brew &> /dev/null; then
        echo "python-tk をインストール中..."
        brew install python-tk
        
        # 再テスト
        echo "tkinter を再テスト中..."
        if python3 -c "import tkinter; print('✅ tkinter が修正されました')" 2>/dev/null; then
            echo "🎉 問題が解決されました！"
            exit 0
        fi
    else
        echo "❌ Homebrew が見つかりません"
    fi
    
    echo ""
    echo "=== 方法2: システムPythonの使用 ==="
    
    # システムPythonを確認
    if [ -f "/usr/bin/python3" ]; then
        echo "システムPython を確認中..."
        /usr/bin/python3 -c "import tkinter; print('✅ システムPython の tkinter は利用可能です')" 2>/dev/null && system_python_ok=true || system_python_ok=false
        
        if [ "$system_python_ok" = true ]; then
            echo "システムPythonでtkinterが利用可能です"
            echo "GUI用のスクリプトを作成します..."
            
            # システムPython用のGUIスクリプトを作成
            cat > gui_main_system.py << 'EOF'
#!/usr/bin/env /usr/bin/python3
# -*- coding: utf-8 -*-
"""
gui_main_system.py - システムPython用GUI
"""

import sys
import subprocess
import os

# まず依存関係をインストール
try:
    import pandas
except ImportError:
    print("必要なパッケージをインストール中...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "--user", "pandas", "requests", "requests-cache", "tqdm", "nltk", "aiohttp"])

# 元のGUIコードをインポート
exec(open('gui_main.py').read())
EOF
            
            chmod +x gui_main_system.py
            echo "✅ gui_main_system.py を作成しました"
            echo ""
            echo "次のコマンドで起動してください:"
            echo "  /usr/bin/python3 gui_main_system.py"
            exit 0
        fi
    fi
    
else
    echo "システムPython環境が検出されました"
fi

echo ""
echo "=== 方法3: PyQt5 GUI版の作成 ==="
echo "tkinterの代わりにPyQt5を使用したGUI版を作成しますか？ (y/n): "
read -r create_pyqt

if [[ "$create_pyqt" =~ ^[Yy]$ ]]; then
    echo "PyQt5版のGUIを作成します..."
    
    # PyQt5をインストール
    pip3 install --user PyQt5
    
    # PyQt5版のGUIを作成（次のスクリプトで作成）
    echo "✅ PyQt5版GUI作成の準備ができました"
fi

echo ""
echo "=== その他の解決方法 ==="
echo "1. Command Line Toolsの再インストール:"
echo "   xcode-select --install"
echo ""
echo "2. Homebrewの再インストール:"
echo "   brew uninstall python@3.13"
echo "   brew install python@3.13"
echo "   brew install python-tk"
echo ""
echo "3. システムPythonの使用:"
echo "   /usr/bin/python3 gui_main.py"
echo ""
echo "4. コマンドライン版の使用:"
echo "   cd [CSVファイルがあるディレクトリ]"
echo "   python3 [プロジェクトパス]/main.py"
