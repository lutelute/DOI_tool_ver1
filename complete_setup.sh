#!/bin/bash

echo "🚀 DOI Tool macOSアプリ 完全セットアップ"
echo "=========================================="

APP_PATH="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/standalone/DOI Tool.app"
EXECUTABLE="$APP_PATH/Contents/MacOS/DOI_Tool"
ICON_SOURCE="/Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1/app_build/icons/DOI_Tool.icns"
RESOURCES_DIR="$APP_PATH/Contents/Resources"

echo ""
echo "📋 セットアップ開始..."

# ステップ1: 実行権限設定
echo "🔧 1. 実行権限を設定中..."
chmod +x "$EXECUTABLE"
echo "   ✅ 実行権限設定完了"

# ステップ2: アイコン設定
echo "🎨 2. アイコンを設定中..."
if [ -f "$ICON_SOURCE" ]; then
    cp "$ICON_SOURCE" "$RESOURCES_DIR/"
    echo "   ✅ アイコンファイルコピー完了"
else
    echo "   ⚠️  アイコンファイルが見つかりません: $ICON_SOURCE"
fi

# ステップ3: Pythonスクリプトの確認
echo "🐍 3. Pythonスクリプトを確認中..."
required_scripts=("gui_main.py" "combine_scopus_csv.py" "scopus_doi_to_json.py" "json2tag_ref_scopus_async.py" "add_abst_scopus.py")

for script in "${required_scripts[@]}"; do
    if [ -f "$RESOURCES_DIR/$script" ]; then
        echo "   ✅ $script"
    else
        echo "   ❌ $script が見つかりません"
    fi
done

# ステップ4: Python依存関係チェック
echo "📦 4. Python依存関係をチェック中..."
python3 -c "
import sys
modules = ['tkinter', 'pandas', 'requests', 'tqdm']
missing = []
for module in modules:
    try:
        __import__(module)
        print(f'   ✅ {module}')
    except ImportError:
        print(f'   ❌ {module} - インストールが必要')
        missing.append(module)

if missing:
    print('')
    print('⚠️  不足しているモジュールをインストールするには:')
    print(f'   pip3 install {\" \".join(missing)}')
    sys.exit(1)
"

if [ $? -ne 0 ]; then
    echo ""
    echo "💡 必要なPythonパッケージをインストールしますか？ (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "📥 パッケージをインストール中..."
        pip3 install pandas requests requests_cache tqdm
        echo "   ✅ パッケージインストール完了"
    fi
fi

# ステップ5: アプリケーション情報表示
echo ""
echo "📱 5. アプリケーション情報:"
echo "   名前: DOI処理ツール"
echo "   場所: $APP_PATH"
echo "   バージョン: 1.0.0"
echo "   識別子: com.doitool.app"

# ステップ6: アプリケーションテスト
echo ""
echo "🧪 6. アプリケーションをテスト起動中..."

# アイコンキャッシュクリア（管理者権限が必要な場合はスキップ）
echo "🔄 アイコンキャッシュをクリア中..."
# sudo権限なしでできる範囲でクリア
touch "$APP_PATH"
killall Dock 2>/dev/null || true

echo ""
echo "🚀 アプリケーションを起動します..."
open "$APP_PATH"

echo ""
echo "✨ セットアップ完了！"
echo ""
echo "📋 使用方法:"
echo "   1. 起動したアプリで「作業ディレクトリ」を選択"
echo "   2. ScopusからエクスポートしたCSVファイルが含まれるフォルダを指定"
echo "   3. 「処理を開始」ボタンをクリック"
echo "   4. 処理完了後、md_folderにMarkdownファイルが生成されます"
echo ""
echo "🎯 アプリは以下の処理を自動実行します:"
echo "   • CSVファイルの統合"
echo "   • DOI情報の取得"
echo "   • 参考文献の解決"
echo "   • Markdownファイルの生成"
echo ""
echo "❓ 問題が発生した場合:"
echo "   • アプリが起動しない → ターミナルで直接実行: python3 '$RESOURCES_DIR/gui_main.py'"
echo "   • 処理エラー → CSVファイルの形式とネットワーク接続を確認"
echo ""
