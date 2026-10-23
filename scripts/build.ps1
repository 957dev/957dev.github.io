$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
Push-Location $root
try {
    python scripts/test.py
    if ($LASTEXITCODE -ne 0) { throw 'Validation failed' }
    $output = Join-Path $root 'dist'
    if (Test-Path -LiteralPath $output) {
        $resolved = (Resolve-Path -LiteralPath $output).Path
        if ($resolved -ne [IO.Path]::GetFullPath((Join-Path $root 'dist')) -or (Get-Item -LiteralPath $output).Attributes -band [IO.FileAttributes]::ReparsePoint) { throw 'Unsafe build output path' }
        Remove-Item -LiteralPath $output -Recurse -Force
    }
    New-Item -ItemType Directory -Path $output | Out-Null
    Copy-Item index.html -Destination $output
    Copy-Item assets,data -Destination $output -Recurse
    if (Test-Path CNAME) { Copy-Item CNAME -Destination $output }
    New-Item -ItemType File -Path (Join-Path $output '.nojekyll') | Out-Null
    Write-Host 'Built dist/'
} finally { Pop-Location }
