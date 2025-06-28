#!/bin/bash

# check_commands.sh - 実行可能コマンドとパスの確認

echo "🔍 コマンドとパスの確認"
echo "======================"
echo ""

# 現在の場所を確認
echo "📍 現在のディレクトリ:"
pwd
echo ""

# DOI_tool_ver1プロジェクトディレクトリの確認
PROJECT_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"
if [ -d "$PROJECT_DIR" ]; then
    echo "✅ プロジェクトディレクトリ: $PROJECT_DIR"
else
    echo "❌ プロジェクトディレクトリが見つかりません: $PROJECT_DIR"
fi
echo ""

# app_buildディレクトリの確認
APP_BUILD_DIR="$PROJECT_DIR/app_build"
if [ -d "$APP_BUILD_DIR" ]; then
    echo "✅ app_buildディレクトリ: $APP_BUILD_DIR"
else
    echo "❌ app_buildディレクトリが見つかりません: $APP_BUILD_DIR"
fi
echo ""

# 利用可能なスクリプトファイルの確認
echo "📋 利用可能なスクリプト:"
cd "$APP_BUILD_DIR" 2>/dev/null || {
    echo "❌ app_buildディレクトリに移動できません"
    exit 1
}

echo ""
echo "🔧 実行可能スクリプト一覧:"
for script in *.sh *.py; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            echo "  ✅ $script (実行可能)"
        else
            echo "  ⚠️  $script (実行権限なし)"
        fi
    fi
done

echo ""
echo "📝 Python スクリプト一覧:"
for script in *.py; do
    if [ -f "$script" ]; then
        echo "  📄 $script"
    fi
done

echo ""
echo "🔨 実行権限の一括設定"
echo "======================"
echo "実行権限を設定しますか？ (y/n): "
read set_permissions

if [[ "$set_permissions" =~ ^[Yy]$ ]]; then
    echo "🔧 実行権限を設定中..."
    chmod +x *.sh
    chmod +x *.py
    echo "✅ 実行権限を設定しました"
    echo ""
    
    echo "📋 更新後の実行可能ファイル:"
    for script in *.sh *.py; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            echo "  ✅ $script"
        fi
    done
fi

echo ""
echo "🚀 推奨実行コマンド"
echo "==================="
echo ""
echo "📁 プロジェクトディレクトリに移動:"
echo "   cd '$PROJECT_DIR'"
echo ""
echo "📁 app_buildディレクトリに移動:"
echo "   cd '$APP_BUILD_DIR'"
echo ""
echo "🔍 ファイルブラウザ版DOI Tool:"
echo "   ./quick_file_browser.sh"
echo ""
echo "📊 進捗バー版DOI Tool:"
echo "   ./quick_progress.sh"
echo ""
echo "🔧 Git認証修正:"
echo "   ./fix_git_auth.sh"
echo ""
echo "⚙️  基本インストール:"
echo "   ./quick_install.sh"
echo ""

# システムコマンドの確認
echo "🖥️  システムコマンドの確認"
echo "========================="
echo ""

commands=("python3" "git" "brew" "gh")
for cmd in "${commands[@]}"; do
    if command -v "$cmd" &> /dev/null; then
        echo "✅ $cmd: $(which $cmd)"
        if [ "$cmd" = "python3" ]; then
            echo "   バージョン: $(python3 --version)"
        elif [ "$cmd" = "git" ]; then
            echo "   バージョン: $(git --version)"
        fi
    else
        echo "❌ $cmd: コマンドが見つかりません"
    fi
done

echo ""
echo "🎯 次のステップ"
echo "==============="
echo ""
echo "1. app_buildディレクトリに移動:"
echo "   cd '$APP_BUILD_DIR'"
echo ""
echo "2. 好みのツールを起動:"
echo "   ./quick_file_browser.sh    # ファイルブラウザ版（推奨）"
echo "   ./quick_progress.sh        # 進捗バー版"
echo "   ./quick_install.sh         # 基本版"
echo ""
echo "3. Git認証修正（必要な場合）:"
echo "   ./fix_git_auth.sh"
echo ""
echo "💡 Tips:"
echo "   - './script_name.sh' の形式で実行してください"
echo "   - 'python3 script_name.py' でPythonスクリプトを直接実行可能"
echo "   - 実行権限エラーの場合は 'chmod +x script_name.sh' で修正"
