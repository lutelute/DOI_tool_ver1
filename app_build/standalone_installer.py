#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
standalone_installer.py - DOI Tool スタンドアロンインストーラー
"""

import os
import sys
import shutil
import subprocess
from pathlib import Path

def create_standalone_app():
    """スタンドアロンアプリケーションを作成"""
    
    print("=== DOI Tool スタンドアロンアプリ作成 ===")
    
    # 現在のディレクトリ
    script_dir = Path(__file__).parent
    project_dir = script_dir.parent
    
    # アプリケーションディレクトリを作成
    app_name = "DOI Tool.app"
    app_dir = script_dir / "standalone" / app_name
    contents_dir = app_dir / "Contents"
    macos_dir = contents_dir / "MacOS"
    resources_dir = contents_dir / "Resources"
    
    # ディレクトリ構造を作成
    for directory in [app_dir, contents_dir, macos_dir, resources_dir]:
        directory.mkdir(parents=True, exist_ok=True)
    
    # Info.plist を作成
    info_plist = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>DOI_Tool</string>
    <key>CFBundleIdentifier</key>
    <string>com.doitool.app</string>
    <key>CFBundleName</key>
    <string>DOI Tool</string>
    <key>CFBundleDisplayName</key>
    <string>DOI処理ツール</string>
    <key>CFBundleVersion</key>
    <string>1.0.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>DOIT</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2025, DOI Tool</string>
</dict>
</plist>"""
    
    with open(contents_dir / "Info.plist", "w") as f:
        f.write(info_plist)
    
    # 実行スクリプトを作成
    executable_script = f"""#!/bin/bash
# DOI Tool 実行スクリプト

# アプリケーションのディレクトリを取得
APP_DIR="$(cd "$(dirname "${{BASH_SOURCE[0]}}")/.." && pwd)"
RESOURCES_DIR="$APP_DIR/Contents/Resources"

# Pythonパスを設定
export PYTHONPATH="$RESOURCES_DIR:$PYTHONPATH"

# Python3でGUIを起動
cd "$RESOURCES_DIR"
python3 gui_main.py
"""
    
    executable_path = macos_dir / "DOI_Tool"
    with open(executable_path, "w") as f:
        f.write(executable_script)
    
    # 実行可能権限を付与
    executable_path.chmod(0o755)
    
    # Python スクリプトとリソースをコピー
    files_to_copy = [
        "gui_main.py",
        "combine_scopus_csv.py",
        "scopus_doi_to_json.py", 
        "json2tag_ref_scopus_async.py",
        "add_abst_scopus.py",
        "requirements.txt"
    ]
    
    # GUI スクリプトをコピー
    shutil.copy2(script_dir / "gui_main.py", resources_dir)
    
    # その他のスクリプトをプロジェクトディレクトリからコピー
    for filename in files_to_copy[1:]:
        src_path = project_dir / filename
        if src_path.exists():
            shutil.copy2(src_path, resources_dir)
        else:
            print(f"警告: {filename} が見つかりません")
    
    print(f"✅ アプリケーションが作成されました: {app_dir}")
    return app_dir

def install_app(app_path):
    """アプリケーションをApplicationsフォルダにインストール"""
    
    applications_dir = Path("/Applications")
    app_name = app_path.name
    destination = applications_dir / app_name
    
    try:
        # 既存のアプリケーションを削除
        if destination.exists():
            print(f"既存の {app_name} を削除中...")
            shutil.rmtree(destination)
        
        # アプリケーションをコピー
        print(f"{app_name} をApplicationsフォルダにインストール中...")
        shutil.copytree(app_path, destination)
        
        print(f"✅ {app_name} がインストールされました")
        return True
        
    except PermissionError:
        print("❌ Applicationsフォルダへの書き込み権限がありません")
        print("手動でアプリケーションをApplicationsフォルダにコピーしてください")
        return False
    except Exception as e:
        print(f"❌ インストール中にエラーが発生しました: {e}")
        return False

def main():
    """メイン関数"""
    
    try:
        # スタンドアロンアプリケーションを作成
        app_path = create_standalone_app()
        
        # インストールするかユーザーに確認
        print("\\nApplicationsフォルダにインストールしますか？ (y/n): ", end="")
        response = input().strip().lower()
        
        if response == 'y' or response == 'yes':
            success = install_app(app_path)
            
            if success:
                print("\\n🎉 インストール完了！")
                print("Launchpadまたは /Applications フォルダから 'DOI Tool' を起動できます")
                
                # アプリケーションを起動するか確認
                print("\\nアプリケーションを今すぐ起動しますか？ (y/n): ", end="")
                launch_response = input().strip().lower()
                
                if launch_response == 'y' or launch_response == 'yes':
                    subprocess.run(["open", "/Applications/DOI Tool.app"])
            
        else:
            print(f"\\nアプリケーションは {app_path} に作成されました")
            print("手動でApplicationsフォルダにコピーしてください")
        
        print("\\n=== 使用方法 ===")
        print("1. DOI Tool を起動")
        print("2. 作業ディレクトリを選択（ScopusのCSVファイルが入っているフォルダ）")
        print("3. 'ファイル一覧を更新' でCSVファイルを確認") 
        print("4. '処理を開始' ボタンをクリック")
        print("5. 完了後、md_folder にMarkdownファイルが生成されます")
        
    except Exception as e:
        print(f"❌ エラーが発生しました: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main())
