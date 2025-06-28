#!/bin/bash

# start_doi_tool.sh - DOI Tool 簡単起動スクリプト（自動セットアップ付き）

echo "🚀 DOI Tool - 自動セットアップ & 起動"
echo "=================================="
echo ""

# プロジェクトディレクトリに移動
PROJECT_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"
APP_BUILD_DIR="$PROJECT_DIR/app_build"

echo "📁 プロジェクトディレクトリ: $PROJECT_DIR"
echo ""

# ディレクトリ確認
if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ プロジェクトディレクトリが見つかりません: $PROJECT_DIR"
    exit 1
fi

if [ ! -d "$APP_BUILD_DIR" ]; then
    echo "❌ app_buildディレクトリが見つかりません: $APP_BUILD_DIR"
    exit 1
fi

# app_buildディレクトリに移動
cd "$APP_BUILD_DIR"

echo "📦 自動セットアップ版DOI Toolを起動中..."
echo ""

# 自動インストール&実行スクリプトを起動
python3 auto_install_and_run.py

# 終了メッセージ
echo ""
echo "👋 DOI Tool を終了しました"
echo "ご利用ありがとうございました！"
