#!/bin/bash

# build_doi_tool_app_fixed.sh - 修正版DOI Tool アプリビルドスクリプト

echo "🔬 DOI Tool アプリケーション ビルド開始（修正版）"
echo "=================================================="

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Pythonとツールの確認
echo "📋 環境チェック..."
python3 --version || { echo "❌ Python3が必要です"; exit 1; }

# 仮想環境の確認・作成
if [ ! -d ".venv" ]; then
    echo ""
    echo "🐍 仮想環境を作成中..."
    python3 -m venv .venv
    if [ $? -ne 0 ]; then
        echo "❌ 仮想環境の作成に失敗しました"
        exit 1
    fi
    echo "✅ 仮想環境を作成しました"
fi

# 仮想環境の有効化
echo ""
echo "🔄 仮想環境を有効化中..."
source .venv/bin/activate

# 依存関係のインストール
echo ""
echo "📦 依存関係インストール..."
pip install --upgrade pip
pip install setuptools wheel py2app

if [ $? -ne 0 ]; then
    echo "❌ 依存関係のインストールに失敗しました"
    exit 1
fi

echo "✅ 依存関係インストール完了"

# SVG変換ツールの確認
echo ""
echo "🎨 SVG変換ツールの確認..."
if command -v rsvg-convert &> /dev/null; then
    echo "✅ rsvg-convert が利用可能です"
    SVG_TOOL="rsvg-convert"
elif command -v inkscape &> /dev/null; then
    echo "✅ Inkscape が利用可能です"
    SVG_TOOL="inkscape"
else
    echo "⚠️  SVG変換ツールが見つかりません"
    echo "アイコンなしでビルドを継続しますか？ (y/n)"
    read -r continue_choice
    if [[ "$continue_choice" != [Yy]* ]]; then
        echo "ビルドを中止します"
        echo "以下のコマンドでSVG変換ツールをインストールしてください:"
        echo "  brew install librsvg"
        echo "  または"
        echo "  brew install inkscape"
        exit 1
    fi
    SVG_TOOL=""
fi

# アイコン作成
if [ -n "$SVG_TOOL" ]; then
    echo ""
    echo "🎨 アイコンファイル作成..."
    ./manual_icon_setup.sh
    
    if [ $? -eq 0 ] && [ -f "icons/DOI_Tool.icns" ]; then
        echo "✅ アイコンファイル作成完了"
    else
        echo "⚠️  アイコン作成に問題がありましたが、ビルドを継続します"
    fi
else
    echo "⚠️  SVG変換ツールがないため、アイコンなしでビルドします"
fi

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
        
        # アイコンの確認
        if [ -f "icons/DOI_Tool.icns" ]; then
            echo "🎨 カスタムアイコン: 適用済み"
        else
            echo "🎨 カスタムアイコン: 未適用（デフォルトアイコンを使用）"
        fi
        
        # アプリを開いて動作確認
        echo ""
        echo "アプリの動作確認を行いますか？ (y/n)"
        read -r test_choice
        
        if [[ "$test_choice" =~ ^[Yy]$ ]]; then
            echo "🧪 アプリを起動して動作確認中..."
            open "dist/DOI Tool.app"
            sleep 3
            echo "✅ 動作確認完了"
        fi
        
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
        
        # DMGファイル作成オプション
        echo ""
        echo "配布用DMGファイルを作成しますか？ (y/n)"
        read -r dmg_choice
        
        if [[ "$dmg_choice" =~ ^[Yy]$ ]]; then
            echo "📦 DMGファイルを作成中..."
            hdiutil create -volname "DOI Tool" \
                           -srcfolder "dist/DOI Tool.app" \
                           -ov -format UDZO \
                           "DOI_Tool_v1.0.dmg"
            
            if [ $? -eq 0 ]; then
                dmg_size=$(du -sh "DOI_Tool_v1.0.dmg" | cut -f1)
                echo "✅ DMGファイルを作成しました: DOI_Tool_v1.0.dmg ($dmg_size)"
            else
                echo "❌ DMGファイルの作成に失敗しました"
            fi
        fi
    fi
else
    echo ""
    echo "❌ ビルドに失敗しました"
    echo ""
    echo "🔧 トラブルシューティング:"
    echo "1. 仮想環境が正しく有効化されているか確認"
    echo "2. 必要な依存関係がインストールされているか確認"
    echo "3. setup.pyファイルに問題がないか確認"
    echo ""
    echo "詳細なエラーログ:"
    echo "--------------------"
    exit 1
fi

echo ""
echo "✨ ビルドプロセス完了！"
echo ""
echo "📋 作成されたファイル:"
if [ -d "dist/DOI Tool.app" ]; then
    echo "  📱 アプリケーション: dist/DOI Tool.app"
fi
if [ -f "DOI_Tool_v1.0.dmg" ]; then
    echo "  📦 DMGファイル: DOI_Tool_v1.0.dmg"
fi
if [ -f "icons/DOI_Tool.icns" ]; then
    echo "  🎨 アイコンファイル: icons/DOI_Tool.icns"
fi

# 仮想環境の無効化
deactivate
