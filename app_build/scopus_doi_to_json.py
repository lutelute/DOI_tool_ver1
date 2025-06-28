#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
scopus_combined.csv を読み込み、DOI から Crossref を取得して
JSON_folder/*.json を生成（ファイル名 = 論文タイトル）。
安定並列化対応版。
"""
import os, json, time, random, re, unicodedata
from urllib.parse import quote_plus
import pandas as pd, requests, requests_cache
from tqdm import tqdm
from concurrent.futures import ProcessPoolExecutor, as_completed

CSV_IN = "scopus_combined.csv"
JSON_DIR = "JSON_folder"
MAX_WORKERS = 10  # 並列数の上限（必要に応じて調整可）

requests_cache.install_cache("crossref_cache", expire_after=60*60*24*7)

SAFE_CHARS = "-_.() " + ''.join(chr(c) for c in range(0x30,0x3A)) + ''.join(chr(c) for c in range(0x41,0x5B)) + ''.join(chr(c) for c in range(0x61,0x7B))

def safe_filename(title: str, maxlen: int = 120) -> str:
    t = unicodedata.normalize('NFKC', title)
    cleaned = ''.join(ch if ch in SAFE_CHARS else '_' for ch in t)
    cleaned = re.sub(r'_+', '_', cleaned).strip('_')
    return cleaned[:maxlen] or "untitled"

def fetch_crossref(doi: str, retry: int = 3) -> dict:
    session = requests.Session()
    url = f"https://api.crossref.org/works/{quote_plus(doi)}"
    back = 0.5
    for _ in range(retry):
        try:
            r = session.get(url, timeout=15)
            r.raise_for_status()
            return r.json().get("message", {})
        except Exception:
            time.sleep(back + random.random() * 0.3)
            back *= 2
    return {}

def process_row(row: dict, base: str) -> str:
    doi = row.get("DOI", "").strip()
    title_csv = row.get("Title", row.get("タイトル", "")).strip()
    meta = fetch_crossref(doi) if doi else {}
    title = meta.get("title", [title_csv])[0] if meta else title_csv or "untitled"
    year = meta.get("created", {}).get("date-parts", [[None]])[0][0] or row.get("Year", row.get("出版年", ""))
    abstract = meta.get("abstract", row.get("Abstract", row.get("抄録", "")))
    refs = meta.get("reference", [])
    data = {
        "title": title,
        "year": year,
        "doi": doi,
        "abstract": re.sub(r'<.*?>', '', abstract).strip() if abstract else "",
        "references": refs
    }
    fname = safe_filename(title) + ".json"
    out_path = os.path.join(base, JSON_DIR, fname)
    with open(out_path, "w", encoding="utf-8") as fp:
        json.dump(data, fp, ensure_ascii=False, indent=2)
    return fname

def main():
    base = os.path.dirname(os.path.abspath(__file__))
    df = pd.read_csv(os.path.join(base, CSV_IN), dtype=str).fillna("")
    out_dir = os.path.join(base, JSON_DIR)
    os.makedirs(out_dir, exist_ok=True)

    rows = df.to_dict(orient="records")

    with ProcessPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = {executor.submit(process_row, row, base): row for row in rows}
        for f in tqdm(as_completed(futures), total=len(futures), desc="DOI→JSON 並列処理"):
            try:
                result = f.result()
                # print(f"生成: {result}")  # 必要に応じて出力
            except Exception as e:
                print(f"エラー発生: {e}")

    print("JSON 生成完了")

if __name__ == "__main__":
    main()