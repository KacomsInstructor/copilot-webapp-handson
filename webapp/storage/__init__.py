"""データ保存の入口（講師が実装・検証済み。変更しないでください）。
 
アプリからは get_repository() だけを使います。保存先が変わってもアプリのコードは同じです。
 
    repo = get_repository()
    repo.list_items()                 -> list[dict]（created_at の昇順）
    repo.get_item(item_id)            -> dict | None
    repo.add_item(data)               -> dict  (id, created_at, updated_at を自動付与)
    repo.update_item(item_id, data)   -> dict | None  (updated_at を自動更新)
    repo.delete_item(item_id)         -> bool
 
保存先は環境変数 STORAGE_MODE で切り替えます。
    local  : data/items.json
    blob   : Azure Blob Storage の items.json（パターンA）
    cosmos : Azure Cosmos DB for NoSQL（パターンB）
"""

from flask import current_app
from .base import Repository
 
 
def create_repository(config) -> Repository:
    if config.STORAGE_MODE == "blob":
        from .azure_blob import AzureBlobRepository
        return AzureBlobRepository(
            account_name=config.AZURE_STORAGE_ACCOUNT_NAME,
            container_name=config.AZURE_STORAGE_CONTAINER_NAME,
        )
    if config.STORAGE_MODE == "cosmos":
        from .cosmos_db import CosmosRepository
        return CosmosRepository(
            endpoint=config.AZURE_COSMOS_ENDPOINT,
            database_name=config.AZURE_COSMOS_DATABASE,
            container_name=config.AZURE_COSMOS_CONTAINER,
        )
    from .local_json import LocalJsonRepository
    return LocalJsonRepository(path=config.LOCAL_DATA_PATH, sample_path=config.SAMPLE_DATA_PATH)
 
 
def get_repository() -> Repository:
    return current_app.extensions["repository"]




