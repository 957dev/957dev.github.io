param([int]$Port = 8000)
$ErrorActionPreference = 'Stop'
& "$PSScriptRoot/build.ps1"
if ($LASTEXITCODE -ne 0) { throw 'Build failed' }
Write-Host "Preview: http://127.0.0.1:$Port (Ctrl+C stops; rerun after edits)"
python "$PSScriptRoot/serve.py" --port $Port
