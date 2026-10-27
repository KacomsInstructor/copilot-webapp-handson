@echo off
rem Runs admin-prepare.ps1 without changing the PowerShell execution policy.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0admin-prepare.ps1" %*
