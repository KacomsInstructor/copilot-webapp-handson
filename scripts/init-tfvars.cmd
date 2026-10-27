@echo off
rem Runs init-tfvars.ps1 without changing the PowerShell execution policy.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0init-tfvars.ps1" %*


