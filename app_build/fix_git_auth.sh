#!/bin/bash

# fix_git_auth.sh - Git認証問題の修正スクリプト

echo "🔧 Git認証問題の修正"
echo "====================="
echo ""

# プロジェクトディレクトリに移動
PROJECT_DIR="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1"
cd "$PROJECT_DIR"

echo "📊 現在のGit設定を確認中..."
echo ""

# 現在のGit設定を表示
echo "🔗 リモートリポジトリ:"
git remote -v

echo ""
echo "👤 Git user設定:"
git config --global user.name || echo "❌ user.name が設定されていません"
git config --global user.email || echo "❌ user.email が設定されていません"

echo ""
echo "🔐 認証設定:"
git config --global credential.helper || echo "❌ credential.helper が設定されていません"

echo ""
echo "=== 解決方法を選択してください ==="
echo ""
echo "1. GitHub Personal Access Token を使用（推奨）"
echo "2. SSH鍵認証を設定"
echo "3. Git設定をリセットして再設定"
echo "4. 手動でユーザー名/パスワード入力"
echo ""
echo -n "選択 (1-4): "
read auth_choice

case $auth_choice in
    1)
        echo ""
        echo "=== Personal Access Token 認証設定 ==="
        echo ""
        echo "📋 手順:"
        echo "1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)"
        echo "2. 'Generate new token (classic)' をクリック"
        echo "3. 以下の権限を選択:"
        echo "   ☑ repo (Full control of private repositories)"
        echo "   ☑ workflow (Update GitHub Action workflows)" 
        echo "4. トークンをコピー（一度しか表示されません）"
        echo ""
        echo "🔗 GitHub Settings: https://github.com/settings/tokens"
        echo ""
        
        # Git設定のクリーンアップ
        echo "🧹 古い認証設定をクリアしています..."
        git config --global --unset credential.helper 2>/dev/null || true
        git config --global --unset-all credential.helper 2>/dev/null || true
        
        # macOS Keychain credential helperを設定
        echo "🔐 macOS Keychain認証を設定中..."
        git config --global credential.helper osxkeychain
        
        echo ""
        echo "👤 Gitユーザー情報を設定してください:"
        echo -n "GitHub ユーザー名: "
        read github_username
        echo -n "GitHub メールアドレス: "
        read github_email
        
        git config --global user.name "$github_username"
        git config --global user.email "$github_email"
        
        echo ""
        echo "✅ Git設定完了"
        echo ""
        echo "🚀 プッシュを再実行します..."
        echo "📝 注意: パスワード欄にPersonal Access Tokenを入力してください"
        echo ""
        
        git push -u origin main
        ;;
        
    2)
        echo ""
        echo "=== SSH鍵認証設定 ==="
        echo ""
        
        # SSH鍵の存在確認
        if [ -f ~/.ssh/id_rsa.pub ] || [ -f ~/.ssh/id_ed25519.pub ]; then
            echo "✅ SSH鍵が見つかりました"
            echo ""
            echo "📋 公開鍵の内容:"
            if [ -f ~/.ssh/id_ed25519.pub ]; then
                cat ~/.ssh/id_ed25519.pub
            elif [ -f ~/.ssh/id_rsa.pub ]; then
                cat ~/.ssh/id_rsa.pub
            fi
            echo ""
            echo "📋 この公開鍵をGitHubに追加してください:"
            echo "1. GitHub → Settings → SSH and GPG keys"
            echo "2. 'New SSH key' をクリック"
            echo "3. 上記の公開鍵をコピー&ペースト"
            echo ""
            echo "🔗 GitHub SSH Keys: https://github.com/settings/keys"
            
        else
            echo "❌ SSH鍵が見つかりません。新しく作成します..."
            echo ""
            echo -n "GitHub メールアドレス: "
            read github_email
            
            # SSH鍵を生成
            ssh-keygen -t ed25519 -C "$github_email" -f ~/.ssh/id_ed25519 -N ""
            
            # SSH agentに追加
            eval "$(ssh-agent -s)"
            ssh-add ~/.ssh/id_ed25519
            
            echo ""
            echo "📋 新しく生成された公開鍵:"
            cat ~/.ssh/id_ed25519.pub
            echo ""
            echo "📋 この公開鍵をGitHubに追加してください"
        fi
        
        # リモートURLをSSHに変更
        current_url=$(git remote get-url origin)
        if [[ $current_url == https://* ]]; then
            ssh_url=$(echo $current_url | sed 's/https:\/\/github.com\//git@github.com:/')
            git remote set-url origin "$ssh_url"
            echo "🔗 リモートURLをSSHに変更しました: $ssh_url"
        fi
        
        echo ""
        echo "SSH鍵をGitHubに追加後、Enterを押してください..."
        read
        
        echo "🚀 SSH接続テスト..."
        ssh -T git@github.com
        
        echo ""
        echo "🚀 プッシュを再実行します..."
        git push -u origin main
        ;;
        
    3)
        echo ""
        echo "=== Git設定リセット ==="
        echo ""
        
        # 認証設定をクリア
        echo "🧹 認証設定をクリアしています..."
        git config --global --unset credential.helper 2>/dev/null || true
        git config --global --unset-all credential.helper 2>/dev/null || true
        
        # VS Code関連の設定をクリア
        git config --global --unset core.askpass 2>/dev/null || true
        git config --global --unset-all core.askpass 2>/dev/null || true
        
        # macOS Keychain helperを設定
        git config --global credential.helper osxkeychain
        
        echo "👤 Gitユーザー情報を再設定してください:"
        echo -n "GitHub ユーザー名: "
        read github_username
        echo -n "GitHub メールアドレス: "
        read github_email
        
        git config --global user.name "$github_username"
        git config --global user.email "$github_email"
        
        echo ""
        echo "✅ Git設定をリセットしました"
        echo ""
        echo "🚀 プッシュを再実行します..."
        git push -u origin main
        ;;
        
    4)
        echo ""
        echo "=== 手動認証 ==="
        echo ""
        echo "📝 GitHub認証情報を入力してください:"
        echo "   ユーザー名: GitHubのユーザー名"
        echo "   パスワード: Personal Access Token (パスワードではない)"
        echo ""
        echo "⚠️  注意: GitHubはパスワード認証を廃止しています"
        echo "    パスワード欄にはPersonal Access Tokenを入力してください"
        echo ""
        
        # VS Code askpassを無効化
        export GIT_ASKPASS=""
        export SSH_ASKPASS=""
        unset GIT_ASKPASS
        unset SSH_ASKPASS
        
        git push -u origin main
        ;;
        
    *)
        echo "❌ 無効な選択です"
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 GitHubへのプッシュが成功しました！"
    echo ""
    echo "📋 プッシュ完了情報:"
    echo "  - リポジトリ: $(git remote get-url origin)"
    echo "  - ブランチ: $(git branch --show-current)"
    echo "  - 最新コミット: $(git log --oneline -1)"
    echo ""
    echo "🔗 GitHubでリポジトリを確認:"
    echo "   $(git remote get-url origin | sed 's/\.git$//')"
    
else
    echo ""
    echo "❌ プッシュに失敗しました"
    echo ""
    echo "🔧 さらなるトラブルシューティング:"
    echo "1. GitHub Personal Access Token の権限を確認"
    echo "2. インターネット接続を確認"
    echo "3. GitHubのサービス状況を確認: https://status.github.com"
    echo ""
    echo "💡 代替方法:"
    echo "- GitHub Desktop アプリを使用"
    echo "- GitHub CLI (gh) を使用"
    echo "- ブラウザでファイルを直接アップロード"
fi
