#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
setup.py - DOI Tool macOS App Builder
"""

from setuptools import setup
import shutil
import os

# 元のスクリプトをコピー
project_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
scripts = [
    'combine_scopus_csv.py',
    'scopus_doi_to_json.py', 
    'json2tag_ref_scopus_async.py',
    'add_abst_scopus.py'
]

for script in scripts:
    src = os.path.join(project_dir, script)
    if os.path.exists(src):
        shutil.copy2(src, script)

APP = ['gui_main.py']
DATA_FILES = [
    ('scripts', scripts)
]

OPTIONS = {
    'argv_emulation': True,
    'plist': {
        'CFBundleName': 'DOI Tool',
        'CFBundleDisplayName': 'DOI処理ツール',
        'CFBundleGetInfoString': "Scopus DOI処理ツール v1.0",
        'CFBundleIdentifier': "com.doitool.app",
        'CFBundleVersion': "1.0.0",
        'CFBundleShortVersionString': "1.0.0",
        'NSHumanReadableCopyright': "Copyright © 2025, DOI Tool",
        'CFBundleDocumentTypes': [
            {
                'CFBundleTypeName': 'CSV Files',
                'LSItemContentTypes': ['public.comma-separated-values-text'],
                'LSHandlerRank': 'Owner'
            }
        ]
    },
    'packages': [],
    'includes': [
        'tkinter',
        'tkinter.filedialog',
        'tkinter.messagebox', 
        'tkinter.ttk',
        'pandas',
        'requests',
        'requests_cache',
        'tqdm',
        'nltk',
        'aiohttp',
        'asyncio',
        'concurrent.futures',
        'urllib.parse',
        'unicodedata',
        'hashlib',
        'threading',
        'subprocess',
        'pathlib',
        'shutil'
    ],
    'excludes': ['matplotlib', 'numpy'],
    'resources': [],
    'iconfile': 'icons/DOI_Tool.icns',
}

setup(
    app=APP,
    data_files=DATA_FILES,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)
