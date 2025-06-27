#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
cli_gui.py - コマンドライン版GUI（tkinter不要）
"""

import os
import sys
import subprocess
import threading
import time
from pathlib import Path

class DOIToolCLI:
    def __init__(self):
        # アプリケーションのベースディレクトリを取得
        if getattr(sys, 'frozen', False):
            self.app_dir = os.path.dirname(sys.executable)
        else:
            self.app_dir = os.path.dirname(os.path.abspath(__file__))
        
        self.work_dir = str(Path.home() / "Desktop")
        
    def clear_screen(self):
        """画面をクリア"""
        os.system('clear' if os.name == 'posix' else 'cls')
    
    def print_header(self):
        """ヘッダーを表示"""
        print("=" * 60)
        print("🔬 DOI処理ツール - コマンドライン版")
        print("   Scopus CSVファイル → Markdownファイル生成")
        print("=" * 60)
        print()
    
    def print_menu(self):
        """メニューを表示"""
        print("📋 メニュー:")
        print("1. 作業ディレクトリの設定")
        print("2. CSVファイル一覧の確認")
        print("3. 処理の開始")
        print("4. ヘルプ")
        print("5. 終了")
        print()
    
    def select_directory(self):
        """作業ディレクトリを選択"""
        print("📁 作業ディレクトリの設定")
        print("-" * 30)
        print(f"現在の作業ディレクトリ: {self.work_dir}")
        print()
        
        while True:
            new_dir = input("新しい作業ディレクトリのパスを入力してください（Enter で現在のまま）: ").strip()
            
            if not new_dir:
                print("✅ 作業ディレクトリは変更されませんでした")
                break
            
            if new_dir.startswith("~"):
                new_dir = os.path.expanduser(new_dir)
            
            if os.path.exists(new_dir) and os.path.isdir(new_dir):
                self.work_dir = new_dir
                print(f"✅ 作業ディレクトリを変更しました: {self.work_dir}")
                break
            else:
                print("❌ 指定されたディレクトリが存在しません")
                retry = input("再入力しますか？ (y/n): ").lower()
                if retry != 'y':
                    break
        
        input("\nEnter キーを押して続行...")
    
    def list_csv_files(self):
        """CSVファイル一覧を表示"""
        print("📄 CSVファイル一覧")
        print("-" * 30)
        print(f"検索ディレクトリ: {self.work_dir}")
        print()
        
        if not os.path.exists(self.work_dir):
            print("❌ ディレクトリが存在しません")
            input("\nEnter キーを押して続行...")
            return
        
        csv_files = [f for f in os.listdir(self.work_dir) 
                    if f.endswith('.csv') and f != 'scopus_combined.csv']
        
        if not csv_files:
            print("❌ CSVファイルが見つかりません")
            print("\n💡 Scopusからエクスポートした .csv ファイルをディレクトリに配置してください")
        else:
            print(f"✅ {len(csv_files)} 個のCSVファイルが見つかりました:")
            print()
            
            for i, file in enumerate(csv_files, 1):
                file_path = os.path.join(self.work_dir, file)
                file_size = os.path.getsize(file_path)
                size_kb = file_size / 1024
                print(f"  {i:2d}. {file} ({size_kb:.1f} KB)")
        
        input("\nEnter キーを押して続行...")
    
    def show_progress(self, stop_event):
        """プログレス表示"""
        chars = "|/-\\"
        i = 0
        while not stop_event.is_set():
            print(f"\r処理中 {chars[i % len(chars)]}", end="", flush=True)
            i += 1
            time.sleep(0.1)
        print("\r" + " " * 20 + "\r", end="", flush=True)
    
    def run_processing(self):
        """処理を実行"""
        print("🚀 処理の開始")
        print("-" * 30)
        
        # 作業ディレクトリの確認
        if not os.path.exists(self.work_dir):
            print("❌ 作業ディレクトリが存在しません")
            input("\nEnter キーを押して続行...")
            return
        
        # CSVファイルの確認
        csv_files = [f for f in os.listdir(self.work_dir) 
                    if f.endswith('.csv') and f != 'scopus_combined.csv']
        
        if not csv_files:
            print("❌ 処理対象のCSVファイルがありません")
            input("\nEnter キーを押して続行...")
            return
        
        print(f"作業ディレクトリ: {self.work_dir}")
        print(f"処理対象ファイル: {len(csv_files)} 個")
        print()
        
        # 確認
        confirm = input("処理を開始しますか？ (y/n): ").lower()
        if confirm != 'y':
            print("処理がキャンセルされました")
            input("\nEnter キーを押して続行...")
            return
        
        print("\n処理を開始します...")
        print("⚠️  処理中は中断しないでください")
        print()
        
        try:
            # スクリプトファイルのパス
            scripts = [
                "combine_scopus_csv.py",
                "scopus_doi_to_json.py", 
                "json2tag_ref_scopus_async.py",
                "add_abst_scopus.py"
            ]
            
            # 元のディレクトリから各スクリプトを作業ディレクトリにコピー
            original_dir = os.path.dirname(self.app_dir)
            for script in scripts:
                src_path = os.path.join(original_dir, script)
                dst_path = os.path.join(self.work_dir, script)
                if os.path.exists(src_path):
                    import shutil
                    shutil.copy2(src_path, dst_path)
            
            # 作業ディレクトリに移動して各スクリプトを実行
            original_cwd = os.getcwd()
            os.chdir(self.work_dir)
            
            for i, script in enumerate(scripts, 1):
                print(f"ステップ {i}/{len(scripts)}: {script}")
                
                # プログレス表示開始
                stop_event = threading.Event()
                progress_thread = threading.Thread(target=self.show_progress, args=(stop_event,))
                progress_thread.start()
                
                try:
                    result = subprocess.run([sys.executable, script], 
                                          capture_output=True, text=True, timeout=1800)  # 30分タイムアウト
                    
                    stop_event.set()
                    progress_thread.join()
                    
                    if result.returncode != 0:
                        print(f"\n❌ {script} でエラーが発生しました:")
                        print(result.stderr)
                        break
                    else:
                        print(f"✅ {script} 完了")
                
                except subprocess.TimeoutExpired:
                    stop_event.set()
                    progress_thread.join()
                    print(f"\n⏰ {script} がタイムアウトしました")
                    break
                
                except Exception as e:
                    stop_event.set()
                    progress_thread.join()
                    print(f"\n❌ {script} で予期しないエラー: {e}")
                    break
            
            else:
                # 全て成功
                os.chdir(original_cwd)
                print("\n🎉 処理が完了しました！")
                
                # 結果の確認
                md_folder = os.path.join(self.work_dir, "md_folder")
                if os.path.exists(md_folder):
                    file_count = len([f for f in os.listdir(md_folder) if f.endswith('.md')])
                    print(f"📝 {file_count} 個のMarkdownファイルが生成されました")
                    print(f"📁 結果フォルダ: {md_folder}")
                    
                    # フォルダを開くか確認
                    open_folder = input("\n結果フォルダを開きますか？ (y/n): ").lower()
                    if open_folder == 'y':
                        subprocess.run(["open", md_folder])
                
                input("\nEnter キーを押して続行...")
                return
            
            os.chdir(original_cwd)
            
        except Exception as e:
            print(f"\n❌ 処理中にエラーが発生しました: {e}")
        
        input("\nEnter キーを押して続行...")
    
    def show_help(self):
        """ヘルプを表示"""
        print("📖 ヘルプ")
        print("-" * 30)
        print("このツールは Scopus からエクスポートした CSV ファイルを")
        print("Markdown ファイルに変換するツールです。")
        print()
        print("📋 使用手順:")
        print("1. Scopus から論文データを CSV 形式でエクスポート")
        print("2. CSV ファイルを任意のフォルダに配置")
        print("3. このツールで作業ディレクトリを設定")
        print("4. 処理を開始")
        print()
        print("📁 出力:")
        print("- JSON_folder/    : 中間データ（JSON形式）")
        print("- md_folder/      : 最終結果（Markdownファイル）")
        print("- scopus_combined.csv : 統合されたCSVファイル")
        print()
        print("⚠️  注意事項:")
        print("- インターネット接続が必要です")
        print("- 処理には時間がかかる場合があります")
        print("- 処理中は中断しないでください")
        print()
        print("🔗 システム要件:")
        print("- Python 3.8以降")
        print("- インターネット接続")
        print("- 必要なパッケージ（自動インストール）")
        
        input("\nEnter キーを押して続行...")
    
    def run(self):
        """メインループ"""
        while True:
            self.clear_screen()
            self.print_header()
            
            print(f"📁 現在の作業ディレクトリ: {self.work_dir}")
            print()
            
            self.print_menu()
            
            choice = input("選択してください (1-5): ").strip()
            
            if choice == '1':
                self.clear_screen()
                self.print_header()
                self.select_directory()
            
            elif choice == '2':
                self.clear_screen()
                self.print_header()
                self.list_csv_files()
            
            elif choice == '3':
                self.clear_screen()
                self.print_header()
                self.run_processing()
            
            elif choice == '4':
                self.clear_screen()
                self.print_header()
                self.show_help()
            
            elif choice == '5':
                print("\n👋 DOI処理ツールを終了します")
                break
            
            else:
                print("❌ 無効な選択です")
                time.sleep(1)

def main():
    """メイン関数"""
    app = DOIToolCLI()
    app.run()

if __name__ == "__main__":
    main()
