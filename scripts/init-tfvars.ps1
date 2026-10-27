# Create infra/terraform/terraform.tfvars from the signed-in Azure account.
# Usage: .\scripts\init-tfvars.cmd -ResourceGroup <resource-group-name>

param(
    [Parameter(Mandatory = $true)][string]$ResourceGroup,
    [string]$IdentityName = "id-handson-app"
)
. "$PSScriptRoot\_common.ps1"
Assert-Command "az" "Install Azure CLI."
 
$sub = az account show --query id -o tsv
if ($LASTEXITCODE -ne 0 -or -not $sub) { throw "Not signed in. Run 'az login' first." }
 
$loc = az group show --name $ResourceGroup --query location -o tsv
if ($LASTEXITCODE -ne 0 -or -not $loc) { throw "Resource group '$ResourceGroup' was not found or you have no access." }
 
$me = az ad signed-in-user show --query id -o tsv
if ($LASTEXITCODE -ne 0 -or -not $me) { throw "Could not get your object id (az ad signed-in-user show). Update Azure CLI (az upgrade) and retry." }
 
$idName = Invoke-Native { az identity show --resource-group $ResourceGroup --name $IdentityName --query name -o tsv }
if ($LASTEXITCODE -ne 0 -or -not $idName) {
    Write-Host "WARNING: managed identity '$IdentityName' was not found in '$ResourceGroup'."
    Write-Host "         Ask the administrator to run scripts\admin-prepare.cmd for this resource group."
}
 
$text = @"
subscription_id     = "$($sub.Trim())"
resource_group_name = "$ResourceGroup"
location            = "$($loc.Trim())"
name_prefix         = "handson"
app_identity_name   = "$IdentityName"
deployer_object_id  = "$($me.Trim())"
"@
Write-Utf8File "infra\terraform\terraform.tfvars" ($text + "`r`n")
Write-Host "Created infra\terraform\terraform.tfvars (resource group: $ResourceGroup, location: $($loc.Trim()))"
