"""パターンA：Azure Blob Storage への保存（講師が実装・検証済み。変更しないでください）。
 
接続文字列やアカウントキーは使いません。DefaultAzureCredential により、
ローカルでは az login の資格情報、App Service ではユーザー割り当てマネージド ID
（環境変数 AZURE_CLIENT_ID で指定）で認証します。
読み書きには「Storage Blob Data Contributor」ロールが必要です（管理者が事前に割り当て）。
"""

import json
from azure.core.exceptions import ResourceNotFoundError
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient, ContentSettings
 
from .base import JsonRepository
 
BLOB_NAME = "items.json"
 
 
class AzureBlobRepository(JsonRepository):
    def __init__(self, account_name: str, container_name: str) -> None:
        super().__init__()
        service = BlobServiceClient(
            account_url=f"https://{account_name}.blob.core.windows.net",
            credential=DefaultAzureCredential(),
        )
        self._blob = service.get_blob_client(container=container_name, blob=BLOB_NAME)
 
    def _load(self) -> dict:
        try:
            raw = self._blob.download_blob().readall()
        except ResourceNotFoundError:
            return {"items": []}
        return json.loads(raw.decode("utf-8"))
 
    def _save(self, data: dict) -> None:
        body = json.dumps(data, ensure_ascii=False, indent=2).encode("utf-8")
        self._blob.upload_blob(
            body,
            overwrite=True,
            content_settings=ContentSettings(content_type="application/json; charset=utf-8"),
        )
