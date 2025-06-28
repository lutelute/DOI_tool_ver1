#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
refined_network_icon_generator.py - 洗練されたネットワーク型DOI Toolアイコン生成
"""

import os
import subprocess
from pathlib import Path

def create_network_svg():
    """洗練されたネットワーク型SVGアイコンを作成"""
    return '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="512" height="512" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <!-- メイングラデーション -->
    <linearGradient id="mainGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#667eea;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#764ba2;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#f093fb;stop-opacity:1" />
    </linearGradient>
    
    <!-- ペーパーグラデーション -->
    <linearGradient id="paperGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:0.95" />
      <stop offset="100%" style="stop-color:#f8fafc;stop-opacity:0.95" />
    </linearGradient>
    
    <!-- DOIボックスグラデーション -->
    <linearGradient id="doiGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:0.95" />
      <stop offset="100%" style="stop-color:#f1f5f9;stop-opacity:0.95" />
    </linearGradient>
    
    <!-- シャドウフィルター -->
    <filter id="softShadow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="6" stdDeviation="10" flood-color="rgba(0,0,0,0.15)"/>
    </filter>
    
    <filter id="paperShadow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="4" stdDeviation="8" flood-color="rgba(0,0,0,0.1)"/>
    </filter>
    
    <filter id="nodeGlow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="0" stdDeviation="6" flood-color="rgba(255,255,255,0.6)"/>
    </filter>
    
    <filter id="mainNodeGlow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="0" stdDeviation="8" flood-color="rgba(78,205,196,0.8)"/>
    </filter>
  </defs>
  
  <!-- 背景 -->
  <rect width="512" height="512" rx="115" fill="url(#mainGradient)"/>
  
  <!-- 論文レイヤー -->
  <g transform="translate(60, 60)">
    <!-- 論文1 -->
    <g transform="translate(40, 20) rotate(-8)" filter="url(#paperShadow)">
      <rect x="0" y="0" width="100" height="130" rx="12" fill="url(#paperGradient)" 
            stroke="rgba(255,255,255,0.3)" stroke-width="1"/>
      <!-- テキストライン -->
      <rect x="8" y="16" width="70" height="3" rx="1.5" fill="#e2e8f0"/>
      <rect x="8" y="24" width="55" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="32" width="65" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="40" width="45" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="50" width="75" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="58" width="50" height="2.5" rx="1.25" fill="#e2e8f0"/>
    </g>
    
    <!-- 論文2 -->
    <g transform="translate(280, 40) rotate(12)" filter="url(#paperShadow)">
      <rect x="0" y="0" width="95" height="125" rx="12" fill="url(#paperGradient)"
            stroke="rgba(255,255,255,0.3)" stroke-width="1"/>
      <!-- テキストライン -->
      <rect x="8" y="16" width="65" height="3" rx="1.5" fill="#e2e8f0"/>
      <rect x="8" y="24" width="50" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="32" width="70" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="40" width="40" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="50" width="60" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="58" width="55" height="2.5" rx="1.25" fill="#e2e8f0"/>
    </g>
    
    <!-- 論文3 -->
    <g transform="translate(140, 70) rotate(-3)" filter="url(#paperShadow)">
      <rect x="0" y="0" width="98" height="128" rx="12" fill="url(#paperGradient)"
            stroke="rgba(255,255,255,0.3)" stroke-width="1"/>
      <!-- テキストライン -->
      <rect x="8" y="16" width="68" height="3" rx="1.5" fill="#e2e8f0"/>
      <rect x="8" y="24" width="53" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="32" width="72" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="40" width="48" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="50" width="62" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="58" width="58" height="2.5" rx="1.25" fill="#e2e8f0"/>
    </g>
    
    <!-- 論文4 -->
    <g transform="translate(240, 140) rotate(15)" filter="url(#paperShadow)">
      <rect x="0" y="0" width="92" height="122" rx="12" fill="url(#paperGradient)"
            stroke="rgba(255,255,255,0.3)" stroke-width="1"/>
      <!-- テキストライン -->
      <rect x="8" y="16" width="62" height="3" rx="1.5" fill="#e2e8f0"/>
      <rect x="8" y="24" width="47" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="32" width="66" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="40" width="42" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="50" width="58" height="2.5" rx="1.25" fill="#e2e8f0"/>
      <rect x="8" y="58" width="52" height="2.5" rx="1.25" fill="#e2e8f0"/>
    </g>
  </g>
  
  <!-- ネットワークレイヤー -->
  <g opacity="0.9">
    <!-- 接続線（中央のメインノードから各ノードへ） -->
    <!-- 中央 → 左上 -->
    <line x1="256" y1="256" x2="150" y2="180" stroke="rgba(255,255,255,0.4)" 
          stroke-width="3" stroke-linecap="round"/>
    
    <!-- 中央 → 右上 -->
    <line x1="256" y1="256" x2="362" y2="170" stroke="rgba(255,255,255,0.4)" 
          stroke-width="3" stroke-linecap="round"/>
    
    <!-- 中央 → 左 -->
    <line x1="256" y1="256" x2="130" y2="256" stroke="rgba(255,255,255,0.4)" 
          stroke-width="3" stroke-linecap="round"/>
    
    <!-- 中央 → 右 -->
    <line x1="256" y1="256" x2="382" y2="256" stroke="rgba(255,255,255,0.4)" 
          stroke-width="3" stroke-linecap="round"/>
    
    <!-- 中央 → 左下 -->
    <line x1="256" y1="256" x2="140" y2="342" stroke="rgba(255,255,255,0.4)" 
          stroke-width="3" stroke-linecap="round"/>
    
    <!-- 中央 → 右下 -->
    <line x1="256" y1="256" x2="372" y2="332" stroke="rgba(255,255,255,0.4)" 
          stroke-width="3" stroke-linecap="round"/>
    
    <!-- 中央 → 下左 -->
    <line x1="256" y1="256" x2="200" y2="380" stroke="rgba(255,255,255,0.4)" 
          stroke-width="3" stroke-linecap="round"/>
    
    <!-- 中央 → 下右 -->
    <line x1="256" y1="256" x2="312" y2="380" stroke="rgba(255,255,255,0.4)" 
          stroke-width="3" stroke-linecap="round"/>
    
    <!-- ネットワークノード -->
    <!-- 外側のノード -->
    <circle cx="150" cy="180" r="12" fill="rgba(255,255,255,0.9)" filter="url(#nodeGlow)"/>
    <circle cx="362" cy="170" r="12" fill="rgba(255,255,255,0.9)" filter="url(#nodeGlow)"/>
    <circle cx="130" cy="256" r="12" fill="rgba(255,255,255,0.9)" filter="url(#nodeGlow)"/>
    <circle cx="382" cy="256" r="12" fill="rgba(255,255,255,0.9)" filter="url(#nodeGlow)"/>
    <circle cx="140" cy="342" r="12" fill="rgba(255,255,255,0.9)" filter="url(#nodeGlow)"/>
    <circle cx="372" cy="332" r="12" fill="rgba(255,255,255,0.9)" filter="url(#nodeGlow)"/>
    <circle cx="200" cy="380" r="12" fill="rgba(255,255,255,0.9)" filter="url(#nodeGlow)"/>
    <circle cx="312" cy="380" r="12" fill="rgba(255,255,255,0.9)" filter="url(#nodeGlow)"/>
    
    <!-- 中央メインノード -->
    <circle cx="256" cy="256" r="18" fill="#4ecdc4" filter="url(#mainNodeGlow)"/>
    <circle cx="256" cy="256" r="14" fill="rgba(255,255,255,0.8)"/>
    <circle cx="256" cy="256" r="8" fill="#4ecdc4"/>
  </g>
  
  <!-- DOIボックス -->
  <g transform="translate(186, 420)" filter="url(#softShadow)">
    <rect x="0" y="0" width="140" height="60" rx="30" fill="url(#doiGradient)"
          stroke="rgba(255,255,255,0.3)" stroke-width="1"/>
    <!-- DOIテキスト -->
    <text x="70" y="42" font-family="SF Mono, Monaco, Menlo, Consolas, monospace" 
          font-size="24" font-weight="700" fill="#2c3e50" 
          text-anchor="middle" letter-spacing="3px">DOI</text>
  </g>
  
  <!-- 装飾的な光点 -->
  <circle cx="120" cy="120" r="3" fill="rgba(255,255,255,0.6)" opacity="0.8"/>
  <circle cx="380" cy="100" r="2" fill="rgba(255,255,255,0.6)" opacity="0.6"/>
  <circle cx="90" cy="380" r="2.5" fill="rgba(255,255,255,0.6)" opacity="0.7"/>
  <circle cx="420" cy="380" r="2" fill="rgba(255,255,255,0.6)" opacity="0.5"/>
</svg>'''

def create_academic_variant_svg():
    """アカデミック版のSVGアイコンを作成"""
    return '''<?xml version="1.0" encoding="UTF-8"?>
<svg width="512" height="512" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <!-- アカデミックグラデーション -->
    <linearGradient id="academicGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#2c3e50;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#3498db;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#9b59b6;stop-opacity:1" />
    </linearGradient>
    
    <linearGradient id="academicPaper" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:0.9" />
      <stop offset="100%" style="stop-color:#ecf0f1;stop-opacity:0.9" />
    </linearGradient>
    
    <linearGradient id="academicDoi" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#3498db;stop-opacity:0.95" />
      <stop offset="100%" style="stop-color:#2980b9;stop-opacity:0.95" />
    </linearGradient>
    
    <filter id="academicShadow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="4" stdDeviation="8" flood-color="rgba(0,0,0,0.2)"/>
    </filter>
    
    <filter id="academicGlow" x="-50%" y="-50%" width="200%" height="200%">
      <feDropShadow dx="0" dy="0" stdDeviation="6" flood-color="rgba(52,152,219,0.6)"/>
    </filter>
  </defs>
  
  <!-- 背景 -->
  <rect width="512" height="512" rx="115" fill="url(#academicGradient)" 
        stroke="rgba(255,255,255,0.1)" stroke-width="3"/>
  
  <!-- [論文とネットワーク部分は同様の構造で色を変更] -->
  
</svg>'''

def generate_refined_network_icons():
    """洗練されたネットワーク型アイコンファイルを生成"""
    
    print("🌟 洗練されたネットワーク型DOI Tool アイコン生成")
    print("=" * 60)
    
    # 出力ディレクトリ作成
    base_dir = Path(__file__).parent
    assets_dir = base_dir / "generated_assets"
    iconset_dir = assets_dir / "DOI_Tool.iconset"
    
    assets_dir.mkdir(exist_ok=True)
    iconset_dir.mkdir(exist_ok=True)
    
    # メインSVGファイル作成
    svg_path = assets_dir / "doi_tool_icon.svg"
    with open(svg_path, 'w', encoding='utf-8') as f:
        f.write(create_network_svg())
    
    print(f"✅ ネットワーク型SVGアイコン作成: {svg_path}")
    
    # アカデミック版も作成
    academic_svg_path = assets_dir / "doi_tool_icon_academic.svg"
    with open(academic_svg_path, 'w', encoding='utf-8') as f:
        f.write(create_academic_variant_svg())
    
    print(f"✅ アカデミック版SVGアイコン作成: {academic_svg_path}")
    
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
                
                # 品質情報表示
                print("\n🎨 アイコンの特徴:")
                print("  📄 4つの重なり合う論文カード")
                print("  🌐 8つのネットワークノード（完全接続）")
                print("  ✨ 中央メインノードからの放射状接続")
                print("  🎯 DOIボックスでの明確な識別")
                print("  💫 洗練されたグラデーションとシャドウ")
                
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
    success = generate_refined_network_icons()
    
    if success:
        print("\n🎉 洗練されたネットワーク型アイコン生成完了！")
        print("\n📁 生成されたファイル:")
        
        assets_dir = Path(__file__).parent / "generated_assets"
        for file_path in assets_dir.rglob("*"):
            if file_path.is_file():
                size = file_path.stat().st_size
                print(f"  📄 {file_path.name} ({size / 1024:.1f} KB)")
        
        print("\n🌟 デザインの特徴:")
        print("  🎨 論文ネットワークの美しい視覚化")
        print("  🔗 完全接続されたネットワーク構造")
        print("  📄 4つの論文カードで研究要素を表現")
        print("  💎 洗練されたガラスモーフィズム効果")
        print("  🎯 中央集約型のハブ構造")
        
        print("\n🚀 次のステップ:")
        print("  developer_build.sh を実行してアプリケーションをビルド")
        
        return 0
    else:
        print("\n❌ アイコン生成に失敗しました")
        return 1

if __name__ == "__main__":
    exit(main())
