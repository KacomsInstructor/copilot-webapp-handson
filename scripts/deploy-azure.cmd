@echo off
rem Runs deploy-azure.ps1 without changing the PowerShell execution policy.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0deploy-azure.ps1" %*