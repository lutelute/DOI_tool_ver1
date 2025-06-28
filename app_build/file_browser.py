#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
file_browser.py - Finderライクなファイルブラウザ付きDOI Tool
"""

import os
import sys
import subprocess
import threading
import time
from pathlib import Path
import shutil

class FileBrowser:
    """シンプルなファイルブラウザクラス"""
    
    def __init__(self, start_path=None):
        self.current_path = Path(start_path or Path.home())
        self.selected_files = []
        self.selected_directory = None
        
    def clear_screen(self):
        os.system('clear' if os.name == 'posix' else 'cls')
    
    def display_path_header(self):
        """現在のパス表示"""
        path_str = str(self.current_path)
        if len(path_str) > 60:
            path_str = "..." + path_str[-57:]
        
        print("┌" + "─" * 62 + "┐")
        print(f"│ 📁 現在の場所: {path_str:<47} │")
        print("└" + "─" * 62 + "┘")
    
    def list_directory_contents(self):
        """ディレクトリ内容一覧表示"""
        try:
            items = []
            
            # 親ディレクトリ項目
            if self.current_path.parent != self.current_path:
                items.append(("📁", "..", "親ディレクトリ", True, None))
            
            # ディレクトリとファイルを取得
            for item in sorted(self.current_path.iterdir()):
                if item.is_dir():
                    items.append(("📁", item.name, "フォルダ", True, item))
                elif item.suffix.lower() == '.csv':
                    size = item.stat().st_size / 1024
                    items.append(("📄", item.name, f"{size:.1f} KB", False, item))
            
            return items
            
        except PermissionError:
            return [("❌", "アクセス権限がありません", "", False, None)]
        except Exception as e:
            return [("❌", f"エラー: {str(e)}", "", False, None)]
    
    def select_csv_files(self):
        """CSVファイル選択モード"""
        while True:
            self.clear_screen()
            print("🔍 CSVファイル選択モード")
            print("=" * 64)
            self.display_path_header()
            print()
            
            items = self.list_directory_contents()
            
            if not items:
                print("📂 このフォルダは空です")
            else:
                print("📋 ファイル・フォルダ一覧:")
                print()
                
                csv_count = 0
                for i, (icon, name, info, is_dir, path) in enumerate(items, 1):
                    if not is_dir and path and path.suffix.lower() == '.csv':
                        csv_count += 1
                        selected = "✓" if path in self.selected_files else " "
                        print(f"  [{selected}] {i:2d}. {icon} {name}")
                        print(f"        └── {info}")
                    elif is_dir:
                        print(f"      {i:2d}. {icon} {name}")
                        if info != "親ディレクトリ" and info != "フォルダ":
                            print(f"        └── {info}")
                
                if csv_count == 0:
                    print("  ⚠️  CSVファイルが見つかりません")
            
            print()
            print("📋 操作メニュー:")
            print("  数字    : フォルダに移動 / CSVファイルを選択切替")
            print("  a       : 現在フォルダの全CSVファイルを選択")
            print("  c       : 選択をクリア")
            print("  d       : このフォルダを作業ディレクトリに設定")
            print("  s       : 選択したファイルで処理開始")
            print("  q       : 戻る")
            
            if self.selected_files:
                print(f"\n✅ 選択済み: {len(self.selected_files)} ファイル")
                for file in self.selected_files[:3]:
                    print(f"   📄 {file.name}")
                if len(self.selected_files) > 3:
                    print(f"   ... 他 {len(self.selected_files) - 3} ファイル")
            
            if self.selected_directory:
                print(f"\n📁 作業ディレクトリ: {self.selected_directory}")
            
            print()
            choice = input("選択 > ").strip().lower()
            
            if choice == 'q':
                break
            elif choice == 'a':
                # 全CSVファイルを選択
                for _, _, _, is_dir, path in items:
                    if not is_dir and path and path.suffix.lower() == '.csv':
                        if path not in self.selected_files:
                            self.selected_files.append(path)
            elif choice == 'c':
                # 選択をクリア
                self.selected_files.clear()
            elif choice == 'd':
                # このフォルダを作業ディレクトリに設定
                self.selected_directory = self.current_path
            elif choice == 's':
                # 処理開始
                if self.selected_files and self.selected_directory:
                    return self.selected_files, self.selected_directory
                else:
                    input("❌ CSVファイルと作業ディレクトリの両方を選択してください (Enter)")
            elif choice.isdigit():
                idx = int(choice) - 1
                if 0 <= idx < len(items):
                    icon, name, info, is_dir, path = items[idx]
                    
                    if name == "..":
                        # 親ディレクトリに移動
                        self.current_path = self.current_path.parent
                    elif is_dir and path:
                        # フォルダに移動
                        self.current_path = path
                    elif not is_dir and path and path.suffix.lower() == '.csv':
                        # CSVファイルの選択切替
                        if path in self.selected_files:
                            self.selected_files.remove(path)
                        else:
                            self.selected_files.append(path)
            else:
                input("❌ 無効な選択です (Enter)")
        
        return None, None
    
    def select_directory(self):
        """ディレクトリ選択モード"""
        while True:
            self.clear_screen()
            print("📁 フォルダ選択モード")
            print("=" * 64)
            self.display_path_header()
            print()
            
            items = self.list_directory_contents()
            
            if not items:
                print("📂 このフォルダは空です")
            else:
                print("📋 フォルダ一覧:")
                print()
                
                for i, (icon, name, info, is_dir, path) in enumerate(items, 1):
                    if is_dir:
                        print(f"  {i:2d}. {icon} {name}")
                        if info not in ["親ディレクトリ", "フォルダ"]:
                            print(f"      └── {info}")
                
                # CSV情報も表示
                csv_files = [item for item in items if not item[3] and item[4] and item[4].suffix.lower() == '.csv']
                if csv_files:
                    print(f"\n📄 このフォルダのCSVファイル: {len(csv_files)} 個")
            
            print()
            print("📋 操作メニュー:")
            print("  数字 : フォルダに移動")
            print("  s    : このフォルダを選択")
            print("  q    : 戻る")
            print()
            
            choice = input("選択 > ").strip().lower()
            
            if choice == 'q':
                break
            elif choice == 's':
                return self.current_path
            elif choice.isdigit():
                idx = int(choice) - 1
                if 0 <= idx < len(items):
                    icon, name, info, is_dir, path = items[idx]
                    
                    if name == "..":
                        self.current_path = self.current_path.parent
                    elif is_dir and path:
                        self.current_path = path
            else:
                input("❌ 無効な選択です (Enter)")
        
        return None

class DOIToolWithBrowser:
    def __init__(self):
        self.script_dir = Path(__file__).parent
        self.project_dir = self.script_dir.parent
        self.browser = FileBrowser()
        self.work_dir = None
        self.csv_files = []
        
    def clear_screen(self):
        os.system('clear' if os.name == 'posix' else 'cls')
    
    def print_banner(self):
        banner = """
