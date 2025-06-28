#!/bin/bash

# emergency_run.sh - 緊急時実行スクリプト

echo "🆘 DOI Tool - 緊急時実行スクリプト"
echo "================================"
echo ""
echo "どの方法で実行しますか？"
echo ""
echo "1) 最もシンプルな実行（推奨）"
echo "2) コマンドライン版GUI"  
echo "3) 元のPythonスクリプト直接実行"
echo "4) 問題診断"
echo "5) 終了"
echo ""
echo -n "選択 (1-5): "
read choice

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

case $choice in
    1)
        echo ""
        echo "=== 最もシンプルな実行 ==="
        echo "Python3でシンプル実行スクリプトを起動します..."
        python3 "$SCRIPT_DIR/simple_run.py"
        ;;
    2)
        echo ""
        echo "=== コマンドライン版GUI ==="
        if [ -f "$SCRIPT_DIR/cli_gui.py" ]; then
            python3 "$SCRIPT_DIR/cli_gui.py"
        else
            echo "❌ cli_gui.py が見つかりません"
        fi
        ;;
    3)
        echo ""
        echo "=== 元のスクリプト直接実行 ==="
        echo "作業ディレクトリ（CSVファイルがあるフォルダ）を入力してください:"
        read work_dir
        
        if [ -d "$work_dir" ]; then
            echo "作業ディレクトリに移動します: $work_dir"
            cd "$work_dir"
            
            # 必要なスクリプトをコピー
            scripts=("combine_scopus_csv.py" "scopus_doi_to_json.py" "json2tag_ref_scopus_async.py" "add_abst_scopus.py")
            for script in "${scripts[@]}"; do
                if [ -f "$PROJECT_DIR/$script" ]; then
                    cp "$PROJECT_DIR/$script" .
                    echo "📄 $script をコピーしました"
                fi
            done
            
            echo ""
            echo "main.py を実行します..."
            python3 "$PROJECT_DIR/main.py"
        else
            echo "❌ ディレクトリが存在しません: $work_dir"
        fi
        ;;
    4)
        echo ""
        echo "=== 問題診断 ==="
        if [ -f "$SCRIPT_DIR/diagnose.sh" ]; then
            chmod +x "$SCRIPT_DIR/diagnose.sh"
            "$SCRIPT_DIR/diagnose.sh"
        else
            echo "❌ diagnose.sh が見つかりません"
            echo ""
            echo "手動診断:"
            echo "Python バージョン: $(python3 --version)"
            echo "Python パス: $(which python3)"
            echo "現在のディレクトリ: $(pwd)"
            echo "プロジェクトディレクトリ: $PROJECT_DIR"
        fi
        ;;
    5)
        echo "終了します"
        exit 0
        ;;
    *)
        echo "無効な選択です"
        exit 1
        ;;
esac
