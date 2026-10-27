
# Shared helpers for handson scripts. ASCII only (Windows PowerShell 5.1 and PowerShell 7 compatible).
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root
$Py = Join-Path $Root ".venv\Scripts\python.exe"
$Utf8NoBom = New-Object System.Text.UTF8Encoding $false

# Minimum Python version for this template (code uses Python 3.10+ syntax).
$PyMinVersion = [version]"3.10"
# Newest Python version confirmed for requirements.txt (newer versions get a warning only).
$PyMaxChecked = [version]"3.14"
 
function Write-Utf8File([string]$Path, [string]$Text) {
    [System.IO.File]::WriteAllText((Join-Path $Root $Path), $Text, $Utf8NoBom)
}
 
function Read-TextFile([string]$Path) {
    return [System.IO.File]::ReadAllText((Join-Path $Root $Path))
}
 
function Set-EnvValue([string]$Text, [string]$Key, [string]$Value) {
    $pattern = "(?m)^" + [regex]::Escape($Key) + "=.*$"
    if ($Text -match $pattern) {
        return [regex]::Replace($Text, $pattern, "$Key=$Value")
    }
    if ($Text.Length -gt 0 -and -not $Text.EndsWith("`n")) { $Text += "`r`n" }
    return $Text + "$Key=$Value`r`n"
}
 
function Assert-Command([string]$Name, [string]$Hint) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "$Name was not found. $Hint"
    }
}

# Runs a native command and hides its error output without stopping the script.
# (In Windows PowerShell 5.1, "2>`$null" with ErrorActionPreference=Stop stops the script.)
# Check $LASTEXITCODE after calling.
function Invoke-Native([scriptblock]$Command) {
    $ErrorActionPreference = "Continue"
    & $Command 2>$null
}

# Returns the Python version (major.minor) of a command, or $null if it cannot run.
function Get-PythonVersion([string]$Exe, [string[]]$PyArgs = @()) {
    if (-not (Get-Command $Exe -ErrorAction SilentlyContinue)) { return $null }
    $out = Invoke-Native { & $Exe @PyArgs -c "import sys;print(str(sys.version_info[0])+'.'+str(sys.version_info[1]))" }
    if ($LASTEXITCODE -ne 0 -or -not $out) { return $null }
    try { return [version]((@($out)[-1]).ToString().Trim()) } catch { return $null }
}
 
# Returns terraform outputs as a hashtable (name -> value).
function Get-TfOutputs {
    $json = terraform "-chdir=infra/terraform" output -json
    if ($LASTEXITCODE -ne 0 -or -not $json) {
        throw "terraform output failed. Run 'terraform -chdir=infra/terraform apply' first."
    }
    $obj = ($json -join "`n") | ConvertFrom-Json
    $result = @{}
    foreach ($p in $obj.PSObject.Properties) { $result[$p.Name] = [string]$p.Value.value }
    if (-not $result.ContainsKey("storage_mode")) {
        throw "terraform output 'storage_mode' was not found. Check outputs.tf (see /06-infrastructure)."
    }
    return $result
}
 
function Get-TfVar([string]$Name) {
    $tfvars = Read-TextFile "infra\terraform\terraform.tfvars"
    $m = [regex]::Match($tfvars, $Name + '\s*=\s*"([^"]+)"')
    if (-not $m.Success) { throw "$Name not found in terraform.tfvars. Run init-tfvars.cmd first." }
    return $m.Groups[1].Value
}


