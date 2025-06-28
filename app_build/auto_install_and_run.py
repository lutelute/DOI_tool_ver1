#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
auto_install_and_run.py - 自動依存関係インストール＆DOI Tool起動
"""

import os
import sys
import subprocess
import importlib

def install_package(package_name, import_name=None):
    """パッケージをインストール"""
    if import_name is None:
        import_name = package_name
    
    try:
        importlib.import_module(import_name)
        print(f"✅ {package_name} は既にインストールされています")
        return True
    except ImportError:
        print(f"📦 {package_name} をインストール中...")
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", package_name])
            print(f"✅ {package_name} のインストール完了")
            return True
        except subprocess.CalledProcessError:
            print(f"❌ {package_name} のインストールに失敗しました")
            return False

def install_required_packages():
    """必要なパッケージを全て自動インストール"""
    print("🔧 必要なパッケージの確認・インストール")
    print("=" * 50)
    
    # 必要なパッケージのリスト
    packages = [
        ("pandas", "pandas"),
        ("requests", "requests"),
        ("requests-cache", "requests_cache"),
        ("tqdm", "tqdm"),
        ("nltk", "nltk"),
        ("aiohttp", "aiohttp"),
        ("async-timeout", "async_timeout"),
    ]
    
    failed_packages = []
    
    for package_name, import_name in packages:
        if not install_package(package_name, import_name):
            failed_packages.append(package_name)
    
    # tkinterの確認（標準ライブラリなのでインストール不要）
    try:
        import tkinter
        print("✅ tkinter が利用可能です")
        tkinter_available = True
    except ImportError:
        print("⚠️  tkinter が利用できません（GUI版は使用不可）")
        tkinter_available = False
    
    # NLTKデータのダウンロード
    print("\n📚 NLTK データのダウンロード...")
    try:
        import nltk
        # 必要なNLTKデータをダウンロード
        nltk_data = [
            'punkt',
            'averaged_perceptron_tagger',
            'averaged_perceptron_tagger_eng',
            'stopwords',
            'wordnet',
            'omw-1.4'
        ]
        
        for data in nltk_data:
            try:
                nltk.data.find(f'tokenizers/{data}')
            except LookupError:
                try:
                    nltk.data.find(f'taggers/{data}')
                except LookupError:
                    try:
                        nltk.data.find(f'corpora/{data}')
                    except LookupError:
                        try:
                            print(f"📦 NLTK {data} をダウンロード中...")
                            nltk.download(data, quiet=True)
                        except:
                            print(f"⚠️  NLTK {data} のダウンロードに失敗")
    except Exception as e:
        print(f"⚠️  NLTK データのダウンロードでエラー: {e}")
    
    print("\n" + "=" * 50)
    
    if failed_packages:
        print(f"❌ 以下のパッケージのインストールに失敗しました: {', '.join(failed_packages)}")
        print("手動でインストールしてください:")
        for pkg in failed_packages:
            print(f"  pip3 install {pkg}")
        return False, tkinter_available
    else:
        print("✅ 全ての依存関係のインストールが完了しました！")
        return True, tkinter_available

def show_main_menu(tkinter_available):
    """メインメニューを表示"""
    print("\n" + "🔬 DOI Tool - 自動セットアップ版")
    print("=" * 60)
    print("\n📋 利用可能な実行方法:")
    print("\n🎯 推奨版:")
    print("1) ファイルブラウザ付きCLI版 - Finderライク操作")
    print("2) 進捗バー付きCLI版 - 美しい進捗表示")
    
    if tkinter_available:
        print("\n🖥️  GUI版:")
        print("3) ファイルブラウザ付きGUI版 - 視覚的ファイル選択")
        print("4) 進捗バー付きGUI版 - リアルタイム進捗")
        print("5) 基本GUI版 - シンプルなGUI")
    else:
        print("\n🖥️  GUI版: ❌ tkinter利用不可")
    
    print("\n🔧 その他:")
    print("6) シンプル実行版 - 最小限の機能")
    print("7) 緊急時実行版 - トラブル時用")
    print("8) 終了")
    
    print("\n" + "=" * 60)
    
    while True:
        try:
            choice = input("\n選択 (1-8): ").strip()
            choice_num = int(choice)
            
            if 1 <= choice_num <= 8:
                return choice_num
            else:
                print("❌ 1-8の数字を入力してください")
        except ValueError:
            print("❌ 数字を入力してください")

def run_selected_tool(choice, script_dir):
    """選択されたツールを実行"""
    try:
        if choice == 1:
            print("\n🔍 ファイルブラウザ付きCLI版を起動します...")
            subprocess.run([sys.executable, os.path.join(script_dir, "file_browser.py")])
        
        elif choice == 2:
            print("\n📊 進捗バー付きCLI版を起動します...")
            subprocess.run([sys.executable, os.path.join(script_dir, "progress_cli.py")])
        
        elif choice == 3:
            print("\n🖥️  ファイルブラウザ付きGUI版を起動します...")
            subprocess.run([sys.executable, os.path.join(script_dir, "gui_file_browser.py")])
        
        elif choice == 4:
            print("\n📊 進捗バー付きGUI版を起動します...")
            subprocess.run([sys.executable, os.path.join(script_dir, "gui_progress.py")])
        
        elif choice == 5:
            print("\n🖥️  基本GUI版を起動します...")
            subprocess.run([sys.executable, os.path.join(script_dir, "gui_main.py")])
        
        elif choice == 6:
            print("\n🔧 シンプル実行版を起動します...")
            subprocess.run([sys.executable, os.path.join(script_dir, "simple_run.py")])
        
        elif choice == 7:
            print("\n🆘 緊急時実行版を起動します...")
            emergency_script = os.path.join(script_dir, "emergency_run.sh")
            if os.path.exists(emergency_script):
                subprocess.run(["bash", emergency_script])
            else:
                print("❌ emergency_run.sh が見つかりません")
        
        elif choice == 8:
            print("\n👋 DOI Toolを終了します")
            return False
        
        return True
        
    except FileNotFoundError as e:
        print(f"❌ ファイルが見つかりません: {e}")
        print("💡 app_buildディレクトリ内で実行していることを確認してください")
        return False
    except Exception as e:
        print(f"❌ 実行中にエラーが発生しました: {e}")
        return False

def main():
    """メイン関数"""
    print("🚀 DOI Tool - 自動セットアップ & 起動")
    print("=" * 60)
    
    # スクリプトのディレクトリを取得
    script_dir = os.path.dirname(os.path.abspath(__file__))
    print(f"📁 実行ディレクトリ: {script_dir}")
    
    # 依存関係のインストール
    success, tkinter_available = install_required_packages()
    
    if not success:
        print("\n❌ 依存関係のインストールに失敗しました")
        print("手動でパッケージをインストールしてから再実行してください")
        return 1
    
    # メインループ
    while True:
        choice = show_main_menu(tkinter_available)
        
        if not run_selected_tool(choice, script_dir):
            break
    
    return 0

if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print("\n\n👋 プログラムを終了します")
        sys.exit(0)
    except Exception as e:
        print(f"\n❌ 予期しないエラー: {e}")
        sys.exit(1)
