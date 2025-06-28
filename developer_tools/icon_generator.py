#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
icon_generator.py - 開発者向けアイコン生成ツール
完成したアイコンファイルを生成し、generated_assets/に保存
"""

import os
import subprocess
from pathlib import Path

def create_doi_icon_svg():
    """最終版DOI Tool SVGアイコンを作成"""
    return '''<?xml version="1.0" encoding="UTF-8"?>
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
          fill="none" stroke-dasharray="15,10" opacity="0.8"/>
    
    <!-- 接続ドット -->
    <circle cx="260" cy="240" r="12" fill="#ff6b6b"/>
    <circle cx="320" cy="200" r="10" fill="#ff6b6b"/>
    <circle cx="370" cy="220" r="12" fill="#ff6b6b"/>
  </g>
  
  <!-- 光の効果 -->
  <circle cx="140" cy="140" r="3" fill="white" opacity="0.6"/>
  <circle cx="350" cy="100" r="2" fill="white" opacity="0.4"/>
</svg>'''

def generate_production_icons():
    """プロダクション用アイコンファイルを生成"""
    
    print("🎨 DOI Tool アイコン生成ツール（開発者向け）")
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
        f.write(create_doi_icon_svg())
    
    print(f"✅ SVGアイコン作成: {svg_path}")
    
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
    
    # SVG変換ツールを確認
    svg_tool = None
    if subprocess.run(['which', 'rsvg-convert'], capture_output=True).returncode == 0:
        svg_tool = 'rsvg-convert'
        print("✅ rsvg-convert を使用します")
    elif subprocess.run(['which', 'inkscape'], capture_output=True).returncode == 0:
        svg_tool = 'inkscape'
        print("✅ Inkscape を使用します")
    else:
        print("❌ SVG変換ツールが見つかりません")
        print("以下のいずれかをインストールしてください:")
        print("  brew install librsvg")
        print("  brew install inkscape")
        return False
    
    # PNGファイル生成
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
                print(f"✅ {filename} ({size}x{size})")
                success_count += 1
            else:
                print(f"❌ {filename} 失敗: {result.stderr}")
        
        except Exception as e:
            print(f"❌ {filename} エラー: {e}")
    
    print(f"\n📊 PNG生成結果: {success_count}/{len(icon_sizes)} 成功")
    
    # icnsファイル生成
    if success_count == len(icon_sizes):
        print("\n🔨 icnsファイルを作成中...")
        icns_path = assets_dir / "DOI_Tool.icns"
        
        try:
            result = subprocess.run([
                'iconutil', '-c', 'icns', str(iconset_dir),
                '-o', str(icns_path)
            ], capture_output=True, text=True)
            
            if result.returncode == 0:
                print(f"🎉 icnsファイル作成完了: {icns_path}")
                
                # ファイルサイズ確認
                icns_size = icns_path.stat().st_size
                print(f"📏 ファイルサイズ: {icns_size / 1024:.1f} KB")
                
                return True
            else:
                print(f"❌ icnsファイル作成失敗: {result.stderr}")
                return False
                
        except Exception as e:
            print(f"❌ icnsファイル作成エラー: {e}")
            return False
    else:
        print("❌ PNGファイル生成が不完全なため、icnsファイルを作成できません")
        return False

def main():
    """メイン関数"""
    success = generate_production_icons()
    
    if success:
        print("\n🎉 アイコン生成完了！")
        print("\n📁 生成されたファイル:")
        
        assets_dir = Path(__file__).parent / "generated_assets"
        for file_path in assets_dir.rglob("*"):
            if file_path.is_file():
                size = file_path.stat().st_size
                print(f"  📄 {file_path.name} ({size / 1024:.1f} KB)")
        
        print("\n🚀 次のステップ:")
        print("  このアイコンファイルをapp_buildディレクトリにコピーして")
        print("  アプリケーションをビルドしてください")
        
        return 0
    else:
        print("\n❌ アイコン生成に失敗しました")
        return 1

if __name__ == "__main__":
    exit(main())
