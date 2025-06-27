# DOI Tool - macOS Application

ScopusのCSVファイルからMarkdownファイルを生成するmacOSアプリケーションです。

## 機能

- ScopusからエクスポートされたCSVファイルの統合
- DOI情報の取得（Crossref API使用）
- 参考文献の解決
- Markdownファイルの生成
- GUIによる簡単な操作

## システム要件

- macOS 10.14以降
- Python 3.8以降

## インストール方法

### 1. アプリケーションのビルド

```bash
cd app_build
chmod +x build_app.sh
./build_app.sh
```

### 2. 手動インストール

必要な依存関係をインストール：

```bash
pip3 install -r requirements.txt
```

アプリケーションをビルド：

```bash
python3 setup.py py2app
```

生成されたアプリケーションをApplicationsフォルダにコピー：

```bash
cp -R dist/gui_main.app "/Applications/DOI Tool.app"
```

## 使用方法

1. **DOI Tool.app** を起動
2. **作業ディレクトリ** を選択（ScopusのCSVファイルが入っているフォルダ）
3. ファイル一覧で処理対象のCSVファイルを確認
4. **処理を開始** ボタンをクリック
5. 処理完了後、`md_folder` にMarkdownファイルが生成されます

## 処理の流れ

1. **combine_scopus_csv.py**: 複数のCSVファイルを統合
2. **scopus_doi_to_json.py**: DOI情報を取得してJSONファイル生成
3. **json2tag_ref_scopus_async.py**: 参考文献を解決してMarkdownファイル生成
4. **add_abst_scopus.py**: DOIと要約をMarkdownファイルに追加

## ファイル構成

- `gui_main.py`: GUIアプリケーションのメインファイル
- `setup.py`: py2app用の設定ファイル
- `build_app.sh`: ビルド自動化スクリプト
- `requirements.txt`: 必要なPythonパッケージ一覧

## 注意事項

- インターネット接続が必要です（Crossref APIへのアクセスのため）
- 大量のDOIを処理する場合は時間がかかることがあります
- 処理中はアプリケーションを終了しないでください

## トラブルシューティング

### ビルドエラーが発生する場合

1. Xcodeコマンドラインツールがインストールされているか確認：
   ```bash
   xcode-select --install
   ```

2. Python環境を確認：
   ```bash
   python3 --version
   pip3 --version
   ```

### アプリケーションが起動しない場合

1. セキュリティ設定を確認
2. ターミナルから直接実行してエラーを確認：
   ```bash
   python3 gui_main.py
   ```

## ライセンス

MIT License

## 作成者

DOI Tool Project
