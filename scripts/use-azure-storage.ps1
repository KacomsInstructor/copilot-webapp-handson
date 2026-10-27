# Switch .env to the Azure data store created by Terraform (blob or cosmos).
# Usage: .\scripts\use-azure-storage.cmd        -> azure (pattern from terraform output)
#        .\scripts\use-azure-storage.cmd -Local -> back to local mode


param([switch]$Local)
. "$PSScriptRoot\_common.ps1"
 
if (-not (Test-Path ".env")) { throw ".env not found. Run .\scripts\setup-local.cmd first." }
$text = Read-TextFile ".env"
 
if ($Local) {
    $text = Set-EnvValue $text "STORAGE_MODE" "local"
    Write-Utf8File ".env" $text
    Write-Host "STORAGE_MODE=local. Restart the app (.\scripts\start-local.cmd)."
    exit 0
}
 
Assert-Command "terraform" "Install Terraform CLI."
$out = Get-TfOutputs
$mode = $out["storage_mode"]
 
if ($mode -eq "blob") {
    $text = Set-EnvValue $text "AZURE_STORAGE_ACCOUNT_NAME" $out["storage_account_name"]
    $text = Set-EnvValue $text "AZURE_STORAGE_CONTAINER_NAME" $out["container_name"]
} elseif ($mode -eq "cosmos") {
    $text = Set-EnvValue $text "AZURE_COSMOS_ENDPOINT" $out["cosmos_endpoint"]
    $text = Set-EnvValue $text "AZURE_COSMOS_DATABASE" $out["cosmos_database"]
    $text = Set-EnvValue $text "AZURE_COSMOS_CONTAINER" $out["cosmos_container"]
} else {
    throw "Unknown storage_mode '$mode' in terraform output (expected blob or cosmos)."
}
$text = Set-EnvValue $text "STORAGE_MODE" $mode
Write-Utf8File ".env" $text
Write-Host "STORAGE_MODE=$mode"
Write-Host "Make sure you are signed in with 'az login'. Restart the app (.\scripts\start-local.cmd)."
