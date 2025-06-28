#!/bin/bash

# fix_environment.sh - 環境問題修正スクリプト

echo "🔧 DOI Tool 環境修正スクリプト"
echo "================================"

# 1. SVG→PNG変換ツールのインストール
echo ""
echo "📦 SVG変換ツールをインストール中..."

if ! command -v rsvg-convert &> /dev/null; then
    echo "rsvg-convert をインストール中..."
    brew install librsvg
    if [ $? -eq 0 ]; then
        echo "✅ rsvg-convert インストール完了"
    else
        echo "❌ rsvg-convert インストール失敗"
        echo "Inkscape を試します..."
        brew install inkscape
        if [ $? -eq 0 ]; then
            echo "✅ Inkscape インストール完了"
        else
            echo "❌ SVG変換ツールのインストールに失敗しました"
            echo "手動でインストールしてください:"
            echo "  brew install librsvg"
            echo "  または"
            echo "  brew install inkscape"
        fi
    fi
else
    echo "✅ rsvg-convert は既にインストールされています"
fi

# 2. Python環境の設定
echo ""
echo "🐍 Python環境の設定..."

# 仮想環境の作成
if [ ! -d ".venv" ]; then
    echo "仮想環境を作成中..."
    python3 -m venv .venv
    echo "✅ 仮想環境を作成しました"
else
    echo "✅ 仮想環境は既に存在します"
fi

# 仮想環境の有効化
echo "仮想環境を有効化中..."
source .venv/bin/activate

# 必要なパッケージのインストール
echo "必要なパッケージをインストール中..."
pip install --upgrade pip
pip install setuptools wheel py2app

echo ""
echo "📋 インストールされたパッケージ:"
pip list | grep -E "(setuptools|py2app|wheel)"

echo ""
echo "🎉 環境修正完了！"
echo ""
echo "🚀 次のステップ:"
echo "1. source .venv/bin/activate  # 仮想環境の有効化"
echo "2. ./manual_icon_setup.sh     # アイコン作成"
echo "3. python3 setup.py py2app    # アプリビルド"
