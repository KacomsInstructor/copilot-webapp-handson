@echo off
rem Runs use-azure-storage.ps1 without changing the PowerShell execution policy.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0use-azure-storage.ps1" %*


