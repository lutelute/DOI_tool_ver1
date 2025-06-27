#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gui_main.py - DOI Tool GUI版
"""

import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import os
import sys
import subprocess
import threading
from pathlib import Path

class DOIToolGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("DOI処理ツール")
        self.root.geometry("600x500")
        self.root.configure(bg='#f0f0f0')
        
        # アプリケーションのベースディレクトリを取得
        if getattr(sys, 'frozen', False):
            # py2appでビルドされた場合
            self.app_dir = os.path.dirname(sys.executable)
        else:
            # 通常のPythonスクリプトとして実行された場合
            self.app_dir = os.path.dirname(os.path.abspath(__file__))
        
        self.setup_ui()
        
    def setup_ui(self):
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
        
        # 説明
        desc_label = tk.Label(
            main_frame,
            text="ScopusのCSVファイルからMarkdownファイルを生成します",
            font=("Helvetica", 12),
            bg='#f0f0f0',
            fg='#666'
        )
        desc_label.pack(pady=(0, 30))
        
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
        
        tk.Button(
            dir_select_frame,
            text="選択",
            command=self.select_directory,
            bg='#4CAF50',
            fg='white',
            font=("Helvetica", 10, "bold"),
            padx=20
        ).pack(side=tk.RIGHT)
        
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
        
        self.file_listbox = tk.Listbox(
            info_frame,
            font=("Helvetica", 10),
            height=8
        )
        self.file_listbox.pack(fill=tk.BOTH, expand=True, pady=(0, 10))
        
        tk.Button(
            info_frame,
            text="ファイル一覧を更新",
            command=self.refresh_file_list,
            bg='#2196F3',
            fg='white',
            font=("Helvetica", 10, "bold")
        ).pack()
        
        # 実行ボタン
        self.run_button = tk.Button(
            main_frame,
            text="処理を開始",
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
        self.status_var = tk.StringVar(value="準備完了")
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
    
    def select_directory(self):
        directory = filedialog.askdirectory(
            title="作業ディレクトリを選択",
            initialdir=self.dir_var.get()
        )
        if directory:
            self.dir_var.set(directory)
            self.refresh_file_list()
    
    def refresh_file_list(self):
        self.file_listbox.delete(0, tk.END)
        work_dir = self.dir_var.get()
        
        if not os.path.exists(work_dir):
            self.file_listbox.insert(tk.END, "ディレクトリが見つかりません")
            return
        
        csv_files = [f for f in os.listdir(work_dir) if f.endswith('.csv') and f != 'scopus_combined.csv']
        
        if not csv_files:
            self.file_listbox.insert(tk.END, "CSVファイルが見つかりません")
        else:
            for file in csv_files:
                file_path = os.path.join(work_dir, file)
                file_size = os.path.getsize(file_path)
                size_kb = file_size / 1024
                self.file_listbox.insert(tk.END, f"{file} ({size_kb:.1f} KB)")
    
    def run_processing(self):
        work_dir = self.dir_var.get()
        
        if not os.path.exists(work_dir):
            messagebox.showerror("エラー", "作業ディレクトリが存在しません")
            return
        
        csv_files = [f for f in os.listdir(work_dir) if f.endswith('.csv') and f != 'scopus_combined.csv']
        
        if not csv_files:
            messagebox.showerror("エラー", "処理対象のCSVファイルがありません")
            return
        
        # UIを無効化
        self.run_button.config(state='disabled')
        self.progress.start()
        self.status_var.set("処理中...")
        
        # バックグラウンドで処理実行
        thread = threading.Thread(target=self.execute_processing, args=(work_dir,))
        thread.daemon = True
        thread.start()
    
    def execute_processing(self, work_dir):
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
            
            # 作業ディレクトリに移動して各スクリプトを実行
            original_cwd = os.getcwd()
            os.chdir(work_dir)
            
            for i, script in enumerate(scripts, 1):
                self.root.after(0, lambda s=f"ステップ {i}/{len(scripts)}: {script} 実行中...": self.status_var.set(s))
                
                result = subprocess.run([sys.executable, script], capture_output=True, text=True)
                
                if result.returncode != 0:
                    raise Exception(f"{script} でエラーが発生しました:\n{result.stderr}")
            
            os.chdir(original_cwd)
            
            # 成功メッセージ
            self.root.after(0, self.processing_complete)
            
        except Exception as e:
            self.root.after(0, lambda: self.processing_error(str(e)))
    
    def processing_complete(self):
        self.progress.stop()
        self.run_button.config(state='normal')
        self.status_var.set("処理完了！")
        
        work_dir = self.dir_var.get()
        md_folder = os.path.join(work_dir, "md_folder")
        
        if os.path.exists(md_folder):
            file_count = len([f for f in os.listdir(md_folder) if f.endswith('.md')])
            message = f"処理が完了しました！\n\n{file_count}個のMarkdownファイルが生成されました。\n\n結果フォルダを開きますか？"
            
            if messagebox.askyesno("処理完了", message):
                subprocess.run(["open", md_folder])
        else:
            messagebox.showinfo("処理完了", "処理が完了しました。")
    
    def processing_error(self, error_message):
        self.progress.stop()
        self.run_button.config(state='normal')
        self.status_var.set("エラーが発生しました")
        
        messagebox.showerror("エラー", f"処理中にエラーが発生しました:\n\n{error_message}")

def main():
    root = tk.Tk()
    app = DOIToolGUI(root)
    root.mainloop()

if __name__ == "__main__":
    main()
