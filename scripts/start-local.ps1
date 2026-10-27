# Start the Flask app locally. Usage: .\scripts\start-local.cmd [-Port 5001]
param([int]$Port = 5000)
. "$PSScriptRoot\_common.ps1"
 
if (-not (Test-Path $Py)) { throw ".venv not found. Run .\scripts\setup-local.cmd first." }
if (-not (Test-Path ".env")) { throw ".env not found. Run .\scripts\setup-local.cmd first." }
 
Write-Host "Open http://127.0.0.1:$Port in your browser. Press Ctrl+C to stop."
& $Py -m flask --app app run --host 127.0.0.1 --port $Port


