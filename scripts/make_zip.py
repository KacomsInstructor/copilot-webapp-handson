"""Create app.zip for App Service (used by deploy-azure.ps1).
 
Python's zipfile is used so that paths inside the zip use '/' (Linux compatible).
"""
import zipfile
from pathlib import Path
 
ROOT = Path(__file__).resolve().parent.parent
INCLUDE = ["app.py", "requirements.txt", "webapp"]
EXCLUDE_DIRS = {"__pycache__"}
 
with zipfile.ZipFile(ROOT / "app.zip", "w", zipfile.ZIP_DEFLATED) as zf:
    for name in INCLUDE:
        path = ROOT / name
        files = [path] if path.is_file() else sorted(p for p in path.rglob("*") if p.is_file())
        for f in files:
            if EXCLUDE_DIRS & set(f.relative_to(ROOT).parts) or f.suffix == ".pyc":
                continue
            zf.write(f, f.relative_to(ROOT).as_posix())
print("app.zip created")


