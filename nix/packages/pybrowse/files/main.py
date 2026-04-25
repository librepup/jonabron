#!/usr/bin/env python3

import sys
import shlex
from pathlib import Path
import subprocess
from PySide6.QtWidgets import (
    QApplication, QDialog, QVBoxLayout, QHBoxLayout, QLabel,
    QRadioButton, QPushButton, QButtonGroup
)
from PySide6.QtGui import QFont

BGCOLOR = "#0a0a05"
FGCOLOR = "#FFFFFF"
FONTSIZE_PT = 20

DEFAULT_BROWSERS = [
    ("Helium", "helium"),
    ("Zen", "zen"),
    ("Firefox", "firefox"),
    ("Edge", "microsoft-edge"),
    ("Floorp", "floorp"),
]

def load_config():
    config_path = Path.home() / ".config" / "pybrowse" / "config"
    
    if not config_path.exists():
        return DEFAULT_BROWSERS

    browsers = []
    try:
        with open(config_path, "r") as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#"):
                    continue
                
                # shlex.split handles "Quoted Names" and spaces correctly
                parts = shlex.split(line)
                if len(parts) == 2:
                    browsers.append((parts[0], parts[1]))
        
        # Return custom list if valid, otherwise fallback
        return browsers if browsers else DEFAULT_BROWSERS
    except Exception as e:
        print(f"Error reading config: {e}", file=sys.stderr)
        return DEFAULT_BROWSERS

BROWSERS = load_config()

def run_browser(cmd, url):
    try:
        subprocess.Popen([cmd, url])
    except Exception:
        subprocess.Popen(f"{cmd} '{url}'", shell=True)

def main():
    if len(sys.argv) < 2 or not sys.argv[1].strip():
        print("Error: No URL provided.", file=sys.stderr)
        sys.exit(1)
    url = sys.argv[1]

    app = QApplication(sys.argv)
    font = QFont()
    font.setPointSize(FONTSIZE_PT)
    app.setFont(font)

    app.setStyleSheet(f"""
        QWidget {{ background-color: {BGCOLOR}; color: {FGCOLOR}; }}
        QRadioButton {{ spacing: 8px; padding: 6px; }}
        QPushButton {{ padding: 6px 12px; }}
        QLabel {{ padding-bottom: 6px; }}
    """)

    dlg = QDialog()
    dlg.setWindowTitle("Choose Browser")
    layout = QVBoxLayout(dlg)

    layout.addWidget(QLabel("Choose Browser:"))

    btn_group = QButtonGroup(dlg)
    for i, (label, _) in enumerate(BROWSERS, start=1):
        rb = QRadioButton(label)
        if i == 1:
            rb.setChecked(True)
        btn_group.addButton(rb, i-1)
        layout.addWidget(rb)

    btn_layout = QHBoxLayout()
    ok = QPushButton("Open")
    cancel = QPushButton("Cancel")
    btn_layout.addStretch()
    btn_layout.addWidget(ok)
    btn_layout.addWidget(cancel)
    layout.addLayout(btn_layout)

    def on_ok():
        idx = btn_group.checkedId()
        if idx < 0:
            dlg.reject()
            return
        _, cmd = BROWSERS[idx]
        run_browser(cmd, url)
        dlg.accept()

    ok.clicked.connect(on_ok)
    cancel.clicked.connect(dlg.reject)

    dlg.exec()
    sys.exit(0 if dlg.result() == QDialog.Accepted else 1)

if __name__ == "__main__":
    main()
