# Create .venv, install packages, create .env with SECRET_KEY.
# Python 3.10 or later is required (3.12 recommended). Any installed version 3.10+ is used.
. "$PSScriptRoot\_common.ps1"
 
# Candidates in order of preference. "py" is the Python launcher for Windows.
$candidates = @(
    @{ Exe = "py"; Args = @("-3.12") },
    @{ Exe = "py"; Args = @("-3.13") },
    @{ Exe = "py"; Args = @("-3.11") },
    @{ Exe = "py"; Args = @("-3.14") },
    @{ Exe = "py"; Args = @("-3.10") },
    @{ Exe = "python"; Args = @() },
    @{ Exe = "py"; Args = @() }
)

if (Test-Path ".venv") {
    $venvVer = Get-PythonVersion $Py
    if (-not $venvVer) { throw ".venv is broken. Delete the .venv folder and run this script again." }
    if ($venvVer -lt $PyMinVersion) {
        throw ".venv uses Python $venvVer. Python $PyMinVersion or later is required. Delete the .venv folder and run this script again."
    }
    Write-Host "[1/3] .venv already exists (Python $venvVer)."
}
else {
    $found = $null
    $foundVer = $null
    foreach ($c in $candidates) {
        $v = Get-PythonVersion $c.Exe $c.Args
        if ($v -and $v -ge $PyMinVersion) { $found = $c; $foundVer = $v; break }
    }
    if (-not $found) {
        throw "Python $PyMinVersion or later was not found. Install Python 3.12 from python.org (check 'Add python.exe to PATH') and open a new terminal."
    }
    if ($foundVer -gt $PyMaxChecked) {
        Write-Host "WARNING: Python $foundVer is newer than the checked versions (3.10 - $PyMaxChecked). If setup fails, install Python 3.12."
    }
    Write-Host "[1/3] Creating virtual environment (.venv) with Python $foundVer ..."
    $pyArgs = $found.Args
    & $found.Exe @pyArgs -m venv .venv
    if ($LASTEXITCODE -ne 0) { throw "Failed to create .venv." }
}
 
Write-Host "[2/3] Installing packages ..."
$env:PYTHONUTF8 = "1"
& $Py -m pip install --disable-pip-version-check -r requirements.txt
if ($LASTEXITCODE -ne 0) {
    throw "pip install failed. Check requirements.txt encoding, proxy, and network settings." 
}
 
Write-Host "[3 / 3] Preparing .env ..."
if (-not (Test-Path ".env")) { Copy-Item ".env.example" ".env" }
$text = Read-TextFile ".env"
if ($text -notmatch "(?m)^SECRET_KEY=\S+") {
    $key = (& $Py -c "import secrets; print(secrets.token_hex(32))").Trim()
    $text = Set-EnvValue $text "SECRET_KEY" $key
    Write-Utf8File ".env" $text
    Write-Host "      SECRET_KEY was generated."
}
 
& $Py --version
Write-Host ""
Write-Host "Setup completed. Next: .\scripts\start-local.cmd"

