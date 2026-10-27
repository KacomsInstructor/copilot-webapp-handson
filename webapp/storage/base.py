"""保存処理の共通部分（講師が実装・検証済み。変更しないでください）。"""

import threading
import uuid
from datetime import datetime, timezone
 
PROTECTED_KEYS = ("id", "created_at", "updated_at")
 
 
def now() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds")
 
 
def new_item(data: dict) -> dict:
    """id / created_at / updated_at を付けた新しいデータを返す。"""
    item = {k: v for k, v in data.items() if k not in PROTECTED_KEYS}
    ts = now()
    item.update({"id": str(uuid.uuid4()), "created_at": ts, "updated_at": ts})
    return item
 
 
def merge_item(item: dict, data: dict) -> dict:
    """既存データに変更を反映し、updated_at を更新する。"""
    item.update({k: v for k, v in data.items() if k not in PROTECTED_KEYS})
    item["updated_at"] = now()
    return item
 
 
class Repository:
    """保存先ごとの実装が満たすインターフェース。"""
 
    def list_items(self) -> list[dict]:
        raise NotImplementedError
 
    def get_item(self, item_id: str) -> dict | None:
        raise NotImplementedError
 
    def add_item(self, data: dict) -> dict:
        raise NotImplementedError
 
    def update_item(self, item_id: str, data: dict) -> dict | None:
        raise NotImplementedError
 
    def delete_item(self, item_id: str) -> bool:
        raise NotImplementedError
 
 
class JsonRepository(Repository):
    """全件を {"items": [...]} の1ファイルで扱う実装（local / blob 共通）。
 
    _load() と _save() をサブクラスで実装する。
    複数の人が同時に更新すると、後から保存した内容で上書きされる点に注意（パターンAの制約）。
    """
 
    def __init__(self) -> None:
        self._lock = threading.Lock()
 
    def _load(self) -> dict:
        raise NotImplementedError
 
    def _save(self, data: dict) -> None:
        raise NotImplementedError
 
    def _read(self) -> dict:
        data = self._load() or {}
        items = data.get("items")
        return {"items": items if isinstance(items, list) else []}
 
    def list_items(self) -> list[dict]:
        with self._lock:
            return sorted(self._read()["items"], key=lambda i: i.get("created_at", ""))
 
    def get_item(self, item_id: str) -> dict | None:
        with self._lock:
            return next((i for i in self._read()["items"] if i.get("id") == item_id), None)
 
    def add_item(self, data: dict) -> dict:
        with self._lock:
            store = self._read()
            item = new_item(data)
            store["items"].append(item)
            self._save(store)
            return item
 
    def update_item(self, item_id: str, data: dict) -> dict | None:
        with self._lock:
            store = self._read()
            for item in store["items"]:
                if item.get("id") == item_id:
                    merge_item(item, data)
                    self._save(store)
                    return item
            return None
 
    def delete_item(self, item_id: str) -> bool:
        with self._lock:
            store = self._read()
            remaining = [i for i in store["items"] if i.get("id") != item_id]
            if len(remaining) == len(store["items"]):
                return False
            store["items"] = remaining
            self._save(store)
            return True
