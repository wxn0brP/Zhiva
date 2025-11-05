if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Host "[Z-IST-2-01] bun is not installed."
    Write-Host "[Z-IST-2-02] Installing bun..."
    irm https://bun.sh/install.ps1 | iex
    $env:PATH += ";$USERPROFILE\.bun\bin"
    Write-Host "[Z-IST-2-03] Added ~/.bun/bin to PATH."
} else {
    Write-Host "[Z-IST-2-04] 💜 bun is installed."
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[Z-IST-2-05] Error: git is not installed. Please install git manually."
    exit 1
} else {
    Write-Host "[Z-IST-2-06] 💜 git is installed."
}

$zhivaPath = Join-Path $HOME ".zhiva"
$zhivaBinPath = Join-Path $zhivaPath "bin"
New-Item -ItemType Directory -Path $zhivaBinPath -Force | Out-Null

$zhivaScriptsPath = Join-Path $zhivaPath "scripts"
if (-not (Test-Path $zhivaScriptsPath)) {
    git clone https://github.com/wxn0brP/Zhiva-scripts.git $zhivaScriptsPath
} else {
    git -C $zhivaScriptsPath pull
}

Copy-Item -Path (Join-Path $zhivaScriptsPath "package.json") -Destination (Join-Path $zhivaPath "package.json") -Force
Set-Location $zhivaPath
bun install --production --force
bun run "%USERPROFILE%\.zhiva\scripts\src\cli.ts" self
Write-Host "[Z-IST-2-07] 💜 Zhiva-scripts is installed."

$cmdContent = @"
@echo off
bun run "%USERPROFILE%\.zhiva\scripts\src\cli.ts" %*
"@

$cmdContent | Set-Content -Path (Join-Path $zhivaBinPath "zhiva.cmd") -Force

Write-Host "[Z-IST-2-08] Adding Zhiva to PATH."
$env:Path += ";$zhivaBinPath"
[Environment]::SetEnvironmentVariable("PATH", $env:PATH, "User")

Write-Host "[Z-IST-2-09] 💜 Zhiva command is installed."
