#!/bin/bash
# build_doi_tool_app.sh - DOI Tool アプリ自動ビルドスクリプト

echo "🔬 DOI Tool アプリケーション ビルド開始"
echo "========================================"

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Pythonとツールの確認
echo "📋 環境チェック..."
python3 --version || { echo "❌ Python3が必要です"; exit 1; }

# アイコン作成
echo ""
echo "🎨 アイコンファイル作成..."
python3 create_app_icon.py

# 依存関係インストール
echo ""
echo "📦 依存関係インストール..."
pip3 install --upgrade py2app

# 古いビルド成果物を削除
echo ""
echo "🧹 古いビルドファイルを削除..."
rm -rf build/ dist/ *.app

# アプリケーションをビルド
echo ""
echo "🔨 アプリケーションビルド実行..."
python3 setup.py py2app --arch=universal2

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 ビルド成功！"
    
    # アプリケーション名を変更
    if [ -d "dist/gui_main.app" ]; then
        mv "dist/gui_main.app" "dist/DOI Tool.app"
        echo "✅ アプリ名を 'DOI Tool.app' に変更しました"
    fi
    
    # アプリケーション情報を表示
    if [ -d "dist/DOI Tool.app" ]; then
        app_size=$(du -sh "dist/DOI Tool.app" | cut -f1)
        echo "📱 アプリサイズ: $app_size"
        echo "📁 場所: $(pwd)/dist/DOI Tool.app"
        
        # Applicationsフォルダにインストールするか確認
        echo ""
        echo "Applicationsフォルダにインストールしますか？ (y/n)"
        read -r install_choice
        
        if [[ "$install_choice" =~ ^[Yy]$ ]]; then
            # 既存のアプリを削除
            if [ -d "/Applications/DOI Tool.app" ]; then
                echo "既存のアプリを削除中..."
                sudo rm -rf "/Applications/DOI Tool.app"
            fi
            
            # 新しいアプリをコピー
            echo "アプリをインストール中..."
            sudo cp -R "dist/DOI Tool.app" "/Applications/"
            
            if [ $? -eq 0 ]; then
                echo "🎉 DOI Tool.app が /Applications にインストールされました！"
                echo ""
                echo "🚀 起動方法:"
                echo "  - Launchpadから 'DOI Tool' を検索"
                echo "  - Finder → アプリケーション → DOI Tool.app"
                echo "  - ターミナルから: open '/Applications/DOI Tool.app'"
                
                # 起動確認
                echo ""
                echo "今すぐアプリを起動しますか？ (y/n)"
                read -r launch_choice
                
                if [[ "$launch_choice" =~ ^[Yy]$ ]]; then
                    open "/Applications/DOI Tool.app"
                fi
            else
                echo "❌ インストールに失敗しました"
            fi
        else
            echo "アプリは dist/DOI Tool.app に作成されました"
            echo "手動でApplicationsフォルダにドラッグ&ドロップしてください"
        fi
    fi
else
    echo ""
    echo "❌ ビルドに失敗しました"
    echo "エラーログを確認してください"
    exit 1
fi

echo ""
echo "✨ ビルドプロセス完了！"
