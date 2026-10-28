# 講師が用意（変更しない） 

provider "azurerm" {

  features {}
  # azurerm 4.0 以降、Azure CLI で認証する場合は指定が必須 
  subscription_id = var.subscription_id

  # Storage のデータ操作をアカウントキーではなく Microsoft Entra ID で行う 
  storage_use_azuread = true

  # 受講者は共同作成者のため、プロバイダーの自動登録を行わない 
  # （使うプロバイダーは管理者が付録B.3.2で事前登録する） 
  resource_provider_registrations = "none"

} 
