"""パターンB：Azure Cosmos DB for NoSQL への保存（講師が実装・検証済み。変更しないでください）。
 
キーは使いません（アカウント側でローカル認証を無効化）。DefaultAzureCredential により、
ローカルでは az login の資格情報、App Service ではユーザー割り当てマネージド ID で認証します。
データの読み書きには Cosmos DB のデータロール「Cosmos DB Built-in Data Contributor」が必要です
（Terraform で割り当て）。データベースとコンテナーは Terraform で作成済みであることが前提です。
1件＝1ドキュメント、パーティションキーは /id です。
"""
from azure.cosmos import CosmosClient
from azure.cosmos.exceptions import CosmosResourceNotFoundError
from azure.identity import DefaultAzureCredential
 
from .base import Repository, merge_item, new_item
 
 
def _clean(doc: dict) -> dict:
    # Cosmos DB のシステム項目（_rid, _etag, _ts など）を取り除く
    return {k: v for k, v in doc.items() if not k.startswith("_")}
 
 
class CosmosRepository(Repository):
    def __init__(self, endpoint: str, database_name: str, container_name: str) -> None:
        self._settings = (endpoint, database_name, container_name)
        self._client = None
 
    @property
    def _container(self):
        # 最初に使うときに接続する（権限の反映待ちでもアプリ自体は起動できるように）
        if self._client is None:
            endpoint, database_name, container_name = self._settings
            client = CosmosClient(endpoint, credential=DefaultAzureCredential())
            self._client = client.get_database_client(database_name).get_container_client(container_name)
        return self._client
 
    def list_items(self) -> list[dict]:
        docs = self._container.query_items(
            query="SELECT * FROM c", enable_cross_partition_query=True
        )
        return sorted((_clean(d) for d in docs), key=lambda i: i.get("created_at", ""))
 
    def get_item(self, item_id: str) -> dict | None:
        try:
            return _clean(self._container.read_item(item=item_id, partition_key=item_id))
        except CosmosResourceNotFoundError:
            return None
 
    def add_item(self, data: dict) -> dict:
        return _clean(self._container.create_item(body=new_item(data)))
 
    def update_item(self, item_id: str, data: dict) -> dict | None:
        item = self.get_item(item_id)
        if item is None:
            return None
        return _clean(self._container.replace_item(item=item_id, body=merge_item(item, data)))
 
    def delete_item(self, item_id: str) -> bool:
        try:
            self._container.delete_item(item=item_id, partition_key=item_id)
            return True
        except CosmosResourceNotFoundError:
            return False
