#!/bin/bash

# quick_fix_and_build.sh - 一発修正&ビルドスクリプト

echo "🚀 DOI Tool 一発修正&ビルド"
echo "=========================="

# 実行権限を設定
chmod +x fix_environment.sh
chmod +x build_doi_tool_app_fixed.sh
chmod +x manual_icon_setup.sh

echo "✅ 実行権限を設定しました"

# 環境修正
echo ""
echo "🔧 環境を修正中..."
./fix_environment.sh

# ビルド実行
echo ""
echo "🔨 アプリビルドを実行中..."
./build_doi_tool_app_fixed.sh

echo ""
echo "🎉 すべて完了しました！"
