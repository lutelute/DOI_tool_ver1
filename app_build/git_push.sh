#!/bin/bash

# git_push.sh - DOI Tool GitHubプッシュスクリプト

echo "🚀 DOI Tool - GitHub Push & Commit スクリプト"
echo "=============================================="
echo ""

# プロジェクトディレクトリに移動
PROJECT_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"
cd "$PROJECT_DIR"

echo "📁 プロジェクトディレクトリ: $PROJECT_DIR"
echo ""

# Gitの状態確認
echo "📊 現在のGit状態を確認中..."
echo ""

if [ ! -d ".git" ]; then
    echo "❌ Gitリポジトリが初期化されていません"
    echo "初期化しますか？ (y/n): "
    read init_git
    
    if [[ "$init_git" =~ ^[Yy]$ ]]; then
        echo "🔧 Gitリポジトリを初期化中..."
        git init
        echo "✅ Gitリポジトリを初期化しました"
    else
        echo "❌ Git初期化がキャンセルされました"
        exit 1
    fi
fi

# リモートリポジトリの確認
echo "🔗 リモートリポジトリの確認..."
if ! git remote | grep -q origin; then
    echo "⚠️  リモートリポジトリが設定されていません"
    echo "GitHubリポジトリのURLを入力してください:"
    echo "例: https://github.com/username/DOI_tool_ver1.git"
    read repo_url
    
    if [ -n "$repo_url" ]; then
        git remote add origin "$repo_url"
        echo "✅ リモートリポジトリを設定しました: $repo_url"
    else
        echo "❌ リモートリポジトリの設定がキャンセルされました"
        exit 1
    fi
else
    echo "✅ リモートリポジトリが設定されています: $(git remote get-url origin)"
fi

echo ""

# 変更されたファイルの確認
echo "📝 変更されたファイルの確認..."
git status --porcelain

echo ""
echo "📋 詳細なステータス:"
git status

echo ""

# .gitignoreファイルの作成
if [ ! -f ".gitignore" ]; then
    echo "📄 .gitignoreファイルを作成中..."
    cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Virtual Environment
.venv/
venv/
ENV/
env/

# Cache
.cache/
crossref_cache.sqlite
requests_cache.sqlite

# Logs
*.log
error_log.txt

# Output folders
JSON_folder/
md_folder/
output/

# Combined CSV
scopus_combined.csv

# macOS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Build artifacts
build/
dist/
*.app/

# Temporary files
*.tmp
*.temp
*~
EOF
    echo "✅ .gitignoreファイルを作成しました"
fi

echo ""

# 追加するファイルの確認
echo "📦 追加予定のファイル一覧:"
echo ""
echo "🔬 メインスクリプト:"
echo "  - main.py"
echo "  - combine_scopus_csv.py"  
echo "  - scopus_doi_to_json.py"
echo "  - json2tag_ref_scopus_async.py"
echo "  - add_abst_scopus.py"
echo ""
echo "📱 アプリケーション化ファイル (app_build/):"
echo "  - gui_main.py (GUI版)"
echo "  - progress_cli.py (進捗バー付きCLI版)"
echo "  - gui_progress.py (進捗バー付きGUI版)"
echo "  - file_browser.py (ファイルブラウザ付きCLI版)"
echo "  - gui_file_browser.py (ファイルブラウザ付きGUI版)"
echo "  - cli_gui.py (コマンドライン版GUI)"
echo "  - simple_run.py (シンプル実行版)"
echo ""
echo "🔧 インストール・設定ファイル:"
echo "  - setup.py (py2app設定)"
echo "  - standalone_installer.py (スタンドアロンアプリ作成)"
echo "  - requirements.txt (依存関係)"
echo ""
echo "🚀 起動スクリプト:"
echo "  - quick_install.sh (クイックインストール)"
echo "  - quick_progress.sh (進捗バー付き起動)"
echo "  - quick_file_browser.sh (ファイルブラウザ付き起動)"
echo "  - emergency_run.sh (緊急時実行)"
echo ""
echo "🔧 サポートスクリプト:"
echo "  - fix_tkinter.sh (tkinter問題修正)"
echo "  - diagnose.sh (問題診断)"
echo "  - set_permissions.sh (実行権限設定)"
echo ""
echo "📖 ドキュメント:"
echo "  - README.md"
echo "  - INSTALL.md / INSTALL_UPDATED.md"
echo "  - README_PROGRESS.md (進捗バー版説明)"
echo "  - README_FILE_BROWSER.md (ファイルブラウザ版説明)"

