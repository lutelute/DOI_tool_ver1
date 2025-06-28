#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
beautiful_doi_icon_generator.py - 美しいDOI Toolアイコン生成（最終版）
"""

import os
import subprocess
from pathlib import Path

def create_beautiful_doi_svg():
    """美しいDOI Tool SVGアイコンを作成"""
    return '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="512" height="512" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <!-- メイングラデーション -->
    <linearGradient id="mainGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#667eea;stop-opacity:1" />
      <stop offset="40%" style="stop-color:#764ba2;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#f093fb;stop-opacity:1" />
    </linearGradient>
    
    <!-- ペーパーグラデーション -->
    <linearGradient id="paperGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#f8fafc;stop-opacity:1" />
    </linearGradient>
    
    <!-- DOIボックスグラデーション -->
    <linearGradient id="doiGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:0.95" />
      <stop offset="100%" style="stop-color:#f8fafc;stop-opacity:0.95" />
    </linearGradient>
    
    <!-- 中央ハブグラデーション -->
    <linearGradient id="hubGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#4ecdc4;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#44d9e8;stop-opacity:1" />
    </linearGradient>
    
    <!-- 接続線グラデーション -->
    <linearGradient id="lineGradient" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:0.6" />
      <stop offset="100%" style="stop-color:#4ecdc4;stop-opacity:0.4" />
    </linearGradient>
    
    <!-- フィルター -->
    <filter id="paperShadow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="6" stdDeviation="12" flood-color="rgba(0,0,0,0.15)"/>
      <feDropShadow dx="0" dy="2" stdDeviation="4" flood-color="rgba(0,0,0,0.1)"/>
    </filter>
    
    <filter id="softShadow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="8" stdDeviation="15" flood-color="rgba(0,0,0,0.2)"/>
    </filter>
    
    <filter id="hubGlow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="0" stdDeviation="12" flood-color="rgba(78,205,196,0.8)"/>
      <feDropShadow dx="0" dy="0" stdDeviation="25" flood-color="rgba(78,205,196,0.4)"/>
    </filter>
    
    <filter id="nodeGlow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="0" stdDeviation="8" flood-color="rgba(255,255,255,0.8)"/>
      <feDropShadow dx="0" dy="2" stdDeviation="4" flood-color="rgba(0,0,0,0.1)"/>
    </filter>
  </defs>
  
  <!-- 背景 -->
  <rect width="512" height="512" rx="115" fill="url(#mainGradient)"/>
  <rect width="512" height="512" rx="115" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="2"/>
  
  <!-- 論文スタック -->
  <g transform="translate(64, 64)">
    <!-- 論文1 -->
    <g transform="translate(38, 12) rotate(-12)" filter="url(#paperShadow)">
      <rect x="0" y="0" width="84" height="108" rx="15" fill="url(#paperGradient)" 
            stroke="rgba(255,255,255,0.8)" stroke-width="1"/>
      <!-- タイトルバー -->
      <rect x="10" y="15" width="54" height="4" rx="2" fill="#3498db"/>
      <rect x="10" y="21" width="40" height="4" rx="2" fill="#2ecc71"/>
      <!-- テキストライン -->
      <rect x="10" y="34" width="64" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="40" width="48" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="46" width="58" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="52" width="45" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="58" width="52" height="2.5" rx="1" fill="#e2e8f0"/>
    </g>
    
    <!-- 論文2 -->
    <g transform="translate(96, 0) rotate(8)" filter="url(#paperShadow)">
      <rect x="0" y="0" width="90" height="114" rx="15" fill="url(#paperGradient)" 
            stroke="rgba(255,255,255,0.8)" stroke-width="1"/>
      <!-- タイトルバー -->
      <rect x="10" y="15" width="58" height="4" rx="2" fill="#e74c3c"/>
      <rect x="10" y="21" width="44" height="4" rx="2" fill="#f39c12"/>
      <!-- テキストライン -->
      <rect x="10" y="34" width="70" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="40" width="52" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="46" width="62" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="52" width="48" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="58" width="55" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="64" width="42" height="2.5" rx="1" fill="#e2e8f0"/>
    </g>
    
    <!-- 論文3 -->
    <g transform="translate(170, 30) rotate(-5)" filter="url(#paperShadow)">
      <rect x="0" y="0" width="82" height="106" rx="15" fill="url(#paperGradient)" 
            stroke="rgba(255,255,255,0.8)" stroke-width="1"/>
      <!-- タイトルバー -->
      <rect x="10" y="15" width="52" height="4" rx="2" fill="#9b59b6"/>
      <rect x="10" y="21" width="38" height="4" rx="2" fill="#8e44ad"/>
      <!-- テキストライン -->
      <rect x="10" y="34" width="62" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="40" width="46" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="46" width="56" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="52" width="43" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="58" width="50" height="2.5" rx="1" fill="#e2e8f0"/>
    </g>
    
    <!-- 論文4 -->
    <g transform="translate(280, 18) rotate(15)" filter="url(#paperShadow)">
      <rect x="0" y="0" width="86" height="110" rx="15" fill="url(#paperGradient)" 
            stroke="rgba(255,255,255,0.8)" stroke-width="1"/>
      <!-- タイトルバー -->
      <rect x="10" y="15" width="56" height="4" rx="2" fill="#1abc9c"/>
      <rect x="10" y="21" width="42" height="4" rx="2" fill="#16a085"/>
      <!-- テキストライン -->
      <rect x="10" y="34" width="66" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="40" width="50" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="46" width="60" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="52" width="47" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="58" width="53" height="2.5" rx="1" fill="#e2e8f0"/>
      <rect x="10" y="64" width="40" height="2.5" rx="1" fill="#e2e8f0"/>
    </g>
  </g>
  
  <!-- ネットワーク層 -->
  <g transform="translate(76, 230)">
    <!-- 接続線（中央ハブから各ノードへ） -->
    <line x1="180" y1="50" x2="180" y2="10" stroke="url(#lineGradient)" stroke-width="4" stroke-linecap="round"/>
    <line x1="180" y1="50" x2="220" y2="25" stroke="url(#lineGradient)" stroke-width="4" stroke-linecap="round"/>
    <line x1="180" y1="50" x2="235" y2="60" stroke="url(#lineGradient)" stroke-width="4" stroke-linecap="round"/>
    <line x1="180" y1="50" x2="215" y2="85" stroke="url(#lineGradient)" stroke-width="4" stroke-linecap="round"/>
    <line x1="180" y1="50" x2="180" y2="90" stroke="url(#lineGradient)" stroke-width="4" stroke-linecap="round"/>
    <line x1="180" y1="50" x2="145" y2="85" stroke="url(#lineGradient)" stroke-width="4" stroke-linecap="round"/>
    <line x1="180" y1="50" x2="125" y2="60" stroke="url(#lineGradient)" stroke-width="4" stroke-linecap="round"/>
    <line x1="180" y1="50" x2="140" y2="25" stroke="url(#lineGradient)" stroke-width="4" stroke-linecap="round"/>
    
    <!-- 外周ノード -->
    <circle cx="180" cy="10" r="8" fill="url(#paperGradient)" filter="url(#nodeGlow)"/>
    <circle cx="220" cy="25" r="8" fill="url(#paperGradient)" filter="url(#nodeGlow)"/>
    <circle cx="235" cy="60" r="8" fill="url(#paperGradient)" filter="url(#nodeGlow)"/>
    <circle cx="215" cy="85" r="8" fill="url(#paperGradient)" filter="url(#nodeGlow)"/>
    <circle cx="180" cy="90" r="8" fill="url(#paperGradient)" filter="url(#nodeGlow)"/>
    <circle cx="145" cy="85" r="8" fill="url(#paperGradient)" filter="url(#nodeGlow)"/>
    <circle cx="125" cy="60" r="8" fill="url(#paperGradient)" filter="url(#nodeGlow)"/>
    <circle cx="140" cy="25" r="8" fill="url(#paperGradient)" filter="url(#nodeGlow)"/>
    
    <!-- 中央メインハブ -->
    <circle cx="180" cy="50" r="14" fill="url(#hubGradient)" filter="url(#hubGlow)"/>
    <circle cx="180" cy="50" r="10" fill="rgba(255,255,255,0.3)"/>
    <circle cx="180" cy="50" r="6" fill="url(#hubGradient)"/>
  </g>
  
  <!-- DOIボックス -->
  <g transform="translate(186, 420)" filter="url(#softShadow)">
    <rect x="0" y="0" width="140" height="60" rx="30" fill="url(#doiGradient)"
          stroke="rgba(255,255,255,0.3)" stroke-width="1"/>
    <rect x="2" y="2" width="136" height="56" rx="28" fill="none" 
          stroke="rgba(255,255,255,0.8)" stroke-width="1"/>
    <!-- DOIテキスト -->
    <text x="70" y="42" font-family="SF Mono, Monaco, Menlo, Consolas, monospace" 
          font-size="24" font-weight="800" fill="#2c3e50" 
          text-anchor="middle" letter-spacing="3px">DOI</text>
  </g>
  
  <!-- 装飾的な光点 -->
  <circle cx="120" cy="120" r="3" fill="rgba(255,255,255,0.8)" opacity="0.6"/>
  <circle cx="380" cy="100" r="2.5" fill="rgba(255,255,255,0.8)" opacity="0.5"/>
  <circle cx="90" cy="380" r="3.5" fill="rgba(255,255,255,0.8)" opacity="0.7"/>
  <circle cx="420" cy="380" r="2" fill="rgba(255,255,255,0.8)" opacity="0.4"/>
</svg>'''

def generate_beautiful_icon():
    """美しいDOI Toolアイコンを生成"""
    print("✨ 美しいDOI Tool アイコン生成開始")
    print("=" * 50)
    
    # 出力ディレクトリ作成
    base_dir = Path(__file__).parent
    assets_dir = base_dir / "generated_assets"
    iconset_dir = assets_dir / "DOI_Tool.iconset"
    
    assets_dir.mkdir(exist_ok=True)
    iconset_dir.mkdir(exist_ok=True)
    
    # SVGファイル作成
    svg_path = assets_dir / "doi_tool_icon.svg"
    with open(svg_path, 'w', encoding='utf-8') as f:
        f.write(create_beautiful_doi_svg())
    
    print(f"✅ 美しいSVGアイコン作成完了: {svg_path}")
    
    # 必要なアイコンサイズ
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
    
    # SVG変換ツールの確認
    svg_tool = None
    if subprocess.run(['which', 'rsvg-convert'], capture_output=True).returncode == 0:
        svg_tool = 'rsvg-convert'
        print("✅ rsvg-convert を使用してPNG生成します")
    elif subprocess.run(['which', 'inkscape'], capture_output=True).returncode == 0:
        svg_tool = 'inkscape'
        print("✅ Inkscape を使用してPNG生成します")
    else:
        print("❌ SVG変換ツールが見つかりません")
        print("以下のコマンドでインストールしてください:")
        print("  brew install librsvg")
        return False
    
    # PNGファイル生成
    print("\n🎨 各サイズのPNGファイルを生成中...")
    success_count = 0
    
    for size, filename in icon_sizes:
        output_path = iconset_dir / filename
        
        try:
            if svg_tool == 'rsvg-convert':
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
            
            result = subprocess.run(cmd, capture_output=True, text=True)
            if result.returncode == 0:
                print(f"  ✅ {filename} ({size}x{size})")
                success_count += 1
            else:
                print(f"  ❌ {filename} 失敗")
        
        except Exception as e:
            print(f"  ❌ {filename} エラー: {e}")
    
    print(f"\n📊 PNG生成結果: {success_count}/{len(icon_sizes)} 成功")
    
    # icnsファイル生成
    if success_count == len(icon_sizes):
        print("\n🔨 macOS用icnsファイル作成中...")
        icns_path = assets_dir / "DOI_Tool.icns"
        
        try:
            result = subprocess.run([
                'iconutil', '-c', 'icns', str(iconset_dir),
                '-o', str(icns_path)
            ], capture_output=True, text=True)
            
            if result.returncode == 0:
                icns_size = icns_path.stat().st_size
                print(f"🎉 icnsファイル作成完了!")
                print(f"   📁 場所: {icns_path}")
                print(f"   📏 サイズ: {icns_size / 1024:.1f} KB")
                
                return icns_path
            else:
                print(f"❌ icnsファイル作成失敗: {result.stderr}")
                return None
                
        except Exception as e:
            print(f"❌ icnsファイル作成エラー: {e}")
            return None
    else:
        print("❌ PNGファイル生成が不完全なため、icnsファイルを作成できません")
        return None

def copy_to_app_build(assets_dir):
    """生成されたアセットをapp_buildディレクトリにコピー"""
    print("\n📦 app_buildディレクトリにアイコンをコピー中...")
    
    app_build_dir = assets_dir.parent.parent / "app_build"
    app_icons_dir = app_build_dir / "icons"
    
    if not app_build_dir.exists():
        print(f"❌ app_buildディレクトリが見つかりません: {app_build_dir}")
        return False
    
    # iconsディレクトリ作成
    app_icons_dir.mkdir(exist_ok=True)
    
    # ファイルをコピー
    import shutil
    
    # icnsファイル
    icns_src = assets_dir / "DOI_Tool.icns"
    if icns_src.exists():
        shutil.copy2(icns_src, app_icons_dir / "DOI_Tool.icns")
        print(f"  ✅ DOI_Tool.icns → {app_icons_dir}")
    
    # SVGファイル
    svg_src = assets_dir / "doi_tool_icon.svg"
    if svg_src.exists():
        shutil.copy2(svg_src, app_icons_dir / "doi_tool_icon.svg")
        print(f"  ✅ doi_tool_icon.svg → {app_icons_dir}")
    
    print("✅ アイコンファイルのコピー完了")
    return True

def main():
    """メイン関数"""
    print("🎨 美しいDOI Toolアイコン生成ツール")
    print("=" * 60)
    
    # アイコン生成
    icns_path = generate_beautiful_icon()
    
    if icns_path:
        # app_buildにコピー
        assets_dir = icns_path.parent
        copy_success = copy_to_app_build(assets_dir)
        
        print("\n🎉 美しいアイコン生成完了!")
        print("\n🎨 生成されたアイコンの特徴:")
        print("  📄 4つの美しく重なる論文カード")
        print("  🌟 中央ハブからの8つの放射状接続")
        print("  ✨ 洗練されたグラデーションとシャドウ")
        print("  💎 ガラスモーフィズムDOIボックス")
        print("  🌈 魔法のような装飾光点")
        
        print("\n📁 生成されたファイル:")
        for file_path in assets_dir.rglob("*"):
            if file_path.is_file():
                size = file_path.stat().st_size
                print(f"  📄 {file_path.name} ({size / 1024:.1f} KB)")
        
        print(f"\n🚀 次のステップ:")
        if copy_success:
            print("  1. cd ../app_build")
            print("  2. python3 setup.py py2app")
            print("  3. 美しいアイコン付きDOI Tool.appが完成!")
        else:
            print("  手動でアイコンファイルをapp_buildにコピーしてください")
        
        return 0
    else:
        print("\n❌ アイコン生成に失敗しました")
        return 1

if __name__ == "__main__":
    exit(main())
