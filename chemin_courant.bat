@echo off
powershell -NoProfile -Command "Write-Output ('\"' + ((Get-Location).Path -replace '\\','/') + '\"')"
pause