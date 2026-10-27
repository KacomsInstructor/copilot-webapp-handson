# FOR ADMINISTRATORS (needs Owner or User Access Administrator on the resource group).
# Prepares one participant resource group so that the participant can work with Contributor only.
#   1. Create the user-assigned managed identity used by App Service (id-handson-app)
#   2. Grant that identity "Storage Blob Data Contributor" on the resource group (pattern A)
#   3. (optional) Grant the participant "Contributor" and "Storage Blob Data Contributor" on the resource group
# Usage: .\scripts\admin-prepare.cmd -ResourceGroup <rg> [-ParticipantUpn user@contoso.com] [-Location japaneast]


param(
    [Parameter(Mandatory = $true)][string]$ResourceGroup,
    [string]$ParticipantUpn = "",
    [string]$Location = "",
    [string]$IdentityName = "id-handson-app"
)
. "$PSScriptRoot\_common.ps1"
Assert-Command "az" "Install Azure CLI."
 
$rgId = Invoke-Native { az group show --name $ResourceGroup --query id -o tsv }
if ($LASTEXITCODE -ne 0 -or -not $rgId) {
    if (-not $Location) { throw "Resource group '$ResourceGroup' does not exist. Specify -Location to create it." }
    $rgId = az group create --name $ResourceGroup --location $Location --query id -o tsv
}
 
Write-Host "[1/3] Managed identity $IdentityName"
$principal = az identity create --resource-group $ResourceGroup --name $IdentityName --query principalId -o tsv
if (-not $principal) { throw "Failed to create managed identity." }
 
function Grant([string]$Assignee, [string]$Type, [string]$Role) {
    for ($i = 1; $i -le 6; $i++) {
        Invoke-Native { az role assignment create --assignee-object-id $Assignee --assignee-principal-type $Type --role $Role --scope $rgId --output none } | Out-Null
        if ($LASTEXITCODE -eq 0) { Write-Host "      granted: $Role"; return }
        Start-Sleep -Seconds 10
    }
    throw "Failed to assign '$Role' to $Assignee."
}
 
Write-Host "[2/3] Storage Blob Data Contributor -> $IdentityName"
Grant $principal "ServicePrincipal" "Storage Blob Data Contributor"
 
if ($ParticipantUpn) {
    Write-Host "[3/3] Roles for $ParticipantUpn"
    $user = az ad user show --id $ParticipantUpn --query id -o tsv
    if (-not $user) { throw "User '$ParticipantUpn' was not found." }
    Grant $user "User" "Contributor"
    Grant $user "User" "Storage Blob Data Contributor"
}
else {
    Write-Host "[3/3] skipped (no -ParticipantUpn)"
}
Write-Host "Done: $ResourceGroup"

