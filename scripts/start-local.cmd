@echo off
rem Runs start-local.ps1 without changing the PowerShell execution policy.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0start-local.ps1" %*


