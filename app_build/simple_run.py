#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
simple_run.py - 最もシンプルなDOI Tool実行スクリプト
"""

import os
import sys
import subprocess
from pathlib import Path

def main():
    print("🔬 DOI Tool - シンプル実行版")
    print("=" * 40)
    print()
    
    # 現在のディレクトリを取得
    script_dir = Path(__file__).parent
    project_dir = script_dir.parent
    
    print(f"プロジェクトディレクトリ: {project_dir}")
    print()
    
    # 作業ディレクトリを入力
    print("作業ディレクトリ（ScopusのCSVファイルがあるフォルダ）を入力してください:")
    print("例: /Users/username/Desktop/scopus_data")
    print("または 'q' で終了")
    print()
    
    while True:
        work_dir = input("作業ディレクトリ: ").strip()
        
        if work_dir.lower() == 'q':
            print("終了します")
            return
        
        if work_dir.startswith("~"):
            work_dir = os.path.expanduser(work_dir)
        
        work_path = Path(work_dir)
        
        if not work_path.exists():
            print(f"❌ ディレクトリが存在しません: {work_dir}")
            continue
        
        if not work_path.is_dir():
            print(f"❌ ディレクトリではありません: {work_dir}")
            continue
        
        # CSVファイルを確認
        csv_files = list(work_path.glob("*.csv"))
        csv_files = [f for f in csv_files if f.name != "scopus_combined.csv"]
        
        if not csv_files:
            print(f"❌ CSVファイルが見つかりません: {work_dir}")
            print("Scopusからエクスポートした .csv ファイルを配置してください")
            continue
        
        print(f"✅ {len(csv_files)} 個のCSVファイルが見つかりました")
        for csv_file in csv_files:
            size_kb = csv_file.stat().st_size / 1024
            print(f"  - {csv_file.name} ({size_kb:.1f} KB)")
        
        break
    
    print()
    print("処理を開始しますか？ (y/n): ", end="")
    if input().lower() != 'y':
        print("処理をキャンセルしました")
        return
    
    # 必要なスクリプトをコピー
    scripts = [
        "combine_scopus_csv.py",
        "scopus_doi_to_json.py",
        "json2tag_ref_scopus_async.py", 
        "add_abst_scopus.py"
    ]
    
    print("\n🚀 処理を開始します...")
    print("⚠️  処理中は中断しないでください")
    
    try:
        # スクリプトを作業ディレクトリにコピー
        import shutil
        for script in scripts:
            src = project_dir / script
            dst = work_path / script
            if src.exists():
                shutil.copy2(src, dst)
                print(f"📄 {script} をコピーしました")
        
        # 作業ディレクトリに移動して実行
        original_cwd = os.getcwd()
        os.chdir(work_path)
        
        # 各スクリプトを順番に実行
        for i, script in enumerate(scripts, 1):
            print(f"\n📊 ステップ {i}/{len(scripts)}: {script}")
            print("処理中...", end="", flush=True)
            
            try:
                result = subprocess.run(
                    [sys.executable, script],
                    capture_output=True,
                    text=True,
                    timeout=1800  # 30分タイムアウト
                )
                
                if result.returncode == 0:
                    print(" ✅ 完了")
                else:
                    print(f" ❌ エラー")
                    print(f"エラー詳細: {result.stderr}")
                    break
                    
            except subprocess.TimeoutExpired:
                print(" ⏰ タイムアウト")
                break
            except Exception as e:
                print(f" ❌ 予期しないエラー: {e}")
                break
        else:
            # 全て成功
            print("\n🎉 処理が完了しました！")
            
            # 結果確認
            md_folder = work_path / "md_folder"
            if md_folder.exists():
                md_files = list(md_folder.glob("*.md"))
                print(f"📝 {len(md_files)} 個のMarkdownファイルが生成されました")
                print(f"📁 結果フォルダ: {md_folder}")
                
                # フォルダを開く
                try:
                    subprocess.run(["open", str(md_folder)])
                except:
                    print("結果フォルダを手動で確認してください")
            else:
                print("⚠️  結果フォルダが見つかりません")
        
        os.chdir(original_cwd)
        
    except Exception as e:
        print(f"\n❌ 処理中にエラーが発生しました: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main())
