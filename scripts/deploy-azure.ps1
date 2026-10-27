# Deploy app.py, webapp/ and requirements.txt to Azure App Service (zip deploy).

. "$PSScriptRoot\_common.ps1"
Assert-Command "az" "Install Azure CLI."
Assert-Command "terraform" "Install Terraform CLI."
if (-not (Test-Path $Py)) { throw ".venv not found. Run .\scripts\setup-local.cmd first." }
 
$rg = Get-TfVar "resource_group_name"
$out = Get-TfOutputs
$app = $out["web_app_name"]
$url = $out["web_app_url"]
if (-not $app) { throw "terraform output 'web_app_name' was not found." }
 
Write-Host "[1/2] Creating app.zip ..."
& $Py scripts\make_zip.py
if ($LASTEXITCODE -ne 0) { throw "Failed to create app.zip." }
 
Write-Host "[2/2] Deploying to $app (this takes a few minutes) ..."
az webapp deploy --resource-group $rg --name $app --src-path app.zip --type zip
if ($LASTEXITCODE -ne 0) { throw "Deployment failed. Update Azure CLI (az upgrade) if 'deploy' is unknown. Logs: az webapp log tail -g $rg -n $app" }
 
Write-Host ""
Write-Host "Deployed. Open: $url  (first start may take a few minutes)"
