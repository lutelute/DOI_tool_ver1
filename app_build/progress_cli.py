#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
progress_cli.py - 進捗バー付きDOI Tool CLI版
"""

import os
import sys
import subprocess
import threading
import time
from pathlib import Path
import shutil

class ProgressBar:
    """美しい進捗バークラス"""
    
    def __init__(self, total=100, width=50, title="処理中"):
        self.total = total
        self.width = width
        self.title = title
        self.current = 0
        self.start_time = time.time()
        self.is_running = False
        
    def update(self, value, message=""):
        """進捗を更新"""
        self.current = min(value, self.total)
        self._display(message)
    
    def increment(self, message=""):
        """進捗を1つ進める"""
        self.current = min(self.current + 1, self.total)
        self._display(message)
    
    def _display(self, message=""):
        """進捗バーを表示"""
        if self.total == 0:
            percentage = 100
            filled_width = self.width
        else:
            percentage = (self.current / self.total) * 100
            filled_width = int((self.current / self.total) * self.width)
        
        # 経過時間計算
        elapsed = time.time() - self.start_time
        
        # 進捗バー作成
        bar = "█" * filled_width + "░" * (self.width - filled_width)
        
        # 時間表示
        mins, secs = divmod(int(elapsed), 60)
        time_str = f"{mins:02d}:{secs:02d}"
        
        # 進捗表示
        progress_line = f"\r🔄 {self.title} [{bar}] {percentage:6.1f}% ({self.current}/{self.total}) {time_str}"
        
        if message:
            # メッセージがある場合は改行して表示
            print(f"\r{' ' * (len(progress_line) + 10)}", end="")  # 前の行をクリア
            print(f"\r💬 {message}")
            print(progress_line, end="", flush=True)
        else:
            print(progress_line, end="", flush=True)
    
    def finish(self, message="完了"):
        """進捗バー完了"""
        self.current = self.total
        self._display()
        print(f"\n✅ {message}")

class SpinnerProgress:
    """スピナー型進捗表示"""
    
    def __init__(self, message="処理中"):
        self.message = message
        self.is_running = False
        self.thread = None
        self.chars = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
        self.current_char = 0
        
    def start(self):
        """スピナー開始"""
        self.is_running = True
        self.thread = threading.Thread(target=self._spin)
        self.thread.daemon = True
        self.thread.start()
    
    def stop(self, final_message="完了"):
        """スピナー停止"""
        self.is_running = False
        if self.thread:
            self.thread.join()
        print(f"\r{' ' * 50}", end="")  # クリア
        print(f"\r✅ {final_message}")
    
    def _spin(self):
        """スピナーアニメーション"""
        while self.is_running:
            char = self.chars[self.current_char % len(self.chars)]
            print(f"\r{char} {self.message}...", end="", flush=True)
            self.current_char += 1
            time.sleep(0.1)

class DOIToolProgress:
    def __init__(self):
        self.script_dir = Path(__file__).parent
        self.project_dir = self.script_dir.parent
        self.work_dir = str(Path.home() / "Desktop")
        
    def clear_screen(self):
        """画面をクリア"""
        os.system('clear' if os.name == 'posix' else 'cls')
    
    def print_banner(self):
        """バナー表示"""
        banner = """
