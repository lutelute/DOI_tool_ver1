#!/bin/bash

# install_doi_tool.sh - ユーザー向けシンプルインストーラー

echo "🔬 DOI Tool インストーラー"
echo "========================="
echo ""

# カレントディレクトリの確認
echo "📁 インストールファイルを確認中..."

# アプリの存在確認
if [ -d "DOI Tool.app" ]; then
    echo "✅ DOI Tool.app が見つかりました"
elif [ -f "DOI_Tool_v1.0.dmg" ]; then
    echo "✅ DOI_Tool_v1.0.dmg が見つかりました"
    echo "🔄 DMGファイルをマウント中..."
    hdiutil attach "DOI_Tool_v1.0.dmg"
    
    # マウントされたボリュームからアプリを探す
    mounted_app=$(find /Volumes -name "DOI Tool.app" -type d 2>/dev/null | head -1)
    if [ -n "$mounted_app" ]; then
        echo "✅ マウントされたDMGからアプリを検出しました"
        APP_PATH="$mounted_app"
    else
        echo "❌ マウントされたDMGにDOI Tool.appが見つかりません"
        exit 1
    fi
else
    echo "❌ DOI Tool.app または DOI_Tool_v1.0.dmg が見つかりません"
    echo ""
    echo "💡 使用方法:"
    echo "  1. DOI_Tool_v1.0.dmg をダウンロード"
    echo "  2. このインストールスクリプトと同じフォルダに配置"
    echo "  3. このスクリプトを再実行"
    echo ""
    echo "  または、DMGファイルをダブルクリックして"
    echo "  DOI Tool.app を手動でApplicationsフォルダにドラッグ&ドロップ"
    exit 1
fi

# アプリパスを設定（ローカルにある場合）
if [ -z "$APP_PATH" ]; then
    APP_PATH="DOI Tool.app"
fi

echo ""
echo "📱 DOI Tool を /Applications にインストールします"

# システム要件チェック
echo ""
echo "📋 システム要件をチェック中..."

# macOSバージョンチェック
macos_version=$(sw_vers -productVersion)
echo "🍎 macOS バージョン: $macos_version"

# Python3の確認
if command -v python3 &> /dev/null; then
    python_version=$(python3 --version)
    echo "🐍 Python: $python_version"
else
    echo "⚠️  Python3が見つかりません"
    echo "   DOI Toolは動作しますが、一部機能が制限される可能性があります"
fi

# インターネット接続チェック
echo ""
echo "🌐 インターネット接続をチェック中..."
if ping -c 1 google.com &> /dev/null; then
    echo "✅ インターネット接続OK"
else
    echo "⚠️  インターネット接続が確認できません"
    echo "   DOI解決機能にはインターネット接続が必要です"
fi

# 既存アプリの確認
echo ""
if [ -d "/Applications/DOI Tool.app" ]; then
    echo "⚠️  既存のDOI Tool.appが見つかりました"
    
    # 既存アプリの情報表示
    existing_version=$(defaults read "/Applications/DOI Tool.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "不明")
    echo "📦 既存バージョン: $existing_version"
    
    echo ""
    echo "上書きインストールしますか？ (y/n)"
    read -r overwrite
    
    if [[ "$overwrite" != [Yy]* ]]; then
        echo "❌ インストールをキャンセルしました"
        
        # DMGをアンマウント（必要に応じて）
        if [ -n "$mounted_app" ]; then
            volume_name=$(dirname "$mounted_app" | xargs basename)
            hdiutil detach "/Volumes/$volume_name" 2>/dev/null
        fi
        
        exit 0
    fi
    
    echo "🗑️  既存アプリを削除中..."
    if sudo rm -rf "/Applications/DOI Tool.app"; then
        echo "✅ 既存アプリを削除しました"
    else
        echo "❌ 既存アプリの削除に失敗しました"
        echo "   手動で /Applications/DOI Tool.app を削除してください"
        exit 1
    fi
fi

# インストール実行
echo ""
echo "📦 インストール中..."
echo "   管理者権限が必要です"

if sudo cp -R "$APP_PATH" "/Applications/"; then
    echo "✅ DOI Tool のインストールが完了しました！"
    
    # インストール後の確認
    if [ -d "/Applications/DOI Tool.app" ]; then
        app_size=$(du -sh "/Applications/DOI Tool.app" | cut -f1)
        echo "📱 インストールサイズ: $app_size"
        
        # バージョン情報表示
        new_version=$(defaults read "/Applications/DOI Tool.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "1.0.0")
        echo "📦 バージョン: $new_version"
    fi
    
    # DMGをアンマウント（必要に応じて）
    if [ -n "$mounted_app" ]; then
        echo "💿 DMGファイルをアンマウント中..."
        volume_name=$(dirname "$mounted_app" | xargs basename)
        hdiutil detach "/Volumes/$volume_name" 2>/dev/null
        echo "✅ DMGファイルをアンマウントしました"
    fi
    
    echo ""
    echo "🎉 インストール完了！"
    echo ""
    echo "🚀 起動方法:"
    echo "  📱 Launchpadから 'DOI Tool' を検索"
    echo "  🗂️  Finder → アプリケーション → DOI Tool"
    echo "  ⌨️  ターミナルから: open '/Applications/DOI Tool.app'"
    echo ""
    echo "📖 使用方法:"
    echo "  1. DOI Tool を起動"
    echo "  2. ScopusのCSVファイルがあるフォルダを選択"
    echo "  3. '処理を開始' ボタンをクリック"
    echo "  4. 完了後、md_folderにMarkdownファイルが生成されます"
    echo ""
    echo "今すぐDOI Toolを起動しますか？ (y/n)"
    read -r launch
    
    if [[ "$launch" == [Yy]* ]]; then
        echo "🚀 DOI Tool を起動中..."
        open "/Applications/DOI Tool.app"
        
        # 少し待ってから起動確認
        sleep 2
        if pgrep -f "DOI Tool" > /dev/null; then
            echo "✅ DOI Tool が正常に起動しました"
        else
            echo "⚠️  起動を確認できませんでした"
            echo "   手動でLaunchpadから起動してください"
        fi
    fi
    
else
    echo "❌ インストールに失敗しました"
    echo ""
    echo "🔧 トラブルシューティング:"
    echo "  1. 管理者権限があることを確認"
    echo "  2. /Applications フォルダへの書き込み権限を確認"
    echo "  3. ディスク容量が十分であることを確認"
    echo ""
    echo "🆘 手動インストール方法:"
    echo "  1. DOI_Tool_v1.0.dmg をダブルクリック"
    echo "  2. 開いたウィンドウから DOI Tool.app を"
    echo "     Applications フォルダにドラッグ&ドロップ"
    
    exit 1
fi

echo ""
echo "📚 追加情報:"
echo "  🌐 DOI解決にはインターネット接続が必要です"
echo "  📄 対応ファイル: Scopus CSVエクスポート"
echo "  💾 出力形式: Markdownファイル"
echo ""
echo "🆘 問題が発生した場合:"
echo "  - アプリが起動しない → システム設定でセキュリティ許可"
echo "  - 処理が止まる → インターネット接続とCSVファイル形式を確認"
echo "  - エラーが発生 → アプリを再起動してから再実行"
echo ""
echo "✨ DOI Tool をお楽しみください！"
