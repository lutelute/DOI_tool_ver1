# 🔬 DOI Tool - Comprehensive Scopus Processing Suite

A powerful, multi-interface tool for processing Scopus CSV exports and generating structured Markdown files with DOI resolution and reference linking.

## ✨ Features

### 🎯 Multiple User Interfaces
- **🖥️ GUI Version**: User-friendly graphical interface with tkinter
- **💻 CLI Version**: Interactive terminal-based interface  
- **📊 Progress Bar Versions**: Real-time progress tracking
- **🔍 File Browser Versions**: Finder-like file selection
- **📱 macOS App**: Standalone .app bundle for easy distribution

### 🔄 Core Functionality
- **📄 CSV Processing**: Combine multiple Scopus CSV exports
- **🔗 DOI Resolution**: Fetch metadata via Crossref API
- **📚 Reference Linking**: Process and link citations
- **📝 Markdown Generation**: Create structured documentation
- **🏷️ Tag Generation**: Automatic keyword tagging

## 🚀 Quick Start

### Option 1: File Browser Version (Recommended)
```bash
cd app_build
chmod +x quick_file_browser.sh
./quick_file_browser.sh
```

### Option 2: Progress Bar Version
```bash
cd app_build  
chmod +x quick_progress.sh
./quick_progress.sh
```

### Option 3: Simple Installation
```bash
cd app_build
chmod +x quick_install.sh
./quick_install.sh
```

## 📁 Project Structure

```
DOI_tool_ver1/
├── 🔬 Core Scripts
│   ├── main.py                     # Main pipeline orchestrator
│   ├── combine_scopus_csv.py       # CSV file combination
│   ├── scopus_doi_to_json.py       # DOI to JSON conversion
│   ├── json2tag_ref_scopus_async.py # Reference processing
│   └── add_abst_scopus.py          # Abstract addition
│
└── 📱 App Build (User Interfaces)
    ├── 🖥️ GUI Versions
    │   ├── gui_main.py              # Basic GUI
    │   ├── gui_progress.py          # GUI with progress bars
    │   └── gui_file_browser.py      # GUI with file browser
    │
    ├── 💻 CLI Versions  
    │   ├── cli_gui.py               # Basic CLI interface
    │   ├── progress_cli.py          # CLI with progress bars
    │   └── file_browser.py          # CLI with file browser
    │
    ├── 🚀 Quick Launch Scripts
    │   ├── quick_install.sh         # Basic installation
    │   ├── quick_progress.sh        # Progress bar versions
    │   └── quick_file_browser.sh    # File browser versions
    │
    ├── 🔧 Setup & Tools
    │   ├── setup.py                 # macOS app builder
    │   ├── standalone_installer.py  # Standalone app creator
    │   ├── fix_tkinter.sh          # tkinter troubleshooting
    │   ├── diagnose.sh             # System diagnostics
    │   └── emergency_run.sh        # Emergency execution
    │
    └── 📖 Documentation
        ├── README_PROGRESS.md       # Progress bar guide
        ├── README_FILE_BROWSER.md   # File browser guide
        └── INSTALL.md              # Installation instructions
```

## 🎮 Available Interfaces

| Interface | Features | Best For | tkinter Required |
|-----------|----------|----------|------------------|
| **🔍 File Browser CLI** | Finder-like navigation, multi-select | First-time users | ❌ No |
| **🔍 File Browser GUI** | Visual tree view, drag & drop | GUI preferences | ✅ Yes |
| **📊 Progress CLI** | Beautiful progress bars, terminal | Power users | ❌ No |
| **📊 Progress GUI** | Real-time progress, stop button | Visual feedback | ✅ Yes |
| **💻 Basic CLI** | Simple menu-driven interface | Minimal setup | ❌ No |
| **🖥️ Basic GUI** | Traditional desktop app | Standard GUI users | ✅ Yes |

## 🛠️ System Requirements

- **OS**: macOS 10.14+ (primary), Linux (experimental)
- **Python**: 3.8 or higher
- **Internet**: Required for DOI resolution
- **Dependencies**: Listed in `app_build/requirements.txt`

## 📋 Usage Workflow

### 1. **Data Preparation**
- Export your research data from Scopus as CSV files
- Place CSV files in a dedicated folder

### 2. **Tool Selection**
Choose your preferred interface:
```bash
# For intuitive file selection
./quick_file_browser.sh

# For progress tracking
./quick_progress.sh  

# For basic functionality
./quick_install.sh
```

### 3. **Processing Steps**
The tool automatically performs:
1. **CSV Combination**: Merges multiple CSV files
2. **DOI Resolution**: Fetches metadata from Crossref
3. **Reference Processing**: Links citations and references
4. **Markdown Generation**: Creates structured output

### 4. **Output**
Results are saved in `md_folder/`:
- Individual Markdown files for each paper
- Structured with tags, abstracts, and references
- Cross-linked citations for easy navigation

## 🔧 Installation Methods

### Automatic Setup
```bash
cd app_build
./install_and_build.sh    # Full automatic setup
```

### Manual Setup
```bash
# Install dependencies
pip3 install -r app_build/requirements.txt

# Set permissions
chmod +x app_build/*.sh

# Choose your interface
./quick_file_browser.sh
```

### macOS App Creation
```bash
cd app_build
python3 setup.py py2app    # Creates .app bundle
```

## 🚨 Troubleshooting

### Common Issues

#### tkinter Not Available
```bash
# Automatic fix
cd app_build
./fix_tkinter.sh

# Or use tkinter-free versions
./quick_file_browser.sh → Select option 1
```

#### Permission Errors
```bash
cd app_build
./set_permissions.sh    # Fix all permissions at once
```

#### General Diagnostics
```bash
cd app_build
./diagnose.sh          # Comprehensive system check
```

### Emergency Mode
If nothing else works:
```bash
cd app_build
./emergency_run.sh     # Multiple fallback options
```

## 📊 Performance & Limits

- **Processing Speed**: ~100-500 DOIs per minute (depending on network)
- **File Size**: Handles CSV files up to several GB
- **Concurrent Processing**: Optimized async processing for DOI resolution
- **Memory Usage**: Minimal, streaming approach for large datasets

## 🔄 Processing Pipeline

```mermaid
graph LR
    A[Multiple CSV Files] --> B[combine_scopus_csv.py]
    B --> C[scopus_combined.csv]
    C --> D[scopus_doi_to_json.py]
    D --> E[JSON_folder/*.json]
    E --> F[json2tag_ref_scopus_async.py]
    F --> G[md_folder/*.md]
    G --> H[add_abst_scopus.py]
    H --> I[Final Markdown Files]
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for:
- Bug fixes
- New interface options
- Performance improvements
- Documentation enhancements

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Crossref API** for DOI resolution services
- **Scopus** for bibliographic data export capabilities
- **NLTK** for natural language processing
- **aiohttp** for efficient async HTTP requests

## 📞 Support

- **Documentation**: Check the README files in `app_build/`
- **Issues**: Use GitHub Issues for bug reports
- **Diagnostics**: Run `./diagnose.sh` for system analysis

---

**🎯 Transform your Scopus exports into organized, linked, and searchable Markdown documentation with just a few clicks!**
