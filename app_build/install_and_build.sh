#!/bin/bash

# install_and_build.sh - 完全自動インストール・ビルドスクリプト

echo "=== DOI Tool - 完全自動セットアップ ==="
echo ""

# エラー時に停止
set -e

# 現在のディレクトリを保存
ORIGINAL_DIR=$(pwd)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "プロジェクトディレクトリ: $PROJECT_DIR"
echo "ビルドディレクトリ: $SCRIPT_DIR"
echo ""

# macOSとPythonの確認
echo "=== システム確認 ==="
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "エラー: このスクリプトはmacOS専用です"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "エラー: Python 3がインストールされていません"
    echo "Homebrewでインストールしてください: brew install python3"
    exit 1
fi

echo "✅ macOS検出"
echo "✅ Python 3検出: $(python3 --version)"
echo ""

# Homebrewの確認とインストール
echo "=== Homebrew確認 ==="
if ! command -v brew &> /dev/null; then
    echo "Homebrewがインストールされていません。インストールしますか？ (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrewが必要です。手動でインストールしてください。"
        exit 1
    fi
else
    echo "✅ Homebrew検出"
fi
echo ""

# Xcodeコマンドラインツールの確認
echo "=== Xcodeコマンドラインツール確認 ==="
if ! xcode-select -p &> /dev/null; then
    echo "Xcodeコマンドラインツールをインストールします..."
    xcode-select --install
    echo "インストール完了後、このスクリプトを再実行してください。"
    exit 1
else
    echo "✅ Xcodeコマンドラインツール検出"
fi
echo ""

# 仮想環境の作成と有効化
echo "=== 仮想環境セットアップ ==="
cd "$SCRIPT_DIR"

if [ -d "venv" ]; then
    echo "既存の仮想環境を削除しています..."
    rm -rf venv
fi

echo "仮想環境を作成中..."
python3 -m venv venv
source venv/bin/activate

echo "✅ 仮想環境作成完了"
echo ""

# 依存関係のインストール
echo "=== 依存関係インストール ==="
pip install --upgrade pip
pip install -r requirements.txt

echo "✅ 依存関係インストール完了"
echo ""

# アプリケーションのビルド
echo "=== アプリケーションビルド ==="

# 古いビルドファイルを削除
rm -rf build/ dist/

# py2appでアプリケーションをビルド
python setup.py py2app --packages=pandas,requests,nltk,aiohttp

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 ビルド成功！"
    echo ""
    
    # アプリケーション名を変更
    if [ -d "dist/gui_main.app" ]; then
        mv "dist/gui_main.app" "dist/DOI Tool.app"
    fi
    
    # アプリケーションをApplicationsフォルダにコピー
    echo "DOI Tool.app を /Applications フォルダにインストールしますか？ (y/n)"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        if [ -d "/Applications/DOI Tool.app" ]; then
            echo "既存のアプリケーションを削除中..."
            sudo rm -rf "/Applications/DOI Tool.app"
        fi
        
        echo "アプリケーションをインストール中..."
        sudo cp -R "dist/DOI Tool.app" "/Applications/"
        
        echo ""
        echo "🎉 インストール完了！"
        echo ""
        echo "=== 使用方法 ==="
        echo "1. Launchpadまたは /Applications フォルダから 'DOI Tool' を起動"
        echo "2. 作業ディレクトリを選択（ScopusのCSVファイルが入っているフォルダ）"
        echo "3. 'ファイル一覧を更新' でCSVファイルを確認"
        echo "4. '処理を開始' ボタンをクリック"
        echo "5. 完了後、md_folder にMarkdownファイルが生成されます"
        echo ""
        echo "アプリケーションを今すぐ起動しますか？ (y/n)"
        read -r launch_response
        
        if [[ "$launch_response" =~ ^[Yy]$ ]]; then
            open "/Applications/DOI Tool.app"
        fi
        
    else
        echo ""
        echo "アプリケーションは dist/DOI Tool.app に作成されました"
        echo "手動で /Applications フォルダにコピーしてください"
    fi
    
else
    echo ""
    echo "❌ ビルドエラー"
    echo "詳細なエラーログを確認してください"
    exit 1
fi

# 仮想環境を無効化
deactivate

# 元のディレクトリに戻る
cd "$ORIGINAL_DIR"

echo ""
echo "=== セットアップ完了 ==="
echo "DOI Tool macOSアプリケーションが正常にインストールされました！"
