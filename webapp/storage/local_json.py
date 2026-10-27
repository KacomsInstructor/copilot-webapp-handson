"""ローカルJSONファイルへの保存（講師が実装・検証済み。変更しないでください）。"""

import json
import os
import shutil
from pathlib import Path
 
from .base import JsonRepository
 
 
class LocalJsonRepository(JsonRepository):
    def __init__(self, path: str, sample_path: str = "") -> None:
        super().__init__()
        self._path = Path(path)
        self._path.parent.mkdir(parents=True, exist_ok=True)
        # 初回のみ、サンプルデータをコピーして始める
        if not self._path.exists() and sample_path and Path(sample_path).exists():
            shutil.copyfile(sample_path, self._path)
 
    def _load(self) -> dict:
        if not self._path.exists():
            return {"items": []}
        with self._path.open("r", encoding="utf-8") as f:
            return json.load(f)
 
    def _save(self, data: dict) -> None:
        tmp = self._path.with_suffix(".tmp")
        with tmp.open("w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        os.replace(tmp, self._path)