╔══════════════════════════════════════════════════════════════╗
║                     🔬 DOI処理ツール                          ║
║                   進捗バー付きバージョン                        ║
║                                                              ║
║     Scopus CSVファイル → Markdownファイル生成                   ║
╚══════════════════════════════════════════════════════════════╝
"""
        print(banner)
    
    def select_directory(self):
        """作業ディレクトリ選択"""
        print("📁 作業ディレクトリの設定")
        print("─" * 50)
        print(f"現在: {self.work_dir}")
        print()
        
        while True:
            new_dir = input("新しいディレクトリパス（Enter=現在のまま, q=戻る）: ").strip()
            
            if not new_dir or new_dir.lower() == 'q':
                break
            
            if new_dir.startswith("~"):
                new_dir = os.path.expanduser(new_dir)
            
            if os.path.exists(new_dir) and os.path.isdir(new_dir):
                self.work_dir = new_dir
                print(f"✅ 設定完了: {self.work_dir}")
                break
            else:
                print("❌ ディレクトリが存在しません")
    
    def show_csv_files(self):
        """CSVファイル一覧表示"""
        print("📄 CSVファイル確認")
        print("─" * 50)
        
        if not os.path.exists(self.work_dir):
            print("❌ ディレクトリが存在しません")
            return []
        
        csv_files = [f for f in os.listdir(self.work_dir) 
                    if f.endswith('.csv') and f != 'scopus_combined.csv']
        
        if not csv_files:
            print("❌ 処理対象のCSVファイルが見つかりません")
            print("💡 ScopusからエクスポートしたCSVファイルを配置してください")
            return []
        
        print(f"✅ {len(csv_files)} 個のファイルが見つかりました:")
        print()
        
        total_size = 0
        for i, file in enumerate(csv_files, 1):
            file_path = os.path.join(self.work_dir, file)
            file_size = os.path.getsize(file_path)
            size_kb = file_size / 1024
            total_size += size_kb
            
            # ファイルサイズに応じてアイコンを変更
            if size_kb < 100:
                icon = "📄"
            elif size_kb < 1000:
                icon = "📋"
            else:
                icon = "📊"
            
            print(f"  {icon} {i:2d}. {file}")
            print(f"      └── {size_kb:8.1f} KB")
        
        print(f"\n📈 合計サイズ: {total_size:.1f} KB")
        return csv_files
    
    def run_with_progress(self):
        """進捗バー付きで処理実行"""
        print("🚀 処理実行")
        print("─" * 50)
        
        # 事前チェック
        csv_files = self.show_csv_files()
        if not csv_files:
            input("\nEnterキーで戻る...")
            return
        
        print(f"\n作業ディレクトリ: {self.work_dir}")
        print(f"処理対象: {len(csv_files)} ファイル")
        
        confirm = input("\n処理を開始しますか？ (y/N): ").lower()
        if confirm != 'y':
            print("処理をキャンセルしました")
            return
        
        # 処理開始
        print("\n" + "="*60)
        print("🔄 DOI処理パイプライン開始")
        print("="*60)
        
        scripts = [
            ("combine_scopus_csv.py", "CSVファイル統合", 15),
            ("scopus_doi_to_json.py", "DOI情報取得", 40), 
            ("json2tag_ref_scopus_async.py", "参考文献解決", 35),
            ("add_abst_scopus.py", "要約追加", 10)
        ]
        
        total_steps = sum(weight for _, _, weight in scripts)
        overall_progress = ProgressBar(total_steps, width=60, title="全体進捗")
        
        try:
            # スクリプトコピー
            spinner = SpinnerProgress("必要ファイルを準備中")
            spinner.start()
            
            for script_name, _, _ in scripts:
                src = self.project_dir / script_name
                dst = Path(self.work_dir) / script_name
                if src.exists():
                    shutil.copy2(src, dst)
            
            spinner.stop("準備完了")
            
            # 作業ディレクトリに移動
            original_cwd = os.getcwd()
            os.chdir(self.work_dir)
            
            current_progress = 0
            
            # 各スクリプトを実行
            for i, (script, description, weight) in enumerate(scripts, 1):
                print(f"\n📋 ステップ {i}/{len(scripts)}: {description}")
                print("─" * 40)
                
                step_progress = ProgressBar(weight, width=40, title=f"ステップ{i}")
                
                # スクリプト実行（進捗シミュレーション付き）
                process = subprocess.Popen(
                    [sys.executable, script],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True
                )
                
                # 進捗シミュレーション
                step_current = 0
                while process.poll() is None:
                    time.sleep(0.5)
                    step_current = min(step_current + 1, weight - 1)
                    step_progress.update(step_current, f"{description}実行中...")
                    overall_progress.update(current_progress + step_current)
                
                # プロセス完了確認
                stdout, stderr = process.communicate()
                
                if process.returncode == 0:
                    step_progress.finish(f"{description}完了")
                    current_progress += weight
                    overall_progress.update(current_progress, f"ステップ{i}完了")
                else:
                    step_progress.finish(f"{description}エラー")
                    print(f"\n❌ エラーが発生しました:")
                    print(stderr[:500] + "..." if len(stderr) > 500 else stderr)
                    break
                
                time.sleep(0.5)  # 視覚的な間隔
            
            else:
                # 全ステップ完了
                overall_progress.finish("全処理完了")
                print("\n" + "="*60)
                print("🎉 処理が正常に完了しました！")
                print("="*60)
                
                # 結果表示
                self.show_results()
            
            os.chdir(original_cwd)
            
        except KeyboardInterrupt:
            print("\n\n⚠️  処理が中断されました")
            os.chdir(original_cwd)
        except Exception as e:
            print(f"\n❌ 予期しないエラー: {e}")
            os.chdir(original_cwd)
        
        input("\nEnterキーで続行...")
    
    def show_results(self):
        """結果表示"""
        md_folder = Path(self.work_dir) / "md_folder"
        
        if md_folder.exists():
            md_files = list(md_folder.glob("*.md"))
            print(f"\n📝 生成されたファイル: {len(md_files)} 個")
            print(f"📁 保存場所: {md_folder}")
            
            if md_files:
                print("\n📋 生成ファイル例:")
                for i, md_file in enumerate(md_files[:5], 1):
                    print(f"  {i}. {md_file.name}")
                if len(md_files) > 5:
                    print(f"  ... 他 {len(md_files) - 5} ファイル")
            
            # フォルダを開く
            open_folder = input("\n結果フォルダを開きますか？ (y/N): ").lower()
            if open_folder == 'y':
                try:
                    subprocess.run(["open", str(md_folder)])
                    print("✅ フォルダを開きました")
                except Exception as e:
                    print(f"⚠️  フォルダを開けませんでした: {e}")
        else:
            print("\n⚠️  結果フォルダが見つかりません")
    
    def show_help(self):
        """ヘルプ表示"""
        help_text = """
