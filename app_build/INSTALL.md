# DOI Tool - macOSアプリケーション化

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

## 📱 インストール方法

### 方法1: スタンドアロンアプリ（推奨）
- **最も簡単**
- 依存関係のインストール不要
- すぐに使用可能

```bash
./quick_install.sh
# → 1を選択
```

### 方法2: py2app ビルド
- **完全版**
- 自動的に依存関係をインストール
- バイナリ形式でパッケージ化

```bash
./quick_install.sh
# → 2を選択
```

### 方法3: 開発モード
- **開発・テスト用**
- Pythonから直接実行

```bash
./quick_install.sh
# → 3を選択
```

## 🎯 使用方法

1. **DOI Tool.app** を起動
2. **作業ディレクトリ**を選択（ScopusのCSVファイルがあるフォルダ）
3. **ファイル一覧を更新**でCSVファイルを確認
4. **処理を開始**ボタンをクリック
5. 完了後、`md_folder`にMarkdownファイルが生成されます

## 📂 ファイル構成

```
app_build/
├── gui_main.py              # GUIアプリケーション
├── setup.py                 # py2app設定
├── standalone_installer.py  # スタンドアロンアプリ作成
├── install_and_build.sh     # 完全自動ビルド
├── quick_install.sh         # 簡単インストール
├── requirements.txt         # 依存関係
└── README.md               # このファイル
```

## 🔧 特徴

- **GUIアプリケーション**: 使いやすいグラフィカルインターフェース
- **ドラッグ&ドロップ**: CSVファイルの簡単な処理
- **プログレス表示**: 処理状況をリアルタイムで確認
- **エラーハンドリング**: 問題が発生した場合の適切な通知
- **結果表示**: 処理完了後の自動フォルダ表示

## 🛠️ システム要件

- macOS 10.14以降
- Python 3.8以降
- インターネット接続（DOI解決のため）

## 🚨 トラブルシューティング

### Pythonが見つからない場合
```bash
# Homebrewでインストール
brew install python3
```

### 権限エラーが発生する場合
```bash
# 管理者権限で実行
sudo ./quick_install.sh
```

### アプリが起動しない場合
1. セキュリティ設定を確認
2. ターミナルから直接実行してエラーを確認
```bash
python3 gui_main.py
```

## 📝 処理の流れ

1. **CSV統合**: 複数のScopus CSVファイルを統合
2. **DOI解決**: Crossref APIからメタデータを取得
3. **参考文献処理**: 引用文献のDOIを解決
4. **Markdown生成**: 構造化されたMarkdownファイルを生成

## 📧 サポート

問題が発生した場合は、以下の情報を確認してください：
- エラーログ (`error_log.txt`)
- システム環境
- 入力ファイルの形式

---

**🎉 DOI Tool を使って効率的な文献管理を始めましょう！**
