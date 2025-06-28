# 🔧 DOI Tool GUI問題解決ガイド

GUI（ユーザーインターフェース）が表示されない問題の解決方法をまとめました。

## 🎯 問題の症状

- アプリを起動してもウィンドウが表示されない
- フォルダ選択ダイアログが開かない
- エラーメッセージが表示される

## 🚀 クイック解決方法

### ステップ1: クイック診断実行
```bash
cd /Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1
chmod +x quick_gui_fix.sh
./quick_gui_fix.sh
```

### ステップ2: デバッグ版GUI起動
```bash
python3 gui_main_debug.py
```

### ステップ3: 問題が続く場合
```bash
./fix_gui_problems.sh
```

## 🔍 詳細な原因と対処法

### 原因1: tkinter（GUI ライブラリ）の問題

**症状**: `ImportError: No module named '_tkinter'`

**解決方法**:
```bash
# Homebrew でtkinter インストール
brew install python-tk

# または pyenv でtkinter付きPython再インストール
pyenv install 3.11.x
pyenv global 3.11.x
```

### 原因2: Python環境の問題

**症状**: Pythonは動くがGUIが表示されない

**解決方法**:
```bash
# システムPython使用
/usr/bin/python3 gui_main_debug.py

# または現在のPython確認
which python3
python3 --version
```

### 原因3: macOS権限の問題

**症状**: ファイルダイアログが開かない

**解決方法**:
1. システム環境設定 → セキュリティとプライバシー
2. プライバシー → ファイルとフォルダ
3. ターミナルに権限を付与

### 原因4: アプリバンドルの問題

**症状**: アプリを開いても何も起こらない

**解決方法**:
```bash
# アプリ内GUIを修正版に置換
cp gui_main_debug.py "app_build/standalone/DOI Tool.app/Contents/Resources/gui_main.py"

# アプリのタイムスタンプ更新
touch "app_build/standalone/DOI Tool.app"
```

## 🧪 各種テスト方法

### 基本GUIテスト
```bash
python3 -c "
import tkinter as tk
root = tk.Tk()
root.title('テスト')
tk.Label(root, text='GUI動作中').pack()
root.mainloop()
"
```

### ファイルダイアログテスト
```bash
python3 -c "
from tkinter import filedialog
import tkinter as tk
root = tk.Tk()
root.withdraw()
folder = filedialog.askdirectory()
print(f'選択: {folder}')
"
```

### フル機能テスト
```bash
python3 gui_main_debug.py
```

## 📋 利用可能なスクリプト

| スクリプト | 用途 |
|------------|------|
| `quick_gui_fix.sh` | クイック診断・修正 |
| `diagnose_gui.sh` | 詳細システム診断 |
| `fix_gui_problems.sh` | 包括的問題解決 |
| `gui_main_debug.py` | デバッグ情報付きGUI |

## 🎯 推奨解決順序

1. **クイック診断**: `./quick_gui_fix.sh`
2. **デバッグ実行**: `python3 gui_main_debug.py`
3. **権限確認**: システム環境設定確認
4. **環境修正**: tkinter・Python環境修正
5. **アプリ修正**: アプリ内GUIスクリプト置換

## 💡 よくある解決例

### ケース1: Homebrew Python使用時
```bash
brew install python-tk
python3 gui_main_debug.py  # 成功
```

### ケース2: システムPython使用時
```bash
/usr/bin/python3 gui_main_debug.py  # 成功
```

### ケース3: 権限問題時
```bash
# システム環境設定でターミナルに権限付与後
python3 gui_main_debug.py  # 成功
```

## 🚨 エラーメッセージ別対処法

### `ModuleNotFoundError: No module named '_tkinter'`
→ `brew install python-tk`

### `TclError: couldn't connect to display`
→ ローカルで実行、SSH接続時は `-X` オプション

### ウィンドウが表示されない（エラーなし）
→ Dockで確認、Command+Tab で切り替え

### ファイルダイアログが開かない
→ システム環境設定で権限確認

## ✅ 解決確認方法

1. デバッグ版GUIが正常に表示される
2. 「テスト」ボタンでダイアログが開く
3. フォルダ選択が正常に動作する
4. CSVファイル一覧が表示される

これらすべてが正常動作すれば、GUI問題は解決です！

## 📞 まだ解決しない場合

上記すべてを試しても解決しない場合は、以下の情報を確認してください：

```bash
# システム情報
sw_vers
python3 --version
which python3

# エラー詳細
python3 gui_main_debug.py 2>&1 | tee gui_error.log
```

この情報とともに、具体的なエラーメッセージを教えてください。
