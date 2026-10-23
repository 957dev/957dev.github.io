param([switch]$Publish)
$ErrorActionPreference = 'Stop'
Push-Location (Split-Path $PSScriptRoot -Parent)
function GitChecked {
    & git @args
    if ($LASTEXITCODE -ne 0) { throw "Git failed: $args" }
}
try {
    & "$PSScriptRoot/build.ps1"
    if (-not $Publish) { Write-Host 'Validated only. Use -Publish after explicit publishing authorization.'; return }
    $branch = git branch --show-current
    if ($branch -ne 'development') { throw 'Publish only from development.' }
    if (git status --porcelain) { throw 'Commit intended changes first; working tree must be clean.' }
    $remote = git remote get-url origin
    if ($remote -ne 'https://github.com/957dev/957dev.github.io.git') { throw 'Unexpected origin.' }
    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if ($gh) { $ghPath = $gh.Source } else { $ghPath = Join-Path $env:LOCALAPPDATA 'Programs/GitHub CLI/bin/gh.exe' }
    if (-not (Test-Path -LiteralPath $ghPath)) { throw 'GitHub CLI not found.' }
    $repository = & $ghPath api repos/957dev/957dev.github.io | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0 -or -not $repository.permissions.push) { throw 'Authenticated GitHub account needs write access to 957dev/957dev.github.io.' }
    $pages = & $ghPath api repos/957dev/957dev.github.io/pages | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0) { throw 'Cannot verify Pages settings.' }
    if ($pages.build_type -ne 'legacy' -or $pages.source.branch -ne 'main' -or $pages.source.path -ne '/') { throw 'Expected Pages publishing from main root; inspect settings before publishing.' }
    GitChecked fetch origin
    git merge-base --is-ancestor origin/main HEAD
    if ($LASTEXITCODE -ne 0) { throw 'Integrate origin/main into development and retest first.' }
    GitChecked push -u origin development
    GitChecked push origin HEAD:main
    Write-Host 'Published to main. GitHub Pages deployment follows automatically.'
} finally { Pop-Location }