╔══════════════════════════════════════════════════════════════╗
║                     🔍 DOI処理ツール                          ║
║                  ファイルブラウザ付きバージョン                    ║
║                                                              ║
║        Finderライクなファイル選択でCSV処理                      ║
╚══════════════════════════════════════════════════════════════╝
"""
        print(banner)
    
    def show_current_selection(self):
        """現在の選択状況を表示"""
        print("📋 現在の選択状況:")
        print("─" * 50)
        
        if self.work_dir:
            print(f"📁 作業ディレクトリ: {self.work_dir}")
        else:
            print("📁 作業ディレクトリ: 未選択")
        
        if self.csv_files:
            print(f"📄 選択されたCSVファイル: {len(self.csv_files)} 個")
            for i, file in enumerate(self.csv_files[:5], 1):
                size = file.stat().st_size / 1024
                print(f"   {i}. {file.name} ({size:.1f} KB)")
            if len(self.csv_files) > 5:
                print(f"   ... 他 {len(self.csv_files) - 5} ファイル")
        else:
            print("📄 CSVファイル: 未選択")
        print()
    
    def browse_and_select(self):
        """ファイルブラウザでCSVファイルと作業ディレクトリを選択"""
        self.clear_screen()
        self.print_banner()
        
        print("🔍 ファイル選択方法:")
        print("1. 個別選択 - CSVファイルを個別に選択")
        print("2. フォルダ選択 - フォルダ内の全CSVファイルを自動選択")
        print("3. 戻る")
        print()
        
        choice = input("選択 (1-3): ").strip()
        
        if choice == '1':
            # 個別選択モード
            files, directory = self.browser.select_csv_files()
            if files and directory:
                self.csv_files = files
                self.work_dir = directory
                return True
                
        elif choice == '2':
            # フォルダ選択モード
            directory = self.browser.select_directory()
            if directory:
                # フォルダ内の全CSVファイルを取得
                csv_files = list(directory.glob("*.csv"))
                csv_files = [f for f in csv_files if f.name != "scopus_combined.csv"]
                
                if csv_files:
                    self.csv_files = csv_files
                    self.work_dir = directory
                    return True
                else:
                    input("❌ 選択されたフォルダにCSVファイルがありません (Enter)")
        
        return False
    
    def run_processing_with_progress(self):
        """進捗バー付きで処理実行"""
        if not self.work_dir or not self.csv_files:
            input("❌ ファイルとディレクトリを選択してください (Enter)")
            return
        
        self.clear_screen()
        print("🚀 処理実行")
        print("=" * 60)
        print(f"📁 作業ディレクトリ: {self.work_dir}")
        print(f"📄 処理対象ファイル: {len(self.csv_files)} 個")
        print()
        
        for i, file in enumerate(self.csv_files[:5], 1):
            size = file.stat().st_size / 1024
            print(f"  {i}. {file.name} ({size:.1f} KB)")
        if len(self.csv_files) > 5:
            print(f"  ... 他 {len(self.csv_files) - 5} ファイル")
        
        print()
        confirm = input("処理を開始しますか？ (y/N): ").lower()
        if confirm != 'y':
            return
        
        try:
            # 選択されたCSVファイルを作業ディレクトリにコピー（必要に応じて）
            for csv_file in self.csv_files:
                if csv_file.parent != self.work_dir:
                    dest = self.work_dir / csv_file.name
                    shutil.copy2(csv_file, dest)
                    print(f"📄 {csv_file.name} をコピーしました")
            
            # 処理スクリプトをコピー
            scripts = [
                "combine_scopus_csv.py",
                "scopus_doi_to_json.py",
                "json2tag_ref_scopus_async.py",
                "add_abst_scopus.py"
            ]
            
            print("\n🔄 処理開始...")
            
            for script in scripts:
                src = self.project_dir / script
                dst = self.work_dir / script
                if src.exists():
                    shutil.copy2(src, dst)
            
            # 作業ディレクトリに移動して処理実行
            original_cwd = os.getcwd()
            os.chdir(self.work_dir)
            
            for i, script in enumerate(scripts, 1):
                print(f"\n📊 ステップ {i}/{len(scripts)}: {script}")
                print("処理中...", end="", flush=True)
                
                result = subprocess.run(
                    [sys.executable, script],
                    capture_output=True,
                    text=True
                )
                
                if result.returncode == 0:
                    print(" ✅ 完了")
                else:
                    print(f" ❌ エラー")
                    print(f"エラー詳細: {result.stderr}")
                    break
            else:
                print("\n🎉 全ての処理が完了しました！")
                
                # 結果確認
                md_folder = self.work_dir / "md_folder"
                if md_folder.exists():
                    md_files = list(md_folder.glob("*.md"))
                    print(f"📝 {len(md_files)} 個のMarkdownファイルが生成されました")
                    print(f"📁 結果フォルダ: {md_folder}")
                    
                    open_folder = input("\n結果フォルダを開きますか？ (y/N): ").lower()
                    if open_folder == 'y':
                        subprocess.run(["open", str(md_folder)])
            
            os.chdir(original_cwd)
            
        except Exception as e:
            print(f"\n❌ 処理中にエラーが発生しました: {e}")
        
        input("\nEnterキーで続行...")
    
    def main_menu(self):
        """メインメニュー"""
        while True:
            self.clear_screen()
            self.print_banner()
            
            self.show_current_selection()
            
            print("📋 メニュー:")
            print("  1. 🔍 ファイルブラウザでCSV選択")
            print("  2. 🚀 処理実行")
            print("  3. 📖 ヘルプ")
            print("  4. 🚪 終了")
            print("─" * 50)
            
            choice = input("\n選択 (1-4): ").strip()
            
            if choice == '1':
                if self.browse_and_select():
                    input("\n✅ ファイル選択が完了しました (Enter)")
            elif choice == '2':
                self.run_processing_with_progress()
            elif choice == '3':
                self.show_help()
            elif choice == '4':
                print("\n👋 DOI処理ツールを終了します")
                break
            else:
                input("❌ 無効な選択です (Enter)")
    
    def show_help(self):
        """ヘルプ表示"""
        help_text = """