📖 DOI処理ツール ヘルプ
════════════════════════════════════════════════════

🎯 機能:
  Scopus からエクスポートしたCSVファイルを読み込み、
  DOI情報を取得してMarkdownファイルを生成します。

📋 処理ステップ:
  1. CSVファイル統合    - 複数のCSVを1つに結合
  2. DOI情報取得       - Crossref APIから詳細情報を取得
  3. 参考文献解決      - 引用文献のDOIを解決
  4. 要約追加         - 最終的なMarkdownファイルを生成

📁 必要なファイル:
  - Scopusからエクスポートした .csv ファイル
  - インターネット接続（API通信のため）

📝 出力ファイル:
  - JSON_folder/      中間データ（JSON形式）
  - md_folder/        最終結果（Markdownファイル）
  - scopus_combined.csv  統合CSVファイル

⚠️  注意事項:
  - 処理時間は論文数によって変動します
  - 大量のDOIがある場合、数時間かかることがあります
  - 処理中は中断しないでください

💡 進捗バーについて:
  - 全体進捗: 4つのステップの総合進捗
  - ステップ進捗: 現在実行中のステップの進捗
  - スピナー: ファイル準備などの短時間処理
"""
        print(help_text)
        input("\nEnterキーで戻る...")
    
    def main_menu(self):
        """メインメニュー"""
        while True:
            self.clear_screen()
            self.print_banner()
            
            print(f"📁 作業ディレクトリ: {self.work_dir}")
            
            # CSVファイル数を表示
            if os.path.exists(self.work_dir):
                csv_count = len([f for f in os.listdir(self.work_dir) 
                               if f.endswith('.csv') and f != 'scopus_combined.csv'])
                if csv_count > 0:
                    print(f"📄 検出されたCSVファイル: {csv_count} 個")
                else:
                    print("⚠️  CSVファイルが見つかりません")
            
            print("\n" + "─" * 60)
            print("📋 メニュー:")
            print("  1. 📁 作業ディレクトリ設定")
            print("  2. 📄 CSVファイル確認") 
            print("  3. 🚀 処理実行（進捗バー付き）")
            print("  4. 📖 ヘルプ")
            print("  5. 🚪 終了")
            print("─" * 60)
            
            choice = input("\n選択 (1-5): ").strip()
            
            if choice == '1':
                self.select_directory()
                input("\nEnterキーで続行...")
            elif choice == '2':
                self.show_csv_files()
                input("\nEnterキーで続行...")
            elif choice == '3':
                self.run_with_progress()
            elif choice == '4':
                self.show_help()
            elif choice == '5':
                print("\n👋 DOI処理ツールを終了します")
                break
            else:
                print("❌ 無効な選択です")
                time.sleep(1)

def main():
    try:
        app = DOIToolProgress()
        app.main_menu()
    except KeyboardInterrupt:
        print("\n\n👋 プログラムを終了します")
    except Exception as e:
        print(f"\n❌ 予期しないエラーが発生しました: {e}")

if __name__ == "__main__":
    main()
