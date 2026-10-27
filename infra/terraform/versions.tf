# 講師が用意（変更しない）
# Terraform CLI は 1.5 以上なら利用可（基本的な機能だけを使っているため）。
# azurerm は 4.x を使います（5.x とは一部の属性名が異なります）。
# リハーサルで検証した版に固定してください（例：version = "= 4.xx.x"）。

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}