📖 ファイルブラウザ付きDOI処理ツール ヘルプ
════════════════════════════════════════════════════

🔍 ファイル選択機能:
  - Finderライクなブラウザでファイル/フォルダを選択
  - 個別CSVファイル選択 または フォルダ一括選択
  - 複数ファイルの同時選択が可能

📋 操作方法:
  1. ファイルブラウザでCSVファイルを選択
  2. 作業ディレクトリを設定
  3. 処理を実行してMarkdownファイルを生成

🎯 選択モード:
  - 個別選択: 特定のCSVファイルのみを処理
  - フォルダ選択: フォルダ内の全CSVファイルを処理

⌨️  キー操作:
  - 数字: ファイル/フォルダ選択
  - a: 全CSVファイル選択
  - c: 選択クリア
  - d: 作業ディレクトリ設定
  - s: 選択完了/処理開始
  - q: 戻る

💡 Tips:
  - 大きなファイルは自動的に識別されます
  - 選択済みファイルは ✓ マークで表示
  - 作業ディレクトリは処理結果の保存先になります
"""
        
        self.clear_screen()
        print(help_text)
        input("\nEnterキーで戻る...")

def main():
    try:
        app = DOIToolWithBrowser()
        app.main_menu()
    except KeyboardInterrupt:
        print("\n\n👋 プログラムを終了します")
    except Exception as e:
        print(f"\n❌ 予期しないエラーが発生しました: {e}")

if __name__ == "__main__":
    main()
