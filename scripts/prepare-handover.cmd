@echo off
rem Runs prepare-handover.ps1 without changing the PowerShell execution policy.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0prepare-handover.ps1" %*


