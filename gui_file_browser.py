理が正常に完了しました")
        
        self.cancel_btn.config(text="閉じる", bg='#27ae60')
        
        # 結果確認
        md_folder = os.path.join(self.work_dir, "md_folder")
        if os.path.exists(md_folder):
            file_count = len([f for f in os.listdir(md_folder) if f.endswith('.md')])
            self.log(f"📝 生成されたMarkdownファイル: {file_count}個")
            self.log(f"📁 保存場所: {md_folder}")
            
            # 結果ダイアログ
            if messagebox.askyesno("処理完了", f"処理が完了しました！\n\n📝 {file_count}個のMarkdownファイルが生成されました。\n\n結果フォルダを開きますか？"):
                subprocess.run(["open", md_folder])
                
        self.processing = False
        
    def processing_error(self, error_msg):
        """処理エラー"""
        self.progress_bar.stop()
        self.progress_label.config(text="❌ エラーが発生しました")
        self.log(f"💥 処理エラー: {error_msg}")
        
        self.cancel_btn.config(text="閉じる", bg='#e74c3c')
        
        messagebox.showerror("処理エラー", f"処理中にエラーが発生しました:\n\n{error_msg}")
        self.processing = False
        
    def cancel_processing(self):
        """処理キャンセル"""
        if self.processing:
            if messagebox.askyesno("確認", "処理をキャンセルしますか？"):
                self.processing = False
                self.window.destroy()
        else:
            self.window.destroy()

def main():
    """メイン関数"""
    try:
        root = tk.Tk()
        app = DOIToolFileBrowser(root)
        root.mainloop()
    except Exception as e:
        print(f"エラー: {e}")
        messagebox.showerror("起動エラー", f"アプリケーションの起動に失敗しました:\n{e}")
        return 1
    return 0

if __name__ == "__main__":
    sys.exit(main())
