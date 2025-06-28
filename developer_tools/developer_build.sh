#!/bin/bash

# developer_build.sh - 開発者向けアプリビルドスクリプト

echo "🛠️  DOI Tool 開発者向けビルドシステム"
echo "======================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
APP_BUILD_DIR="$PROJECT_ROOT/app_build"

cd "$SCRIPT_DIR"

echo "📁 プロジェクトルート: $PROJECT_ROOT"
echo "🔧 開発ツールディレクトリ: $SCRIPT_DIR"
echo ""

# 開発環境チェック
echo "📋 開発環境チェック..."
python3 --version || { echo "❌ Python3が必要です"; exit 1; }

# 必要な開発ツールの確認
missing_tools=()

if ! command -v brew &> /dev/null; then
    missing_tools+=("Homebrew")
fi

if ! command -v rsvg-convert &> /dev/null && ! command -v inkscape &> /dev/null; then
    missing_tools+=("SVG変換ツール (librsvg または inkscape)")
fi

if ! command -v iconutil &> /dev/null; then
    missing_tools+=("iconutil (Xcode Command Line Tools)")
fi

if [ ${#missing_tools[@]} -ne 0 ]; then
    echo "❌ 以下の開発ツールが不足しています:"
    for tool in "${missing_tools[@]}"; do
        echo "  - $tool"
    done
    echo ""
    echo "🔧 インストールコマンド:"
    echo "  brew install librsvg  # SVG変換用"
    echo "  xcode-select --install  # Xcode Command Line Tools"
    exit 1
fi

echo "✅ 開発環境OK"

# 仮想環境の設定
echo ""
echo "🐍 開発用仮想環境の設定..."
if [ ! -d "dev_venv" ]; then
    python3 -m venv dev_venv
    echo "✅ 開発用仮想環境を作成しました"
fi

source dev_venv/bin/activate
pip install --upgrade pip setuptools wheel py2app

echo "✅ 開発依存関係インストール完了"

# アイコン作成
echo ""
echo "🎨 美しいDOI Toolアイコン生成..."
python3 beautiful_doi_icon_generator.py

if [ -f "generated_assets/DOI_Tool.icns" ]; then
    echo "✅ アイコンファイル生成完了"
    
    # app_buildディレクトリにアイコンをコピー
    mkdir -p "$APP_BUILD_DIR/icons"
    cp generated_assets/DOI_Tool.icns "$APP_BUILD_DIR/icons/"
    cp generated_assets/doi_tool_icon.svg "$APP_BUILD_DIR/icons/"
    echo "✅ アイコンファイルをapp_buildにコピーしました"
else
    echo "❌ アイコンファイル生成に失敗しました"
    exit 1
fi

# アプリケーションビルド
echo ""
echo "🔨 アプリケーションビルド..."
cd "$APP_BUILD_DIR"

# app_build用の仮想環境も設定
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

source .venv/bin/activate
pip install --upgrade pip setuptools wheel py2app
pip install -r requirements.txt

# 古いビルドを削除
rm -rf build/ dist/ *.app

# アプリビルド実行
python3 setup.py py2app --arch=universal2

if [ $? -eq 0 ]; then
    echo "✅ アプリビルド成功"
    
    # アプリ名変更
    if [ -d "dist/gui_main.app" ]; then
        mv "dist/gui_main.app" "dist/DOI Tool.app"
        echo "✅ アプリ名を変更しました"
    fi
    
    # ユーザー配布用ディレクトリに成果物をコピー
    USER_DIST="$PROJECT_ROOT/user_distribution"
    mkdir -p "$USER_DIST"
    
    if [ -d "dist/DOI Tool.app" ]; then
        echo ""
        echo "📦 ユーザー配布ファイルを準備中..."
        
        # アプリをコピー
        cp -R "dist/DOI Tool.app" "$USER_DIST/"
        
        # DMGファイル作成
        cd "$USER_DIST"
        hdiutil create -volname "DOI Tool" \
                       -srcfolder "DOI Tool.app" \
                       -ov -format UDZO \
                       "DOI_Tool_v1.0.dmg"
        
        if [ $? -eq 0 ]; then
            echo "✅ DMGファイルを作成しました"
        fi
        
        # 簡単インストールスクリプトを作成
        cat > install_doi_tool.sh << 'EOF'
#!/bin/bash

echo "🔬 DOI Tool インストーラー"
echo "========================"

# アプリの存在確認
if [ ! -d "DOI Tool.app" ]; then
    echo "❌ DOI Tool.app が見つかりません"
    echo "DMGファイルをマウントしてからこのスクリプトを実行してください"
    exit 1
fi

echo "📱 DOI Tool.app を /Applications にインストールします"

# 既存アプリの確認
if [ -d "/Applications/DOI Tool.app" ]; then
    echo "⚠️  既存のDOI Tool.appが見つかりました"
    echo "上書きしますか？ (y/n)"
    read -r overwrite
    if [[ "$overwrite" != [Yy]* ]]; then
        echo "インストールをキャンセルしました"
        exit 0
    fi
    echo "既存アプリを削除中..."
    sudo rm -rf "/Applications/DOI Tool.app"
fi

# インストール実行
echo "インストール中..."
sudo cp -R "DOI Tool.app" "/Applications/"

if [ $? -eq 0 ]; then
    echo "🎉 DOI Tool のインストールが完了しました！"
    echo ""
    echo "🚀 起動方法:"
    echo "  - Launchpadから 'DOI Tool' を検索"
    echo "  - Finder → アプリケーション → DOI Tool"
    echo ""
    echo "今すぐ起動しますか？ (y/n)"
    read -r launch
    if [[ "$launch" == [Yy]* ]]; then
        open "/Applications/DOI Tool.app"
    fi
else
    echo "❌ インストールに失敗しました"
    echo "管理者権限が必要です"
fi
EOF
        
        chmod +x install_doi_tool.sh
        echo "✅ インストールスクリプトを作成しました"
        
        # README作成
        cat > README_USER.md << 'EOF'
# 🔬 DOI Tool - ユーザー向けインストールガイド

ScopusのCSVファイルからMarkdownファイルを生成するmacOSアプリケーション

## 📦 インストール方法

### 方法1: DMGファイルから（推奨）
1. `DOI_Tool_v1.0.dmg` をダブルクリック
2. マウントされたディスクイメージから `DOI Tool.app` を Applications フォルダにドラッグ
3. Launchpad から「DOI Tool」を起動

### 方法2: インストールスクリプト使用
1. `DOI_Tool_v1.0.dmg` をダブルクリック
2. マウントされたディスクから `install_doi_tool.sh` を実行
3. 画面の指示に従ってインストール

## 🚀 使用方法

1. **DOI Tool** を起動
2. **作業ディレクトリ** を選択（ScopusのCSVファイルがあるフォルダ）
3. **ファイル一覧を更新** でCSVファイルを確認
4. **処理を開始** ボタンをクリック
5. 完了後、`md_folder` にMarkdownファイルが生成されます

## 📋 必要な環境

- macOS 10.14以降
- インターネット接続（DOI解決のため）

## 🆘 トラブルシューティング

### アプリが起動しない場合
1. システム設定 → プライバシーとセキュリティ
2. 「DOI Tool」の実行を許可

### セキュリティ警告が出る場合
```bash
sudo xattr -dr com.apple.quarantine "/Applications/DOI Tool.app"
```

## 📞 サポート

問題が発生した場合は、エラーメッセージと共にお問い合わせください。
EOF
        
        echo "✅ ユーザー向けREADMEを作成しました"
        
        # 配布ファイル一覧
        echo ""
        echo "📋 ユーザー配布ファイル（user_distribution/）:"
        ls -la "$USER_DIST"
        
        echo ""
        echo "🎉 開発ビルド完了！"
        echo ""
        echo "📦 配布準備:"
        echo "  - user_distribution/ フォルダの内容をユーザーに配布"
        echo "  - DMGファイルまたはアプリファイル + インストールスクリプト"
        
    else
        echo "❌ ビルドされたアプリが見つかりません"
        exit 1
    fi
    
else
    echo "❌ アプリビルドに失敗しました"
    exit 1
fi

# 開発環境のクリーンアップ
deactivate
cd "$SCRIPT_DIR"
deactivate

echo ""
echo "✨ 開発ビルドプロセス完了！"
