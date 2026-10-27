@echo off
rem Runs setup-local.ps1 without changing the PowerShell execution policy.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-local.ps1" %*
