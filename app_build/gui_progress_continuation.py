        # UIを無効化
        self.run_button.config(state='disabled')
        self.stop_button.config(state='normal')
        self.processing = True
        
        # バックグラウンドで処理実行
        thread = threading.Thread(target=self.execute_processing, args=(work_dir,))
        thread.daemon = True
        thread.start()
    
    def stop_processing(self):
        """処理を停止"""
        self.processing = False
        if self.process:
            self.process.terminate()
        
        self.run_button.config(state='normal')
        self.stop_button.config(state='disabled')
        self.update_progress(0, 0, "処理が停止されました")
    
    def execute_processing(self, work_dir):
        try:
            scripts = [
                ("combine_scopus_csv.py", "CSVファイル統合", 15),
                ("scopus_doi_to_json.py", "DOI情報取得", 40), 
                ("json2tag_ref_scopus_async.py", "参考文献解決", 35),
                ("add_abst_scopus.py", "要約追加", 10)
            ]
            
            total_weight = sum(weight for _, _, weight in scripts)
            
            # スクリプトファイルのコピー
            self.root.after(0, lambda: self.update_progress(0, 0, "必要ファイルを準備中..."))
            
            original_dir = os.path.dirname(self.app_dir)
            for script, _, _ in scripts:
                if not self.processing:
                    return
                
                src_path = os.path.join(original_dir, script)
                dst_path = os.path.join(work_dir, script)
                if os.path.exists(src_path):
                    import shutil
                    shutil.copy2(src_path, dst_path)
            
            # 作業ディレクトリに移動して各スクリプトを実行
            original_cwd = os.getcwd()
            os.chdir(work_dir)
            
            current_weight = 0
            
            for i, (script, description, weight) in enumerate(scripts, 1):
                if not self.processing:
                    break
                
                self.root.after(0, lambda d=description, i=i, total=len(scripts): 
                                self.update_progress(
                                    (current_weight / total_weight) * 100,
                                    0,
                                    f"ステップ {i}/{total}: {d}"
                                ))
                
                try:
                    self.process = subprocess.Popen(
                        [sys.executable, script], 
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE,
                        text=True
                    )
                    
                    # 進捗シミュレーション
                    step_progress = 0
                    while self.process.poll() is None and self.processing:
                        step_progress = min(step_progress + 2, weight - 1)
                        overall_progress = ((current_weight + step_progress) / total_weight) * 100
                        
                        self.root.after(0, lambda op=overall_progress, sp=(step_progress/weight)*100, d=description: 
                                        self.update_progress(op, sp, f"{d}実行中..."))
                        time.sleep(0.5)
                    
                    if not self.processing:
                        break
                    
                    stdout, stderr = self.process.communicate()
                    
                    if self.process.returncode != 0:
                        error_msg = stderr[:300] + "..." if len(stderr) > 300 else stderr
                        self.root.after(0, lambda: self.processing_error(f"{script} でエラーが発生しました:\n\n{error_msg}"))
                        return
                    
                    current_weight += weight
                    self.root.after(0, lambda op=(current_weight/total_weight)*100, d=description: 
                                    self.update_progress(op, 100, f"{d}完了"))
                    
                except Exception as e:
                    self.root.after(0, lambda e=e: self.processing_error(f"スクリプト実行中にエラーが発生しました:\n\n{str(e)}"))
                    return
                
                time.sleep(1)  # 視覚的な間隔
            
            if self.processing:
                # 全ての処理が完了
                os.chdir(original_cwd)
                self.root.after(0, self.processing_complete)
            else:
                os.chdir(original_cwd)
                
        except Exception as e:
            self.root.after(0, lambda: self.processing_error(f"処理中に予期しないエラーが発生しました:\n\n{str(e)}"))
    
    def processing_complete(self):
        self.run_button.config(state='normal')
        self.stop_button.config(state='disabled')
        self.processing = False
        self.update_progress(100, 100, "🎉 全ての処理が完了しました！")
        
        work_dir = self.dir_var.get()
        md_folder = os.path.join(work_dir, "md_folder")
        
        if os.path.exists(md_folder):
            file_count = len([f for f in os.listdir(md_folder) if f.endswith('.md')])
            
            # 結果ダイアログ
            result_text = f"処理が完了しました！\n\n"
            result_text += f"📝 生成されたMarkdownファイル: {file_count} 個\n"
            result_text += f"📁 保存場所: {md_folder}\n\n"
            result_text += "結果フォルダを開きますか？"
            
            if messagebox.askyesno("処理完了", result_text):
                try:
                    subprocess.run(["open", md_folder])
                except Exception as e:
                    messagebox.showwarning("警告", f"フォルダを開けませんでした: {e}")
        else:
            messagebox.showinfo("処理完了", "処理が完了しましたが、結果フォルダが見つかりません。")
    
    def processing_error(self, error_message):
        self.run_button.config(state='normal')
        self.stop_button.config(state='disabled')
        self.processing = False
        self.update_progress(0, 0, "❌ エラーが発生しました")
        
        messagebox.showerror("処理エラー", error_message)

def main():
    try:
        root = tk.Tk()
        app = DOIToolProgressGUI(root)
        root.mainloop()
    except ImportError:
        print("❌ tkinterが利用できません")
        print("コマンドライン版を使用してください: python3 progress_cli.py")
        return 1
    except Exception as e:
        print(f"❌ 予期しないエラー: {e}")
        return 1
    return 0

if __name__ == "__main__":
    sys.exit(main())