echo ""
echo "全てのファイルを追加しますか？ (y/n): "
read add_all

if [[ "$add_all" =~ ^[Yy]$ ]]; then
    echo ""
    echo "📦 ファイルをステージングエリアに追加中..."
    
    # 全ファイルを追加
    git add .
    
    echo "✅ ファイルの追加完了"
    
    echo ""
    echo "📝 追加されたファイルの確認:"
    git status --cached --name-only | head -20
    file_count=$(git status --cached --name-only | wc -l)
    echo "... 合計 $file_count ファイル"
    
else
    echo "❌ ファイル追加がキャンセルされました"
    exit 1
fi

echo ""
echo "💬 コミットメッセージを入力してください:"
echo "（Enterで以下のデフォルトメッセージを使用）"
echo ""
echo "デフォルト: 'feat: Add comprehensive DOI Tool with multiple UI options'"
echo ""
echo "🎯 推奨メッセージ例:"
echo "  - feat: Add DOI Tool with GUI, CLI, and file browser versions"
echo "  - feat: Implement progress bars and Finder-like file selection"
echo "  - update: Add multiple execution methods and troubleshooting tools"
echo ""
echo -n "コミットメッセージ: "
read commit_message

if [ -z "$commit_message" ]; then
    commit_message="feat: Add comprehensive DOI Tool with multiple UI options

- GUI版: tkinter使用のグラフィカルインターフェース
- CLI版: ターミナル内での対話的操作
- 進捗バー付き版: リアルタイム進捗表示
- ファイルブラウザ付き版: Finderライクなファイル選択
- macOSアプリ化: .appファイル生成機能
- トラブルシューティング: tkinter問題解決ツール
- 複数起動方法: 環境に応じた最適な実行方法を提供

Main features:
- Scopus CSV to Markdown conversion
- DOI resolution via Crossref API
- Reference processing and linking
- Multiple UI options for different preferences
- Progress tracking and error handling
- Comprehensive documentation and setup tools"
fi

echo ""
echo "📝 コミット実行中..."
git commit -m "$commit_message"

if [ $? -eq 0 ]; then
    echo "✅ コミットが完了しました"
else
    echo "❌ コミットに失敗しました"
    exit 1
fi

echo ""
echo "🚀 GitHubにプッシュしますか？ (y/n): "
read push_confirm

if [[ "$push_confirm" =~ ^[Yy]$ ]]; then
    echo ""
    echo "📤 GitHubにプッシュ中..."
    
    # 現在のブランチを確認
    current_branch=$(git branch --show-current)
    echo "📍 現在のブランチ: $current_branch"
    
    # プッシュ実行
    git push -u origin "$current_branch"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "🎉 GitHubへのプッシュが完了しました！"
        echo ""
        echo "📋 プッシュ完了情報:"
        echo "  - ブランチ: $current_branch"
        echo "  - リモート: $(git remote get-url origin)"
        echo "  - コミット: $(git log --oneline -1)"
        echo ""
        echo "🔗 GitHubでリポジトリを確認できます:"
        echo "   $(git remote get-url origin)"
        
    else
        echo ""
        echo "❌ プッシュに失敗しました"
        echo ""
        echo "🔧 考えられる原因:"
        echo "  - 認証エラー (GitHub認証を確認してください)"
        echo "  - ネットワークエラー"
        echo "  - リポジトリのアクセス権限"
        echo "  - ブランチ保護設定"
        echo ""
        echo "💡 解決方法:"
        echo "  1. GitHub認証の確認: git config --global user.email"
        echo "  2. SSH鍵の設定確認"
        echo "  3. HTTPSトークンの確認"
        exit 1
    fi
else
    echo ""
    echo "📦 コミットのみ完了しました（プッシュはスキップ）"
    echo "後でプッシュするには以下のコマンドを実行してください:"
    echo "  git push -u origin $(git branch --show-current)"
fi

echo ""
echo "📊 最終的なリポジトリ状況:"
git log --oneline -3
echo ""
echo "🎯 今後の作業:"
echo "  - GitHub上でREADME.mdを確認・編集"
echo "  - Issues/Pull Requestsの設定"
echo "  - リリースタグの作成（必要に応じて）"
echo ""
echo "✨ DOI Toolプロジェクトの公開準備が完了しました！"
