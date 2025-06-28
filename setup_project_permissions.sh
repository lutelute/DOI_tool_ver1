#!/bin/bash

# setup_project_permissions.sh - プロジェクト権限設定

echo "🔧 DOI Tool プロジェクト権限設定"
echo "================================"

PROJECT_ROOT="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"

# 開発者ツールの権限設定
echo "🛠️  開発者ツールの権限設定..."
chmod +x "$PROJECT_ROOT/developer_tools/developer_build.sh"
chmod +x "$PROJECT_ROOT/developer_tools/icon_generator.py"

# ユーザー配布ツールの権限設定
echo "📦 ユーザー配布ツールの権限設定..."
chmod +x "$PROJECT_ROOT/user_distribution/install_doi_tool.sh"

# app_buildの既存スクリプト権限設定
echo "🔨 app_buildスクリプトの権限設定..."
chmod +x "$PROJECT_ROOT/app_build"/*.sh
chmod +x "$PROJECT_ROOT/app_build"/*.py

echo "✅ すべての権限設定が完了しました"
echo ""
echo "🚀 次のステップ:"
echo "1. 開発者向けビルド:"
echo "   cd $PROJECT_ROOT/developer_tools"
echo "   ./developer_build.sh"
echo ""
echo "2. ユーザー向けインストール（配布後）:"
echo "   cd $PROJECT_ROOT/user_distribution"
echo "   ./install_doi_tool.sh"
