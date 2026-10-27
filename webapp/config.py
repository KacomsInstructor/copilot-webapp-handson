"""環境変数から設定を読み込みます（講師が用意。変更しないでください）。"""

import os
from pathlib import Path
BASE_DIR = Path(__file__).resolve().parent.parent
MODES = ("local", "blob", "cosmos")
 
 
class Config:
    def __init__(self) -> None:
        env = lambda key, default="": os.getenv(key, default).strip()
        self.SECRET_KEY = env("SECRET_KEY")
        self.STORAGE_MODE = env("STORAGE_MODE", "local").lower() or "local"
        # pattern A: Blob
        self.AZURE_STORAGE_ACCOUNT_NAME = env("AZURE_STORAGE_ACCOUNT_NAME")
        self.AZURE_STORAGE_CONTAINER_NAME = env("AZURE_STORAGE_CONTAINER_NAME")
        # pattern B: Cosmos DB
        self.AZURE_COSMOS_ENDPOINT = env("AZURE_COSMOS_ENDPOINT")
        self.AZURE_COSMOS_DATABASE = env("AZURE_COSMOS_DATABASE")
        self.AZURE_COSMOS_CONTAINER = env("AZURE_COSMOS_CONTAINER")
        # local
        self.LOCAL_DATA_PATH = env("LOCAL_DATA_PATH", str(BASE_DIR / "data" / "items.json"))
        # 空文字にするとサンプルデータを読み込みません（テストで使用）
        self.SAMPLE_DATA_PATH = os.getenv("SAMPLE_DATA_PATH", str(BASE_DIR / "data" / "sample-items.json"))
 
    def validate(self) -> None:
        if not self.SECRET_KEY:
            raise RuntimeError("SECRET_KEY is not set. Run scripts\\setup-local.cmd to create .env.")
        if self.STORAGE_MODE not in MODES:
            raise RuntimeError(f"STORAGE_MODE must be one of {MODES}.")
        required = {
            "blob": ["AZURE_STORAGE_ACCOUNT_NAME", "AZURE_STORAGE_CONTAINER_NAME"],
            "cosmos": ["AZURE_COSMOS_ENDPOINT", "AZURE_COSMOS_DATABASE", "AZURE_COSMOS_CONTAINER"],
        }.get(self.STORAGE_MODE, [])
        missing = [k for k in required if not getattr(self, k)]
        if missing:
            raise RuntimeError(
                f"{', '.join(missing)} required when STORAGE_MODE={self.STORAGE_MODE}. "
                "Run scripts\\use-azure-storage.cmd."
            )
