#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
create_app_icon.py - DOI Tool アプリアイコン作成スクリプト
"""

import os
import subprocess
from pathlib import Path
try:
    from PIL import Image, ImageDraw, ImageFont
    PIL_AVAILABLE = True
except ImportError:
    PIL_AVAILABLE = False

def create_doi_icon_svg():
    """SVGベースのDOIアイコンを作成"""
    svg_content = '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="512" height="512" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#4facfe;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#00f2fe;stop-opacity:1" />
    </linearGradient>
    <filter id="shadow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="4" stdDeviation="8" flood-color="rgba(0,0,0,0.3)"/>
    </filter>
    <filter id="glow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="0" stdDeviation="4" flood-color="#ff6b6b"/>
    </filter>
  </defs>
  
  <!-- 背景 -->
  <rect width="512" height="512" rx="120" fill="url(#bgGradient)"/>
  
  <!-- ペーパースタック -->
  <g transform="translate(80, 120)" filter="url(#shadow)">
    <!-- 後ろの紙 -->
    <rect x="0" y="0" width="180" height="240" rx="8" fill="#f8f9fa" 
          transform="rotate(-8 90 120)"/>
    <!-- 中間の紙 -->
    <rect x="20" y="-10" width="180" height="240" rx="8" fill="#ffffff" 
          transform="rotate(3 110 110)"/>
    <!-- 前の紙 -->
    <rect x="40" y="-5" width="180" height="240" rx="8" fill="#ffffff" 
          transform="rotate(-2 130 115)"/>
    
    <!-- 論文の線（テキストを表現） -->
    <g fill="#e9ecef">
      <rect x="60" y="30" width="140" height="3" rx="1"/>
      <rect x="60" y="45" width="120" height="3" rx="1"/>
      <rect x="60" y="60" width="160" height="3" rx="1"/>
      <rect x="60" y="75" width="100" height="3" rx="1"/>
      <rect x="60" y="105" width="150" height="3" rx="1"/>
      <rect x="60" y="120" width="110" height="3" rx="1"/>
      <rect x="60" y="135" width="140" height="3" rx="1"/>
    </g>
  </g>
  
  <!-- DOIテキスト -->
  <g transform="translate(290, 180)" filter="url(#shadow)">
    <rect x="0" y="0" width="120" height="80" rx="15" fill="#2c3e50"/>
    <text x="60" y="55" font-family="SF Mono, Monaco, Consolas, monospace" 
          font-size="36" font-weight="bold" fill="white" 
          text-anchor="middle" letter-spacing="2px">DOI</text>
  </g>
  
  <!-- 接続線 -->
  <g filter="url(#glow)">
    <path d="M 260 240 Q 320 200 370 220" stroke="#ff6b6b" stroke-width="8" 
          fill="none" stroke-dasharray="15,10" opacity="0.8">
      <animate attributeName="opacity" values="0.5;1;0.5" dur="2s" repeatCount="indefinite"/>
    </path>
    
    <!-- 接続ドット -->
    <circle cx="260" cy="240" r="12" fill="#ff6b6b">
      <animate attributeName="r" values="10;14;10" dur="2s" repeatCount="indefinite"/>
    </circle>
    <circle cx="320" cy="200" r="10" fill="#ff6b6b">
      <animate attributeName="r" values="8;12;8" dur="2s" begin="0.5s" repeatCount="indefinite"/>
    </circle>
    <circle cx="370" cy="220" r="12" fill="#ff6b6b">
      <animate attributeName="r" values="10;14;10" dur="2s" begin="1s" repeatCount="indefinite"/>
    </circle>
  </g>
  
  <!-- 光の効果 -->
  <circle cx="140" cy="140" r="3" fill="white" opacity="0.6">
    <animate attributeName="opacity" values="0.3;0.8;0.3" dur="3s" repeatCount="indefinite"/>
  </circle>
  <circle cx="350" cy="100" r="2" fill="white" opacity="0.4">
    <animate attributeName="opacity" values="0.2;0.6;0.2" dur="4s" begin="1s" repeatCount="indefinite"/>
  </circle>
</svg>'''
    return svg_content

def create_icns_file(base_dir):
    """macOS用のicnsファイルを作成"""
    icons_dir = base_dir / "icons"
    iconset_dir = icons_dir / "DOI_Tool.iconset"
    iconset_dir.mkdir(exist_ok=True)
    
    # SVGファイルを保存
    svg_path = icons_dir / "doi_tool_icon.svg"
    with open(svg_path, 'w', encoding='utf-8') as f:
        f.write(create_doi_icon_svg())
    
    print(f"✅ SVGアイコンを作成しました: {svg_path}")
    
    # 必要なサイズとファイル名の定義
    icon_sizes = [
        (16, "icon_16x16.png"),
        (32, "icon_16x16@2x.png"),
        (32, "icon_32x32.png"),
        (64, "icon_32x32@2x.png"),
        (128, "icon_128x128.png"),
        (256, "icon_128x128@2x.png"),
        (256, "icon_256x256.png"),
        (512, "icon_256x256@2x.png"),
        (512, "icon_512x512.png"),
        (1024, "icon_512x512@2x.png"),
    ]
    
    # Inkscapeやrsvg-convertを使ってSVGからPNGを生成
    svg_to_png_available = False
    
    # rsvg-convertの確認
    try:
        subprocess.run(['rsvg-convert', '--version'], 
                      capture_output=True, check=True)
        svg_to_png_available = 'rsvg-convert'
        print("✅ rsvg-convert が利用可能です")
    except (subprocess.CalledProcessError, FileNotFoundError):
        pass
    
    # Inkscapeの確認
    if not svg_to_png_available:
        try:
            subprocess.run(['inkscape', '--version'], 
                          capture_output=True, check=True)
            svg_to_png_available = 'inkscape'
            print("✅ Inkscape が利用可能です")
        except (subprocess.CalledProcessError, FileNotFoundError):
            pass
    
    if svg_to_png_available:
        # SVGからPNGファイルを生成
        for size, filename in icon_sizes:
            output_path = iconset_dir / filename
            
            if svg_to_png_available == 'rsvg-convert':
                cmd = [
                    'rsvg-convert',
                    '--width', str(size),
                    '--height', str(size),
                    '--output', str(output_path),
                    str(svg_path)
                ]
            else:  # inkscape
                cmd = [
                    'inkscape',
                    '--export-type=png',
                    f'--export-width={size}',
                    f'--export-height={size}',
                    f'--export-filename={output_path}',
                    str(svg_path)
                ]
            
            try:
                subprocess.run(cmd, check=True, capture_output=True)
                print(f"✅ {filename} ({size}x{size}) を作成しました")
            except subprocess.CalledProcessError as e:
                print(f"❌ {filename} の作成に失敗: {e}")
    
        # icnsファイルを作成
        icns_path = icons_dir / "DOI_Tool.icns"
        try:
            subprocess.run([
                'iconutil', '-c', 'icns', str(iconset_dir),
                '-o', str(icns_path)
            ], check=True)
            print(f"🎉 icnsファイルを作成しました: {icns_path}")
            return icns_path
        except subprocess.CalledProcessError as e:
            print(f"❌ icnsファイルの作成に失敗: {e}")
    
    else:
        print("⚠️  SVG→PNG変換ツールが見つかりません")
        print("以下のいずれかをインストールしてください:")
        print("  brew install librsvg  # rsvg-convert")
        print("  brew install inkscape # Inkscape")
        print("\n💡 手動でSVGからPNGファイルを作成してください:")
        print(f"   SVGファイル: {svg_path}")
        print(f"   保存先: {iconset_dir}")
    
    return None

def update_setup_py(base_dir, icns_path=None):
    """setup.pyファイルを更新してアイコンを追加"""
    setup_py_path = base_dir / "setup.py"
    
    if not setup_py_path.exists():
        print(f"❌ setup.py が見つかりません: {setup_py_path}")
        return
    
    # setup.pyの内容を読み込み
    with open(setup_py_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # iconfileパラメータを更新
    if icns_path and icns_path.exists():
        # 相対パスでicnsファイルを指定
        relative_icns = os.path.relpath(icns_path, base_dir)
        
        if "'iconfile': None," in content:
            content = content.replace(
                "'iconfile': None,",
                f"'iconfile': '{relative_icns}',"
            )
        elif "'iconfile':" not in content and "'resources': []," in content:
            content = content.replace(
                "'resources': [],",
                f"'resources': [],\n        'iconfile': '{relative_icns}',"
            )
        
        print(f"✅ setup.py を更新しました（アイコン: {relative_icns}）")
    else:
        print("⚠️  icnsファイルが見つからないため、setup.pyは更新されませんでした")
    
    # CFBundleDisplayNameも更新
    if "'CFBundleDisplayName': 'DOI処理ツール'," not in content:
        content = content.replace(
            "'CFBundleName': 'DOI Tool',",
            "'CFBundleName': 'DOI Tool',\n        'CFBundleDisplayName': 'DOI処理ツール',"
        )
    
    # 更新された内容を保存
    with open(setup_py_path, 'w', encoding='utf-8') as f:
        f.write(content)

def create_app_build_script(base_dir):
    """アプリビルドスクリプトを作成"""
    script_content = '''#!/bin/bash
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
'''
    
    script_path = base_dir / "build_doi_tool_app.sh"
    with open(script_path, 'w', encoding='utf-8') as f:
        f.write(script_content)
    
    # 実行権限を付与
    script_path.chmod(0o755)
    print(f"✅ ビルドスクリプトを作成しました: {script_path}")

def main():
    """メイン関数"""
    print("🎨 DOI Tool アプリアイコン作成ツール")
    print("=" * 50)
    
    # ベースディレクトリを取得
    base_dir = Path(__file__).parent
    print(f"📁 作業ディレクトリ: {base_dir}")
    
    # アイコンディレクトリを作成
    icons_dir = base_dir / "icons"
    icons_dir.mkdir(exist_ok=True)
    
    try:
        # icnsファイルを作成
        icns_path = create_icns_file(base_dir)
        
        # setup.pyを更新
        update_setup_py(base_dir, icns_path)
        
        # ビルドスクリプトを作成
        create_app_build_script(base_dir)
        
        print("\n🎉 アイコン設定が完了しました！")
        print("\n📋 次のステップ:")
        print("1. ./build_doi_tool_app.sh を実行してアプリをビルド")
        print("2. または手動で python3 setup.py py2app を実行")
        print("3. dist/DOI Tool.app が生成されます")
        
        if icns_path and icns_path.exists():
            print(f"\n✅ アイコンファイル: {icns_path}")
        else:
            print("\n⚠️  アイコンファイルの作成に問題があります")
            print("手動でSVGファイルからPNGファイルを作成してください")
        
    except Exception as e:
        print(f"\n❌ エラーが発生しました: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    exit(main())
