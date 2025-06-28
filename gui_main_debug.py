#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gui_main_debug.py - DOI Tool GUI版（デバッグ強化）
"""

import sys
import os

# デバッグ情報出力
print("🔍 DOI Tool GUI デバッグ開始")
print(f"Python バージョン: {sys.version}")
print(f"実行ディレクトリ: {os.getcwd()}")
print(f"スクリプトパス: {__file__}")

try:
    import tkinter as tk
    from tkinter import filedialog, messagebox, ttk
    print("✅ tkinter インポート成功")
except ImportError as e:
    print(f"❌ tkinter インポートエラー: {e}")
    print("💡 解決方法: brew install python-tk")
    sys.exit(1)

import subprocess
import threading
from pathlib import Path

class DOIToolGUI:
    def __init__(self, root):
        print("🏗️ GUI初期化開始")
        
        self.root = root
        self.root.title("DOI処理ツール")
        self.root.geometry("700x600")
        self.root.configure(bg='#f0f0f0')
        
        # デバッグ用：ウィンドウを前面に表示
        self.root.lift()
        self.root.attributes('-topmost', True)
        self.root.after_idle(lambda: self.root.attributes('-topmost', False))
        
        # アプリケーションのベースディレクトリを取得
        if getattr(sys, 'frozen', False):
            # py2appでビルドされた場合
            self.app_dir = os.path.dirname(sys.executable)
            print(f"🎯 実行モード: frozen, app_dir: {self.app_dir}")
        else:
            # 通常のPythonスクリプトとして実行された場合
            self.app_dir = os.path.dirname(os.path.abspath(__file__))
            print(f"🎯 実行モード: script, app_dir: {self.app_dir}")
        
        try:
            self.setup_ui()
            print("✅ GUI初期化完了")
        except Exception as e:
            print(f"❌ GUI初期化エラー: {e}")
            import traceback
            traceback.print_exc()
            raise
        
    def setup_ui(self):
        print("🎨 UI設定開始")
        
        # メインフレーム
        main_frame = tk.Frame(self.root, bg='#f0f0f0', padx=20, pady=20)
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # タイトル
        title_label = tk.Label(
            main_frame, 
            text="DOI処理ツール", 
            font=("Helvetica", 24, "bold"),
            bg='#f0f0f0',
            fg='#333'
        )
        title_label.pack(pady=(0, 10))
        
        # バージョン情報（デバッグ用）
        version_label = tk.Label(
            main_frame,
            text="v1.0.0 - デバッグモード",
            font=("Helvetica", 10),
            bg='#f0f0f0',
            fg='#666'
        )
        version_label.pack()
        
        # 説明
        desc_label = tk.Label(
            main_frame,
            text="ScopusのCSVファイルからMarkdownファイルを生成します",
            font=("Helvetica", 12),
            bg='#f0f0f0',
            fg='#666'
        )
        desc_label.pack(pady=(5, 20))
        
        # システム情報表示
        info_frame = tk.LabelFrame(
            main_frame,
            text="システム情報",
            font=("Helvetica", 10, "bold"),
            bg='#f0f0f0',
            padx=10,
            pady=5
        )
        info_frame.pack(fill=tk.X, pady=(0, 15))
        
        info_text = f"Python: {sys.version.split()[0]} | 作業場所: {self.app_dir}"
        tk.Label(
            info_frame,
            text=info_text,
            font=("Helvetica", 9),
            bg='#f0f0f0',
            fg='#555'
        ).pack()
        
        # ワーキングディレクトリ選択
        dir_frame = tk.Frame(main_frame, bg='#f0f0f0')
        dir_frame.pack(fill=tk.X, pady=(0, 20))
        
        tk.Label(
            dir_frame,
            text="作業ディレクトリ:",
            font=("Helvetica", 12, "bold"),
            bg='#f0f0f0'
        ).pack(anchor=tk.W)
        
        dir_select_frame = tk.Frame(dir_frame, bg='#f0f0f0')
        dir_select_frame.pack(fill=tk.X, pady=(5, 0))
        
        self.dir_var = tk.StringVar(value=str(Path.home() / "Desktop"))
        self.dir_entry = tk.Entry(
            dir_select_frame,
            textvariable=self.dir_var,
            font=("Helvetica", 11),
            state='readonly'
        )
        self.dir_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 10))
        
        self.select_button = tk.Button(
            dir_select_frame,
            text="📁 選択",
            command=self.select_directory,
            bg='#4CAF50',
            fg='white',
            font=("Helvetica", 10, "bold"),
            padx=20
        )
        self.select_button.pack(side=tk.RIGHT)
        
        # テストボタン（デバッグ用）
        test_button = tk.Button(
            dir_select_frame,
            text="🧪 テスト",
            command=self.test_dialog,
            bg='#2196F3',
            fg='white',
            font=("Helvetica", 10, "bold"),
            padx=15
        )
        test_button.pack(side=tk.RIGHT, padx=(0, 10))
        
        # ファイル情報表示
        info_frame = tk.LabelFrame(
            main_frame,
            text="CSVファイル情報",
            font=("Helvetica", 12, "bold"),
            bg='#f0f0f0',
            padx=10,
            pady=10
        )
        info_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 20))
        
        # ファイルリストボックスとスクロールバー
        list_frame = tk.Frame(info_frame, bg='#f0f0f0')
        list_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 10))
        
        self.file_listbox = tk.Listbox(
            list_frame,
            font=("Helvetica", 10),
            height=8
        )
        
        scrollbar = tk.Scrollbar(list_frame)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.file_listbox.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        
        self.file_listbox.config(yscrollcommand=scrollbar.set)
        scrollbar.config(command=self.file_listbox.yview)
        
        tk.Button(
            info_frame,
            text="🔄 ファイル一覧を更新",
            command=self.refresh_file_list,
            bg='#2196F3',
            fg='white',
            font=("Helvetica", 10, "bold")
        ).pack()
        
        # 実行ボタン
        self.run_button = tk.Button(
            main_frame,
            text="🚀 処理を開始",
            command=self.run_processing,
            bg='#FF5722',
            fg='white',
            font=("Helvetica", 14, "bold"),
            padx=30,
            pady=10
        )
        self.run_button.pack(pady=20)
        
        # プログレスバー
        self.progress = ttk.Progressbar(
            main_frame,
            mode='indeterminate',
            length=400
        )
        self.progress.pack(pady=(0, 10))
        
        # ステータス表示
        self.status_var = tk.StringVar(value="準備完了 - GUI正常動作中")
        self.status_label = tk.Label(
            main_frame,
            textvariable=self.status_var,
            font=("Helvetica", 11),
            bg='#f0f0f0',
            fg='#333'
        )
        self.status_label.pack()
        
        # 初期ファイル一覧更新
        self.refresh_file_list()
        
        print("✅ UI設定完了")
    
    def test_dialog(self):
        """デバッグ用テスト関数"""
        print("🧪 テストダイアログ実行")
        try:
            result = messagebox.showinfo("テスト", "GUI動作確認テスト成功！\n\nフォルダ選択ダイアログをテストしますか？")
            
            if messagebox.askyesno("フォルダ選択テスト", "フォルダ選択ダイアログをテストしますか？"):
                folder = filedialog.askdirectory(title="テスト用フォルダ選択")
                if folder:
                    messagebox.showinfo("結果", f"選択されたフォルダ:\n{folder}")
                    self.dir_var.set(folder)
                    self.refresh_file_list()
                else:
                    messagebox.showinfo("結果", "フォルダ選択がキャンセルされました")
                    
        except Exception as e:
            print(f"❌ テストエラー: {e}")
            messagebox.showerror("テストエラー", f"エラーが発生しました:\n{e}")
    
    def select_directory(self):
        print("📁 ディレクトリ選択開始")
        try:
            directory = filedialog.askdirectory(
                title="作業ディレクトリを選択してください",
                initialdir=self.dir_var.get()
            )
            print(f"📁 選択結果: {directory}")
            
            if directory:
                self.dir_var.set(directory)
                self.refresh_file_list()
                self.status_var.set(f"作業ディレクトリ更新: {os.path.basename(directory)}")
                print(f"✅ ディレクトリ設定完了: {directory}")
            else:
                print("📁 ディレクトリ選択キャンセル")
                
        except Exception as e:
            print(f"❌ ディレクトリ選択エラー: {e}")
            messagebox.showerror("エラー", f"ディレクトリ選択でエラーが発生しました:\n{e}")
    
    def refresh_file_list(self):
        print("🔄 ファイルリスト更新開始")
        self.file_listbox.delete(0, tk.END)
        work_dir = self.dir_var.get()
        
        try:
            if not os.path.exists(work_dir):
                self.file_listbox.insert(tk.END, "❌ ディレクトリが見つかりません")
                print(f"❌ ディレクトリなし: {work_dir}")
                return
            
            # CSVファイルを検索
            csv_files = [f for f in os.listdir(work_dir) 
                        if f.endswith('.csv') and f != 'scopus_combined.csv']
            
            print(f"🔍 見つかったCSVファイル: {len(csv_files)}個")
            
            if not csv_files:
                self.file_listbox.insert(tk.END, "📄 CSVファイルが見つかりません")
                self.file_listbox.insert(tk.END, "💡 ScopusからエクスポートしたCSVファイルを配置してください")
            else:
                for file in csv_files:
                    try:
                        file_path = os.path.join(work_dir, file)
                        file_size = os.path.getsize(file_path)
                        size_kb = file_size / 1024
                        self.file_listbox.insert(tk.END, f"📄 {file} ({size_kb:.1f} KB)")
                        print(f"✅ ファイル: {file} ({size_kb:.1f} KB)")
                    except Exception as e:
                        self.file_listbox.insert(tk.END, f"⚠️ {file} (サイズ取得エラー)")
                        print(f"⚠️ ファイルエラー: {file}, {e}")
                        
        except Exception as e:
            print(f"❌ ファイルリスト更新エラー: {e}")
            self.file_listbox.insert(tk.END, f"❌ エラー: {e}")
    
    def run_processing(self):
        print("🚀 処理開始")
        work_dir = self.dir_var.get()
        
        if not os.path.exists(work_dir):
            error_msg = "作業ディレクトリが存在しません"
            print(f"❌ {error_msg}")
            messagebox.showerror("エラー", error_msg)
            return
        
        csv_files = [f for f in os.listdir(work_dir) 
                    if f.endswith('.csv') and f != 'scopus_combined.csv']
        
        if not csv_files:
            error_msg = "処理対象のCSVファイルがありません"
            print(f"❌ {error_msg}")
            messagebox.showerror("エラー", error_msg)
            return
        
        print(f"✅ 処理開始 - CSVファイル: {len(csv_files)}個")
        
        # UIを無効化
        self.run_button.config(state='disabled')
        self.select_button.config(state='disabled')
        self.progress.start()
        self.status_var.set("処理中...")
        
        # バックグラウンドで処理実行
        thread = threading.Thread(target=self.execute_processing, args=(work_dir,))
        thread.daemon = True
        thread.start()
    
    def execute_processing(self, work_dir):
        print(f"🔧 バックグラウンド処理開始: {work_dir}")
        
        try:
            # スクリプトファイルのパスを取得
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
                dst_path = os.path.join(work_dir, script)
                if os.path.exists(src_path):
                    import shutil
                    shutil.copy2(src_path, dst_path)
                    print(f"📄 スクリプトコピー: {script}")
                else:
                    print(f"⚠️ スクリプトなし: {src_path}")
            
            # 作業ディレクトリに移動して各スクリプトを実行
            original_cwd = os.getcwd()
            os.chdir(work_dir)
            print(f"📁 作業ディレクトリ移動: {work_dir}")
            
            for i, script in enumerate(scripts, 1):
                status_msg = f"ステップ {i}/{len(scripts)}: {script} 実行中..."
                self.root.after(0, lambda s=status_msg: self.status_var.set(s))
                print(f"🔧 {status_msg}")
                
                result = subprocess.run([sys.executable, script], 
                                      capture_output=True, text=True, timeout=300)
                
                if result.returncode != 0:
                    error_msg = f"{script} でエラーが発生しました:\n{result.stderr}"
                    print(f"❌ {error_msg}")
                    raise Exception(error_msg)
                else:
                    print(f"✅ {script} 完了")
            
            os.chdir(original_cwd)
            print("✅ 全処理完了")
            
            # 成功メッセージ
            self.root.after(0, self.processing_complete)
            
        except Exception as e:
            print(f"❌ 処理エラー: {e}")
            self.root.after(0, lambda: self.processing_error(str(e)))
    
    def processing_complete(self):
        print("🎉 処理完了")
        self.progress.stop()
        self.run_button.config(state='normal')
        self.select_button.config(state='normal')
        self.status_var.set("✅ 処理完了！")
        
        work_dir = self.dir_var.get()
        md_folder = os.path.join(work_dir, "md_folder")
        
        if os.path.exists(md_folder):
            file_count = len([f for f in os.listdir(md_folder) if f.endswith('.md')])
            message = f"処理が完了しました！\n\n📝 {file_count}個のMarkdownファイルが生成されました。\n📁 保存場所: md_folder\n\n結果フォルダを開きますか？"
            
            if messagebox.askyesno("🎉 処理完了", message):
                subprocess.run(["open", md_folder])
        else:
            messagebox.showinfo("処理完了", "処理が完了しました。")
    
    def processing_error(self, error_message):
        print(f"💥 処理エラー表示: {error_message}")
        self.progress.stop()
        self.run_button.config(state='normal')
        self.select_button.config(state='normal')
        self.status_var.set("❌ エラーが発生しました")
        
        messagebox.showerror("エラー", f"処理中にエラーが発生しました:\n\n{error_message}")

def main():
    print("🚀 DOI Tool GUI メイン関数開始")
    
    try:
        print("🏗️ tkinter Root作成中...")
        root = tk.Tk()
        print("✅ tkinter Root作成完了")
        
        print("🎨 DOIToolGUI初期化中...")
        app = DOIToolGUI(root)
        print("✅ DOIToolGUI初期化完了")
        
        print("🔄 GUIメインループ開始")
        root.mainloop()
        print("✅ GUIメインループ終了")
        
    except ImportError as e:
        print(f"❌ Import エラー: {e}")
        print("💡 tkinterが利用できません")
        print("解決方法: brew install python-tk")
        return 1
    except Exception as e:
        print(f"❌ 予期しないエラー: {e}")
        import traceback
        traceback.print_exc()
        return 1
    
    print("✅ プログラム正常終了")
    return 0

if __name__ == "__main__":
    print("=" * 50)
    print("🎯 DOI Tool GUI デバッグ版 開始")
    print("=" * 50)
    exit_code = main()
    print("=" * 50)
    print(f"🏁 DOI Tool GUI 終了 (exit code: {exit_code})")
    print("=" * 50)
    sys.exit(exit_code)
