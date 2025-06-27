#!/bin/bash

# build_app.sh - DOI Tool macOS App Builder Script

echo "=== DOI Tool macOS App Builder ==="
echo ""

# 現在のディレクトリを保存
ORIGINAL_DIR=$(pwd)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "プロジェクトディレクトリ: $PROJECT_DIR"
echo "ビルドディレクトリ: $SCRIPT_DIR"
echo ""

# 必要なパッケージをインストール
echo "=== 依存関係のインストール ==="
pip3 install --user py2app
pip3 install --user pandas requests requests_cache tqdm nltk aiohttp async_timeout

echo ""
echo "=== アプリケーションのビルド ==="

# ビルドディレクトリに移動
cd "$SCRIPT_DIR"

# 古いビルドファイルを削除
rm -rf build/ dist/

# py2appでアプリケーションをビルド
python3 setup.py py2app

if [ $? -eq 0 ]; then
    echo ""
    echo "=== ビルド成功！ ==="
    echo "アプリケーションが dist/gui_main.app に作成されました"
    echo ""
    
    # アプリケーションをApplicationsフォルダにコピー
    echo "Applicationsフォルダにコピーしますか？ (y/n)"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        sudo cp -R "dist/gui_main.app" "/Applications/DOI Tool.app"
        echo "DOI Tool.app が /Applications/ にインストールされました"
        echo "Launchpadまたは /Applications フォルダから起動できます"
    else
        echo "dist/gui_main.app を手動で /Applications フォルダにコピーしてください"
    fi
    
    echo ""
    echo "=== 使用方法 ==="
    echo "1. アプリケーションを起動"
    echo "2. 作業ディレクトリを選択（ScopusのCSVファイルが入っているフォルダ）"
    echo "3. '処理を開始' ボタンをクリック"
    echo "4. 完了後、md_folder にMarkdownファイルが生成されます"
    
else
    echo ""
    echo "=== ビルドエラー ==="
    echo "ビルドに失敗しました。エラーログを確認してください。"
fi

# 元のディレクトリに戻る
cd "$ORIGINAL_DIR"
