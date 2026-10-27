# Remove secrets and environment-specific files before taking the folder home.

. "$PSScriptRoot\_common.ps1"
 
$targets = @(
    ".env",
    "app.zip",
    "infra\terraform\terraform.tfvars",
    "infra\terraform\terraform.tfstate",
    "infra\terraform\terraform.tfstate.backup",
    "infra\terraform\.terraform.lock.hcl",
    "infra\terraform\.terraform",
    ".venv"
)
foreach ($t in $targets) {
    if (Test-Path $t) {
        Remove-Item $t -Recurse -Force -ErrorAction SilentlyContinue
        if (Test-Path $t) { Write-Host "  could not remove (close VS Code and retry): $t" }
        else { Write-Host "  removed: $t" }
    }
}
Get-ChildItem -Path "infra\terraform" -Filter "*.tfstate*" -ErrorAction SilentlyContinue | Remove-Item -Force
 
Write-Host ""
Write-Host "Next, sign out (3 places):"
Write-Host "  1. VS Code: Accounts icon (bottom-left) > GitHub account > Sign Out"
Write-Host "  2. Terminal: az logout"
Write-Host "  3. Browser: sign out of github.com and portal.azure.com"
Write-Host ""
Write-Host "At your office: run .\scripts\setup-local.cmd, then see docs\10-handover-guide.md"

