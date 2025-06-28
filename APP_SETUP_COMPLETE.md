# 🚀 DOI Tool macOSアプリ - セットアップ完了

DOI Tool のmacOSアプリケーションが完成しました！このツールは、ScopusのCSVエクスポートファイルからMarkdownファイルを自動生成する強力なアプリケーションです。

## 📱 アプリケーション情報

- **アプリ名**: DOI処理ツール (DOI Tool)
- **バージョン**: 1.0.0
- **バンドルID**: com.doitool.app
- **場所**: `app_build/standalone/DOI Tool.app`

## 🎯 主要機能

1. **CSVファイル統合**: 複数のScopus CSVファイルを統合
2. **DOI解決**: CrossrefAPIを使用してDOI情報を取得
3. **参考文献処理**: 引用関係の解析とリンク生成
4. **Markdown生成**: 構造化されたMarkdownファイルの自動生成

## 🚀 クイックスタート

### 1. セットアップ（初回のみ）
```bash
# プロジェクトディレクトリに移動
cd /Users/shigenoburyuto/Documents/GitHub/DOI_tool_ver1

# 実行権限設定
chmod +x fix_permissions.sh
./fix_permissions.sh

# 完全セットアップ実行
./complete_setup.sh
```

### 2. アプリケーション起動
```bash
# アプリケーションを開く
open "app_build/standalone/DOI Tool.app"

# または、Finderから直接起動
# DOI Tool.app をダブルクリック
```

### 3. 使用方法
1. アプリが起動したら「作業ディレクトリ」を選択
2. ScopusからエクスポートしたCSVファイルが含まれるフォルダを指定
3. 「ファイル一覧を更新」でCSVファイルを確認
4. 「処理を開始」ボタンをクリック
5. 処理完了後、`md_folder`にMarkdownファイルが生成されます

## 🔧 メンテナンス・トラブルシューティング

### 診断スクリプト
```bash
# システム状態とアプリの診断
./diagnose_app.sh
```

### 手動でのアプリテスト
```bash
# アプリケーションの動作テスト
./test_app.sh
```

### 直接Python実行（デバッグ用）
```bash
# GUIを直接起動
python3 app_build/standalone/DOI\ Tool.app/Contents/Resources/gui_main.py
```

## 📁 プロジェクト構造

```
DOI_tool_ver1/
├── 📱 app_build/standalone/DOI Tool.app/     # macOSアプリケーション
│   ├── Contents/
│   │   ├── Info.plist                        # アプリ情報
│   │   ├── MacOS/DOI_Tool                    # 実行スクリプト
│   │   └── Resources/                        # Pythonスクリプト
│   │       ├── gui_main.py                   # メインGUI
│   │       ├── combine_scopus_csv.py         # CSV統合
│   │       ├── scopus_doi_to_json.py         # DOI処理
│   │       ├── json2tag_ref_scopus_async.py  # 参考文献処理
│   │       ├── add_abst_scopus.py            # 要約追加
│   │       └── DOI_Tool.icns                 # アプリアイコン
│
├── 🎨 app_build/icons/                       # アイコンファイル
│   ├── DOI_Tool.icns                         # macOS用アイコン
│   ├── DOI_Tool.iconset/                     # アイコンセット
│   └── doi_tool_icon.svg                     # ベクターアイコン
│
├── 🔧 セットアップスクリプト
│   ├── complete_setup.sh                     # 完全セットアップ
│   ├── fix_permissions.sh                    # 権限修正
│   ├── diagnose_app.sh                       # 診断ツール
│   ├── test_app.sh                           # アプリテスト
│   └── setup_icon.sh                         # アイコン設定
│
└── 📚 コアスクリプト                         # 元のPythonスクリプト
    ├── main.py                               # パイプライン実行
    ├── combine_scopus_csv.py                 # CSV統合
    ├── scopus_doi_to_json.py                 # DOI→JSON変換
    ├── json2tag_ref_scopus_async.py          # 参考文献処理
    └── add_abst_scopus.py                    # 要約追加
```

## 🎨 アイコンについて

美しいグラデーションと現代的なデザインのアイコンが設定されています：
- **デザイン**: ペーパースタック + DOIテキスト + 接続線
- **カラー**: ブルーグラデーション背景 + 赤い接続エフェクト
- **形式**: .icns (macOS標準) + .svg (ベクター)
- **サイズ**: 16x16から1024x1024まで対応

## 📋 システム要件

### 必須
- **OS**: macOS 10.14以上
- **Python**: 3.8以上
- **インターネット**: DOI解決に必要

### Python依存関係
```bash
pip3 install pandas requests requests_cache tqdm
```

### オプション
- **tkinter**: GUI表示（通常はPythonに含まれる）

## 🔄 処理フロー

```
1. CSVファイル読込 → 2. 統合処理 → 3. DOI抽出 → 4. API呼出
                                                        ↓
8. 完了通知 ← 7. MD生成 ← 6. 参考文献解決 ← 5. JSON保存
```

1. **combine_scopus_csv.py**: 複数CSVを`scopus_combined.csv`に統合
2. **scopus_doi_to_json.py**: DOIからCrossref APIで論文情報取得、JSONに保存
3. **json2tag_ref_scopus_async.py**: 参考文献の解決とタグ生成
4. **add_abst_scopus.py**: 要約情報の追加とMarkdown最終化

## 🚨 よくある問題と対処法

### アプリが起動しない
```bash
# Python環境確認
python3 --version
python3 -c "import tkinter"

# 直接実行でテスト
python3 "app_build/standalone/DOI Tool.app/Contents/Resources/gui_main.py"
```

### アイコンが表示されない
```bash
# Dockを再起動
killall Dock

# アイコンキャッシュクリア
./setup_icon.sh
```

### 処理が失敗する
1. **ネットワーク接続**を確認
2. **CSVファイル形式**がScopusエクスポート形式か確認
3. **ディスク容量**を確認（大量のファイル生成のため）

### 権限エラー
```bash
# 全権限を再設定
./fix_permissions.sh
```

## 📞 サポート・開発情報

### ログの確認
アプリ実行時のエラーはコンソール.appで確認できます：
```
/Applications/Utilities/Console.app
```

### 開発モード
```bash
# 開発用に直接実行
cd app_build
python3 gui_main.py
```

### カスタマイズ
- **アイコン変更**: `app_build/icons/`のファイルを編集
- **GUI修正**: `gui_main.py`を編集
- **処理ロジック**: 各Pythonスクリプトを修正

## 🎉 完成！

これで DOI Tool macOSアプリは完全に使用可能な状態です！

### 次のステップ
1. `./complete_setup.sh` を実行してセットアップ完了
2. アプリを起動して動作確認
3. 実際のScopus CSVファイルで処理テスト

### 配布用
アプリを他のMacに配布する場合：
1. `DOI Tool.app` をコピー
2. 受取側でPython3とpip依存関係をインストール
3. 初回起動時に必要に応じて権限許可

**素晴らしいアプリケーションが完成しました！🎊**
