#!/bin/bash

# manual_icon_setup.sh - 手動アイコンセットアップガイド

echo "🎨 DOI Tool アプリアイコン 手動セットアップガイド"
echo "================================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICONS_DIR="$SCRIPT_DIR/icons"
ICONSET_DIR="$ICONS_DIR/DOI_Tool.iconset"

echo "📁 作業ディレクトリ: $SCRIPT_DIR"
echo "🎭 アイコンディレクトリ: $ICONS_DIR"
echo ""

# ディレクトリ作成
mkdir -p "$ICONSET_DIR"

echo "✅ SVGアイコンが作成されました: $ICONS_DIR/doi_tool_icon.svg"
echo ""
echo "🔧 次の手順でアイコンを作成してください:"
echo ""

# ツールの確認
if command -v rsvg-convert &> /dev/null; then
    echo "✅ rsvg-convert が利用可能です"
    echo ""
    echo "📋 自動変換を実行します..."
    
    # 必要なサイズとファイル名の定義
    declare -a icon_sizes=(
        "16:icon_16x16.png"
        "32:icon_16x16@2x.png" 
        "32:icon_32x32.png"
        "64:icon_32x32@2x.png"
        "128:icon_128x128.png"
        "256:icon_128x128@2x.png"
        "256:icon_256x256.png"
        "512:icon_256x256@2x.png"
        "512:icon_512x512.png"
        "1024:icon_512x512@2x.png"
    )
    
    # SVGからPNGファイルを生成
    for size_filename in "${icon_sizes[@]}"; do
        size="${size_filename%%:*}"
        filename="${size_filename##*:}"
        output_path="$ICONSET_DIR/$filename"
        
        rsvg-convert --width "$size" --height "$size" \
                     --output "$output_path" \
                     "$ICONS_DIR/doi_tool_icon.svg"
        
        if [ $? -eq 0 ]; then
            echo "✅ $filename (${size}x${size}) を作成しました"
        else
            echo "❌ $filename の作成に失敗しました"
        fi
    done
    
    # icnsファイルを作成
    echo ""
    echo "🔨 icnsファイルを作成中..."
    iconutil -c icns "$ICONSET_DIR" -o "$ICONS_DIR/DOI_Tool.icns"
    
    if [ $? -eq 0 ]; then
        echo "🎉 icnsファイルを作成しました: $ICONS_DIR/DOI_Tool.icns"
        echo ""
        echo "✅ アイコンセットアップが完了しました！"
        echo ""
        echo "🚀 次のステップ:"
        echo "  ./build_doi_tool_app.sh を実行してアプリをビルドしてください"
    else
        echo "❌ icnsファイルの作成に失敗しました"
    fi
    
elif command -v inkscape &> /dev/null; then
    echo "✅ Inkscape が利用可能です"
    echo ""
    echo "📋 自動変換を実行します..."
    
    # Inkscapeを使用した変換
    declare -a icon_sizes=(
        "16:icon_16x16.png"
        "32:icon_16x16@2x.png"
        "32:icon_32x32.png"
        "64:icon_32x32@2x.png"
        "128:icon_128x128.png"
        "256:icon_128x128@2x.png"
        "256:icon_256x256.png"
        "512:icon_256x256@2x.png"
        "512:icon_512x512.png"
        "1024:icon_512x512@2x.png"
    )
    
    for size_filename in "${icon_sizes[@]}"; do
        size="${size_filename%%:*}"
        filename="${size_filename##*:}"
        output_path="$ICONSET_DIR/$filename"
        
        inkscape --export-type=png \
                 --export-width="$size" \
                 --export-height="$size" \
                 --export-filename="$output_path" \
                 "$ICONS_DIR/doi_tool_icon.svg" > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo "✅ $filename (${size}x${size}) を作成しました"
        else
            echo "❌ $filename の作成に失敗しました"
        fi
    done
    
    # icnsファイルを作成
    echo ""
    echo "🔨 icnsファイルを作成中..."
    iconutil -c icns "$ICONSET_DIR" -o "$ICONS_DIR/DOI_Tool.icns"
    
    if [ $? -eq 0 ]; then
        echo "🎉 icnsファイルを作成しました: $ICONS_DIR/DOI_Tool.icns"
        echo ""
        echo "✅ アイコンセットアップが完了しました！"
        echo ""
        echo "🚀 次のステップ:"
        echo "  ./build_doi_tool_app.sh を実行してアプリをビルドしてください"
    else
        echo "❌ icnsファイルの作成に失敗しました"
    fi

else
    echo "⚠️  SVG→PNG変換ツールが見つかりません"
    echo ""
    echo "🔧 以下のいずれかをインストールしてください:"
    echo "  brew install librsvg  # rsvg-convert をインストール"
    echo "  brew install inkscape # Inkscape をインストール"
    echo ""
    echo "📱 または手動でアイコンを作成してください:"
    echo ""
    echo "1. SVGファイルをWebブラウザで開く:"
    echo "   open $ICONS_DIR/doi_tool_icon.svg"
    echo ""
    echo "2. ブラウザでSVGを右クリック→画像として保存"
    echo ""
    echo "3. Preview.app やオンラインツールで以下のサイズに変換:"
    echo "   📄 必要なファイル:"
    echo "     - icon_16x16.png (16×16)"
    echo "     - icon_16x16@2x.png (32×32)"
    echo "     - icon_32x32.png (32×32)"
    echo "     - icon_32x32@2x.png (64×64)"
    echo "     - icon_128x128.png (128×128)"
    echo "     - icon_128x128@2x.png (256×256)"
    echo "     - icon_256x256.png (256×256)"
    echo "     - icon_256x256@2x.png (512×512)"
    echo "     - icon_512x512.png (512×512)"
    echo "     - icon_512x512@2x.png (1024×1024)"
    echo ""
    echo "4. 全ファイルを以下に保存:"
    echo "   $ICONSET_DIR/"
    echo ""
    echo "5. icnsファイルを作成:"
    echo "   iconutil -c icns \"$ICONSET_DIR\" -o \"$ICONS_DIR/DOI_Tool.icns\""
    echo ""
    echo "💡 推奨オンラインツール:"
    echo "   - https://convertio.co/svg-png/"
    echo "   - https://www.iloveimg.com/resize-image"
    echo "   - Image2icon (Mac App Store)"
fi

echo ""
echo "📖 参考情報:"
echo "🎨 デザインコンセプト:"
echo "  - 📄 重なる論文: 複数のScopus論文を表現"
echo "  - 🔗 DOIテキスト: 明確な識別子を強調"
echo "  - ✨ 接続線とドット: 論文間のリンクと関係性を視覚化"
echo "  - 🌊 グラデーション背景: モダンで洗練された印象"
echo ""
echo "🔧 トラブルシューティング:"
echo "  - アイコンが表示されない場合は、icnsファイルの作成を確認"
echo "  - ビルドエラーが発生する場合は、setup.pyのiconfileパスを確認"
echo "  - macOSの権限エラーが発生する場合は、sudo権限でインストール"
