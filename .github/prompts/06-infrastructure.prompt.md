---
description: "STEP06 Terraformを作成して検証する"
agent: agent
---
# 役割
あなたはAzureのIaC担当です。
# 参照
docs/05-architecture.md（選択したパターン）、infra/terraform/ の既存ファイル（versions.tf・providers.tf・variables.tf・terraform.tfvars）
# 作業
1. infra/terraform/main.tf と outputs.tf を作成する
2. 共通で定義するもの
   - data "azurerm_resource_group"（var.resource_group_name。新規作成しない）
   - data "azurerm_user_assigned_identity"（var.app_identity_name。新規作成しない）
   - random_string（名前の重複回避）、random_password（SECRET_KEY用）
   - App Service Plan：os_type = "Linux" / sku_name = "B1"
   - Linux Web App：Python 3.12 / https_only = true / ftps_state = "Disabled"
     identity は type = "UserAssigned"、identity_ids に既存のマネージドIDを指定
     app_settings：STORAGE_MODE、選んだパターンの接続先、AZURE_CLIENT_ID（マネージドIDの client_id）、
     SECRET_KEY（random_password）、SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
3. パターンA（blob）で追加するもの
   - Storage Account：StorageV2 / Standard_LRS / min_tls_version = "TLS1_2"
     allow_nested_items_to_be_public = false / shared_access_key_enabled = false
   - Blob Container：storage_account_id で指定 / container_access_type = "private"
   - app_settings：AZURE_STORAGE_ACCOUNT_NAME、AZURE_STORAGE_CONTAINER_NAME
   - 権限はマネージドIDに付与済みのため、ロール割り当ては作らない
4. パターンB（cosmos）で追加するもの
   - Cosmos DB アカウント：kind = "GlobalDocumentDB" / サーバーレス（capabilities の EnableServerless）
     local_authentication_disabled = true / minimal_tls_version = "Tls12" / consistency_level = "Session"
   - SQL データベース「appdb」、SQL コンテナー「items」（partition_key_paths = ["/id"]）
   - azurerm_cosmosdb_sql_role_assignment を2つ：マネージドIDの principal_id と var.deployer_object_id に、
     組み込みロール「<アカウントID>/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002」（スコープはアカウント）
   - app_settings：AZURE_COSMOS_ENDPOINT、AZURE_COSMOS_DATABASE、AZURE_COSMOS_CONTAINER
5. リソース名は var.name_prefix と random_string で作る。Storage Account名は英小文字と数字のみ・3〜24文字にする
6. outputs.tf に次の名前で出力する（スクリプトが使うため名前を変えない）
   - 共通：storage_mode（"blob" または "cosmos"）、web_app_name、web_app_url（https://〜）
   - パターンA：storage_account_name、container_name
   - パターンB：cosmos_endpoint、cosmos_database、cosmos_container
7. 次の順にコマンドを実行し、エラーがあれば修正する
   terraform -chdir=infra/terraform fmt
   terraform -chdir=infra/terraform init
   terraform -chdir=infra/terraform validate
   terraform -chdir=infra/terraform plan
8. 最後に、受講者が新しいターミナルで実行するコマンドを表示する：terraform -chdir=infra/terraform apply
# 出力
docs/06-infrastructure.md を次の見出しで作成する
1. 作成リソース一覧（パターン） / 2. セキュリティ設定とその理由 / 3. 実行結果（fmt・init・validate・plan）
4. 自社環境で再構築する手順（scripts/admin-prepare.cmd → init-tfvars → plan → apply） / 5. 仮定
# 完了条件
- validate 成功 / plan にリソースグループ・マネージドID・azurerm_role_assignment の作成が含まれない
# 禁止
terraform apply と destroy は実行しない。*.tfstate の中身を表示しない。
