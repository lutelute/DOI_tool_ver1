#!/bin/bash

# quick_new_icon.sh - 新しいネットワークアイコンをすぐに生成

echo "🌟 洗練されたネットワーク型DOI Toolアイコン - クイック生成"
echo "=========================================================="

# 現在のディレクトリ確認
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "📁 作業ディレクトリ: $SCRIPT_DIR"

# SVG変換ツールの確認
echo ""
echo "🔧 必要ツールの確認..."

if ! command -v rsvg-convert &> /dev/null && ! command -v inkscape &> /dev/null; then
    echo "❌ SVG変換ツールが見つかりません"
    echo ""
    echo "インストールしますか？ (y/n)"
    read -r install_tools
    
    if [[ "$install_tools" =~ ^[Yy]$ ]]; then
        echo "📦 rsvg-convert をインストール中..."
        brew install librsvg
        
        if [ $? -eq 0 ]; then
            echo "✅ rsvg-convert インストール完了"
        else
            echo "❌ インストールに失敗しました"
            echo "手動でインストールしてください: brew install librsvg"
            exit 1
        fi
    else
        echo "❌ SVG変換ツールが必要です"
        exit 1
    fi
else
    echo "✅ SVG変換ツールが利用可能です"
fi

# アイコン生成実行
echo ""
echo "🎨 洗練されたネットワーク型アイコンを生成中..."
echo ""

python3 refined_network_icon_generator.py

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 アイコン生成完了！"
    echo ""
    
    # 生成ファイルの確認
    if [ -f "generated_assets/DOI_Tool.icns" ]; then
        echo "📊 生成されたファイル:"
        ls -la generated_assets/
        echo ""
        
        # app_buildにコピー
        echo "📋 app_buildディレクトリにアイコンをコピー中..."
        APP_BUILD_DIR="../app_build"
        
        if [ -d "$APP_BUILD_DIR" ]; then
            mkdir -p "$APP_BUILD_DIR/icons"
            cp generated_assets/DOI_Tool.icns "$APP_BUILD_DIR/icons/"
            cp generated_assets/doi_tool_icon.svg "$APP_BUILD_DIR/icons/"
            echo "✅ アイコンファイルをapp_buildにコピーしました"
            
            # プレビュー表示
            echo ""
            echo "🖼️  アイコンをプレビューしますか？ (y/n)"
            read -r preview_choice
            
            if [[ "$preview_choice" =~ ^[Yy]$ ]]; then
                if command -v qlmanage &> /dev/null; then
                    echo "📱 Quick Look でプレビュー中..."
                    qlmanage -p generated_assets/doi_tool_icon.svg > /dev/null 2>&1
                else
                    echo "🌐 ブラウザでSVGを開きます..."
                    open generated_assets/doi_tool_icon.svg
                fi
            fi
            
            # アプリビルドの提案
            echo ""
            echo "🚀 次のステップ:"
            echo "1. 今すぐアプリをビルド: cd ../developer_tools && ./developer_build.sh"
            echo "2. または手動ビルド: cd ../app_build && python3 setup.py py2app"
            echo ""
            echo "新しいアイコンでアプリをビルドしますか？ (y/n)"
            read -r build_choice
            
            if [[ "$build_choice" =~ ^[Yy]$ ]]; then
                echo "🔨 アプリケーションビルドを開始..."
                cd ../developer_tools
                ./developer_build.sh
            fi
            
        else
            echo "⚠️  app_buildディレクトリが見つかりません"
            echo "手動でアイコンファイルをコピーしてください"
        fi
        
    else
        echo "❌ icnsファイルが生成されませんでした"
    fi
    
else
    echo ""
    echo "❌ アイコン生成に失敗しました"
    echo "エラーログを確認してください"
fi

echo ""
echo "✨ アイコン生成プロセス完了"
