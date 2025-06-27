# DOI Tool - macOSアプリケーション化（tkinter問題対応版）

プロジェクトがmacOSアプリケーション化できるようにセットアップが完了しました！

## 🚀 クイックスタート

### 1. 実行権限を設定
```bash
cd app_build
chmod +x set_permissions.sh
./set_permissions.sh
```

### 2. インストール開始
```bash
./quick_install.sh
```

## 📱 実行方法（5つの選択肢）

### 1. スタンドアロンアプリ（推奨）
- **最も簡単で確実**
- tkinter問題を回避
- すぐに使用可能

### 2. py2app ビルド
- **完全版**
- 自動的に依存関係をインストール
- バイナリ形式でパッケージ化

### 3. GUI版（tkinter）
- **従来のGUI**
- tkinterが利用可能な場合のみ
- 直接Pythonから実行

### 4. コマンドライン版（tkinter不要）⭐️
- **tkinter問題を完全回避**
- ターミナル内で動作するGUI
- 同じ機能をコマンドライン形式で提供

### 5. tkinter問題の修正
- **Homebrew Python使用時の問題解決**
- python-tkパッケージの自動インストール
- システムPython代替案の提供

## 🎯 使用方法

### GUI版の場合：
1. **DOI Tool.app** を起動
2. **作業ディレクトリ**を選択（ScopusのCSVファイルがあるフォルダ）
3. **ファイル一覧を更新**でCSVファイルを確認
4. **処理を開始**ボタンをクリック
5. 完了後、`md_folder`にMarkdownファイルが生成されます

### コマンドライン版の場合：
1. `./quick_install.sh` → 4を選択
2. メニューから操作を選択
3. 作業ディレクトリを設定
4. CSVファイル一覧を確認
5. 処理を開始

## 🔧 tkinter問題について

macOSでHomebrew Pythonを使用している場合、tkinterが利用できないことがあります。

### 問題の症状：
```
ModuleNotFoundError: No module named '_tkinter'
```

### 解決方法：
1. **自動修正**（推奨）：
   ```bash
   ./quick_install.sh → 5を選択
   ```

2. **手動修正**：
   ```bash
   brew install python-tk
   ```

3. **コマンドライン版を使用**（tkinter不要）：
   ```bash
   ./quick_install.sh → 4を選択
   ```

## 📂 ファイル構成

```
app_build/
├── gui_main.py              # GUIアプリケーション（tkinter版）
├── cli_gui.py               # コマンドライン版GUI
├── setup.py                 # py2app設定
├── standalone_installer.py  # スタンドアロンアプリ作成
├── fix_tkinter.sh          # tkinter問題修正スクリプト
├── install_and_build.sh     # 完全自動ビルド
├── quick_install.sh         # 簡単インストール
├── requirements.txt         # 依存関係
└── INSTALL.md              # このファイル
```

## 🚨 トラブルシューティング

### 1. tkinterエラーが発生する場合
- コマンドライン版（選択肢4）を使用
- または tkinter修正（選択肢5）を実行

### 2. Pythonが見つからない場合
```bash
# Homebrewでインストール
brew install python3
```

### 3. 権限エラーが発生する場合
```bash
# 管理者権限で実行
sudo ./quick_install.sh
```

### 4. アプリが起動しない場合
1. セキュリティ設定を確認
2. コマンドライン版で動作確認
```bash
python3 cli_gui.py
```

## 🛠️ システム要件

- macOS 10.14以降
- Python 3.8以降
- インターネット接続（DOI解決のため）

## 📝 処理の流れ

1. **CSV統合**: 複数のScopus CSVファイルを統合
2. **DOI解決**: Crossref APIからメタデータを取得
3. **参考文献処理**: 引用文献のDOIを解決
4. **Markdown生成**: 構造化されたMarkdownファイルを生成

## 🌟 推奨実行方法

### 初回利用者：
```bash
./quick_install.sh → 4を選択（コマンドライン版）
```

### GUI好みの方：
```bash
./quick_install.sh → 1を選択（スタンドアロンアプリ）
```

### 開発者・上級者：
```bash
./quick_install.sh → 2を選択（py2app ビルド）
```

## 📧 サポート

問題が発生した場合は、以下の情報を確認してください：
- エラーログ (`error_log.txt`)
- システム環境（`python3 --version`）
- 入力ファイルの形式
- tkinterの利用可否（`python3 -c "import tkinter"`）

---

**🎉 tkinter問題を解決して、DOI Tool を使って効率的な文献管理を始めましょう！**
