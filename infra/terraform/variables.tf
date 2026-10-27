# 講師が用意（変更しない）
# 値は terraform.tfvars に設定します（scripts\init-tfvars.cmd が作成）。

variable "subscription_id" {
  description = "Azure サブスクリプション ID"
  type        = string
}

variable "resource_group_name" {
  description = "既存のリソースグループ名（Terraform では作成しない）"
  type        = string
}

variable "location" {
  description = "リソースを作成するリージョン（例：japaneast）"
  type        = string
}

variable "name_prefix" {
  description = "リソース名の先頭に付ける文字列（英小文字と数字、3〜8文字）"
  type        = string
  default     = "handson"

  validation {
    condition     = can(regex("^[a-z0-9]{3,8}$", var.name_prefix))
    error_message = "name_prefix は英小文字と数字のみ、3〜8文字にしてください。"
  }
}

variable "app_identity_name" {
  description = "App Service が使う既存のユーザー割り当てマネージド ID の名前（管理者が事前に作成）"
  type        = string
  default     = "id-handson-app"
}

variable "deployer_object_id" {
  description = "terraform を実行する人（受講者）の Microsoft Entra オブジェクト ID。パターンBで Cosmos DB のデータ権限を付けるために使う"
  type        = string
}


