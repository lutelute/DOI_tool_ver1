#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
improved_json2tag_ref_scopus_async.py - 改良版（DOIからの適切なキーワード抽出とDOI情報追加）
"""

import os, json, re, unicodedata, asyncio, aiohttp, async_timeout
import time, random, hashlib, logging, traceback
from urllib.parse import quote_plus
from typing import Dict, List, Set

import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from tqdm import tqdm

# ---------- パラメータ ----------
SAFE_ASC = "-_.() " + "".join(chr(c) for c in range(0x30, 0x7B) if chr(c).isalnum())
STOP_POS = {"IN", "CC", "DT", "PRP", "WDT", "WP", "WP$", "VBZ", "VBP", "VBD", "VB", "VBG", "VBN", "RB", "TO"}
STOP_WORDS = {"am", "is", "are", "was", "were", "be", "being", "been", "not", "to", "the", "a", "an", "and", "or", "but", "in", "on", "at", "by", "for", "with", "about"}
MAX_CONC = 8
DELAY = 0.01
TIMEOUT = 15
MAILTO = "your_email@example.com"
HEAD_X = {"User-Agent": f"mdgen/2.0 (mailto:{MAILTO})"}
CHUNK_SIZE = 500

# ---------- ログ ----------
logging.basicConfig(filename="error_log.txt", filemode="a", level=logging.INFO,
                    format="%(asctime)s\tmdgen\t%(levelname)s\t%(message)s")

# ---------- 改良されたキーワード抽出 ----------
def extract_keywords_from_metadata(data: dict) -> List[str]:
    """メタデータから適切なキーワードを抽出"""
    keywords = set()
    
    # 1. 明示的なキーワード・サブジェクト
    if "subject" in data:
        subjects = data["subject"] if isinstance(data["subject"], list) else [data["subject"]]
        for subject in subjects:
            if isinstance(subject, str) and len(subject.strip()) > 2:
                keywords.add(clean_keyword(subject.strip().lower()))
    
    # 2. 分野・カテゴリ情報
    if "container-title" in data and data["container-title"]:
        journal = data["container-title"][0] if isinstance(data["container-title"], list) else data["container-title"]
        # 学術誌名から分野を推定
        journal_keywords = extract_field_from_journal(journal)
        keywords.update(journal_keywords)
    
    # 3. タイトルからの重要キーワード抽出
    if "title" in data and data["title"]:
        title = data["title"][0] if isinstance(data["title"], list) else data["title"]
        title_keywords = extract_important_keywords_from_text(title, max_keywords=5)
        keywords.update(title_keywords)
    
    # 4. 抄録からの重要キーワード抽出
    if "abstract" in data and data["abstract"]:
        abstract_keywords = extract_important_keywords_from_text(data["abstract"], max_keywords=8)
        keywords.update(abstract_keywords)
    
    # 5. 出版年
    if "published-print" in data or "published-online" in data or "created" in data:
        year = None
        if "published-print" in data and "date-parts" in data["published-print"]:
            year = data["published-print"]["date-parts"][0][0]
        elif "published-online" in data and "date-parts" in data["published-online"]:
            year = data["published-online"]["date-parts"][0][0]
        elif "created" in data and "date-parts" in data["created"]:
            year = data["created"]["date-parts"][0][0]
        
        if year:
            keywords.add(f"year_{year}")
    
    # 6. 論文タイプ
    if "type" in data:
        paper_type = data["type"].replace("-", "_").lower()
        keywords.add(f"type_{paper_type}")
    
    return list(keywords)

def extract_field_from_journal(journal_name: str) -> Set[str]:
    """学術誌名から研究分野を推定"""
    journal_lower = journal_name.lower()
    fields = set()
    
    field_indicators = {
        "ai": ["artificial intelligence", "ai", "machine learning", "neural", "computer science"],
        "medicine": ["medical", "medicine", "clinical", "health", "biomedical", "pharmaceutical"],
        "biology": ["biology", "biological", "life sciences", "molecular", "cellular", "genetics"],
        "chemistry": ["chemistry", "chemical", "analytical chemistry", "organic"],
        "physics": ["physics", "physical", "quantum", "optics", "mechanics"],
        "engineering": ["engineering", "ieee", "acm", "technical", "applied"],
        "psychology": ["psychology", "psychological", "cognitive", "behavioral"],
        "economics": ["economics", "economic", "finance", "business", "management"],
        "education": ["education", "educational", "learning", "teaching"],
        "environmental": ["environmental", "ecology", "climate", "sustainability"],
        "materials": ["materials", "nanotechnology", "advanced materials"],
        "energy": ["energy", "renewable", "solar", "battery", "fuel"],
    }
    
    for field, indicators in field_indicators.items():
        if any(indicator in journal_lower for indicator in indicators):
            fields.add(f"field_{field}")
    
    return fields

def extract_important_keywords_from_text(text: str, max_keywords: int = 5) -> Set[str]:
    """テキストから重要なキーワードを抽出"""
    if not text:
        return set()
    
    try:
        # NLTKの準備
        try:
            stop_words = set(stopwords.words('english'))
        except LookupError:
            stop_words = STOP_WORDS
        
        try:
            lemmatizer = WordNetLemmatizer()
        except LookupError:
            lemmatizer = None
        
        # トークン化
        tokens = word_tokenize(text.lower())
        
        # POS tagging
        try:
            pos_tags = nltk.pos_tag(tokens)
        except LookupError:
            # POS taggerが利用できない場合は単純な処理
            pos_tags = [(token, 'NN') for token in tokens if token.isalpha()]
        
        # 重要な単語の抽出
        important_words = []
        
        for word, pos in pos_tags:
            # 条件：名詞、形容詞、または重要な動詞
            if (pos.startswith('NN') or pos.startswith('JJ') or pos in ['VB', 'VBN']) and \
               len(word) > 3 and \
               word.isalpha() and \
               word not in stop_words and \
               word not in STOP_WORDS:
                
                # 語幹化
                if lemmatizer:
                    word = lemmatizer.lemmatize(word)
                
                important_words.append(word)
        
        # 頻度による重要度計算
        word_freq = {}
        for word in important_words:
            word_freq[word] = word_freq.get(word, 0) + 1
        
        # 重要度の高い単語を選択
        sorted_words = sorted(word_freq.items(), key=lambda x: x[1], reverse=True)
        
        keywords = set()
        for word, freq in sorted_words[:max_keywords]:
            if len(word) > 2:  # 最小長さチェック
                keywords.add(clean_keyword(word))
        
        return keywords
        
    except Exception as e:
        logging.error(f"KEYWORD_EXTRACT_ERROR\t{e}")
        return set()

def clean_keyword(keyword: str) -> str:
    """キーワードをクリーンアップ"""
    # 特殊文字を除去し、アンダースコアで区切り文字を統一
    cleaned = re.sub(r'[^\w\s-]', '', keyword)
    cleaned = re.sub(r'[\s-]+', '_', cleaned)
    cleaned = cleaned.strip('_').lower()
    
    # 長すぎるキーワードは短縮
    if len(cleaned) > 20:
        cleaned = cleaned[:20]
    
    return cleaned

def create_doi_info_section(data: dict) -> str:
    """DOI情報セクションを作成"""
    doi_section = ""
    
    # DOI
    if "DOI" in data:
        doi_section += f"**DOI:** {data['DOI']}\n"
    
    # 出版情報
    if "container-title" in data and data["container-title"]:
        journal = data["container-title"][0] if isinstance(data["container-title"], list) else data["container-title"]
        doi_section += f"**Journal:** {journal}\n"
    
    # 出版年
    year = None
    if "published-print" in data and "date-parts" in data["published-print"]:
        year = data["published-print"]["date-parts"][0][0]
    elif "published-online" in data and "date-parts" in data["published-online"]:
        year = data["published-online"]["date-parts"][0][0]
    elif "created" in data and "date-parts" in data["created"]:
        year = data["created"]["date-parts"][0][0]
    
    if year:
        doi_section += f"**Year:** {year}\n"
    
    # 著者情報
    if "author" in data and data["author"]:
        authors = []
        for author in data["author"][:3]:  # 最初の3人まで
            if "family" in author:
                name = f"{author.get('given', '')} {author['family']}".strip()
                authors.append(name)
        if authors:
            author_text = ", ".join(authors)
            if len(data["author"]) > 3:
                author_text += " et al."
            doi_section += f"**Authors:** {author_text}\n"
    
    # 論文タイプ
    if "type" in data:
        paper_type = data["type"].replace("-", " ").title()
        doi_section += f"**Type:** {paper_type}\n"
    
    return doi_section

# ---------- ヘルパ関数 ----------
def safe_fn(title: str, maxlen: int = 120) -> str:
    norm = unicodedata.normalize("NFKC", title)
    s = "".join(ch for ch in norm if ch in SAFE_ASC)
    s = re.sub(r"\s+", "_", s).strip("_")
    s = re.sub(r"_+", "_", s)[:maxlen]
    return s or hashlib.md5(title.encode()).hexdigest()[:maxlen]

def ensure_nltk():
    for res in [("tokenizers/punkt", "punkt"),
                ("taggers/averaged_perceptron_tagger_eng", "averaged_perceptron_tagger_eng"),
                ("corpora/stopwords", "stopwords"),
                ("corpora/wordnet", "wordnet")]:
        try:
            nltk.data.find(res[0])
        except LookupError:
            try:
                nltk.download(res[1], quiet=True)
            except:
                pass

def chunk_list(lst, n):
    """リストを n 件ごとに分割"""
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

# ---------- 非同期 DOI 解決 ----------
async def fetch_doi_titles(dois: Set[str]) -> Dict[str, str]:
    out = {d: "Unknown" for d in dois}
    sem = asyncio.Semaphore(MAX_CONC)

    async with aiohttp.ClientSession() as sess:
        async def fetch_one(doi):
            try:
                async with sem, async_timeout.timeout(TIMEOUT):
                    r = await sess.get(f"https://api.crossref.org/works/{quote_plus(doi)}", headers=HEAD_X)
                    if r.status == 200:
                        js = await r.json()
                        out[doi] = js["message"].get("title", ["Unknown"])[0]
                        return
            except:
                pass
            try:
                async with sem, async_timeout.timeout(TIMEOUT):
                    r = await sess.get(f"https://doi.org/{quote_plus(doi)}",
                                       headers={"Accept": "application/vnd.citationstyles.csl+json", **HEAD_X})
                    if r.status == 200:
                        js = await r.json()
                        out[doi] = js.get("title", "Unknown")
            except:
                pass

        tasks = [fetch_one(d) for d in dois]
        for f in tqdm(asyncio.as_completed(tasks), total=len(tasks), desc="DOI 解決"):
            await f
            await asyncio.sleep(DELAY)

    return out

# ---------- メイン ----------
def main():
    try:
        print("improved_json2tag_ref_scopus_async.py の実行開始")
        ensure_nltk()
        base = os.path.dirname(os.path.abspath(__file__))
        jdir = os.path.join(base, "JSON_folder")
        mdir = os.path.join(base, "md_folder")
        os.makedirs(mdir, exist_ok=True)

        files = [f for f in os.listdir(jdir) if f.endswith(".json")]
        print(f"{len(files)} 件の JSON ファイルを処理します")

        ref_dois: Set[str] = set()
        for jf in files:
            try:
                data = json.load(open(os.path.join(jdir, jf)))
                for r in data.get("references", []):
                    if isinstance(r, dict) and r.get("DOI"):
                        ref_dois.add(r["DOI"].lower())
            except Exception as e:
                logging.error(f"SCAN_ERR\t{jf}\t{e}")

        doi2title: Dict[str, str] = {}
        if os.path.exists("doi_title_cache.json"):
            doi2title.update(json.load(open("doi_title_cache.json")))

        need = list(ref_dois - doi2title.keys())
        print(f"解決必要 DOI 数: {len(need)}")

        for i, chunk in enumerate(chunk_list(need, CHUNK_SIZE), 1):
            print(f"=== DOI チャンク {i} / {((len(need)-1)//CHUNK_SIZE)+1} 開始 ===")
            res = asyncio.run(fetch_doi_titles(set(chunk)))
            doi2title.update(res)
            with open("doi_title_cache.json", "w", encoding="utf-8") as fp:
                json.dump(doi2title, fp, ensure_ascii=False, indent=0)

        bar = tqdm(total=len(files), desc="MD 生成")
        for jf in files:
            try:
                data = json.load(open(os.path.join(jdir, jf), encoding="utf-8"))
                ttl = data.get("title", "")
                
                if not ttl:
                    bar.update(1)
                    continue

                # 改良されたキーワード抽出
                keywords = extract_keywords_from_metadata(data)
                
                # タグ行を作成（重複除去とソート）
                unique_keywords = sorted(set(keywords))
                tag_line = "#" + " #".join(unique_keywords) if unique_keywords else "#untagged"

                md_p = os.path.join(mdir, safe_fn(ttl) + ".md")
                with open(md_p, "w", encoding="utf-8") as fp:
                    # タグ
                    fp.write(tag_line)
                    
                    # DOI情報セクション
                    fp.write("\n\n## DOI Information\n\n")
                    doi_info = create_doi_info_section(data)
                    if doi_info:
                        fp.write(doi_info)
                    else:
                        fp.write("DOI情報が利用できません\n")
                    
                    # 抄録
                    fp.write("\n## Abstract\n\n")
                    abstract = data.get("abstract", "")
                    if abstract:
                        # HTMLタグを除去
                        clean_abstract = re.sub(r'<.*?>', '', abstract).strip()
                        fp.write(clean_abstract)
                    else:
                        fp.write("抄録が利用できません")

                refs = data.get("references", [])
                with open(md_p, "a", encoding="utf-8") as fp:
                    if refs:
                        fp.write("\n\n## 参考文献\n\n")
                        for r in refs:
                            if isinstance(r, dict):
                                art = r.get("article-title")
                                doi = r.get("DOI", "").lower()
                                if doi:
                                    title = art or doi2title.get(doi, "Unknown")
                                    safe_title = safe_fn(title)
                                    fp.write(f"- DOI: {doi}\n  - [[{safe_title}]]\n")
                                else:
                                    safe_title = safe_fn(art or "Unknown")
                                    fp.write(f"- [[{safe_title}]]\n")
                            else:
                                safe_title = safe_fn(str(r))
                                fp.write(f"- [[{safe_title}]]\n")
                bar.update(1)
            except Exception as e:
                logging.error(f"MD_ERR\t{jf}\t{e}")
                bar.update(1)

        bar.close()
        print("Markdown 完了")
    except Exception:
        logging.error(f"FATAL\n{traceback.format_exc()}")

if __name__ == "__main__":
    main()
