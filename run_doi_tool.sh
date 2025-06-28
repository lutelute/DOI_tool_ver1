#!/bin/bash

# run_doi_tool.sh - DOI Tool メイン起動スクリプト

echo "🔬 DOI Tool - Scopus CSV Processing Suite"
echo "=========================================="
echo ""
echo "📚 機能:"
echo "  - ScopusのCSVファイルをMarkdownに変換"
echo "  - DOI情報の自動取得と整理"
echo "  - 参考文献の相互リンク生成"
echo "  - 改良されたキーワード抽出とタグ付け"
echo ""

# 自動セットアップ版を起動
echo "🚀 自動セットアップ版を起動します..."
echo "（必要なパッケージが自動的にインストールされます）"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_BUILD_DIR="$SCRIPT_DIR/app_build"

if [ -f "$APP_BUILD_DIR/start_doi_tool.sh" ]; then
    chmod +x "$APP_BUILD_DIR/start_doi_tool.sh"
    "$APP_BUILD_DIR/start_doi_tool.sh"
else
    echo "❌ 起動スクリプトが見つかりません"
    echo "app_buildディレクトリを確認してください"
    exit 1
fi
