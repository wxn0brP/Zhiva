$LogFile = "$env:TEMP\zhiva-prepare.log"
Start-Transcript -Path $LogFile -Append -Force

function Get-FreshPath {
    $systemPath = [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
    $userPath   = [System.Environment]::GetEnvironmentVariable("PATH", "User")
    return "$systemPath;$userPath"
}

$env:PATH = Get-FreshPath

winget install Git.Git
winget install Oven-sh.Bun

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[Z-IST-2-01] 💜 Error: git is not installed. Please install git manually."
    exit 1
}

if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Host "[Z-IST-2-02] 💜 Error: bun is not installed. Please install bun manually."
    exit 1
}

Write-Host "[Z-IST-2-03] 💜 Git and bun are installed."

$zhivaPath = Join-Path $HOME ".zhiva"
$zhivaBinPath = Join-Path $zhivaPath "bin"

if (Test-Path $zhivaBinPath) {
    Write-Host "[Z-IST-2-04] 💜 Zhiva is already installed."
    exit
}

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
Write-Host "[Z-IST-2-10] 💜 Zhiva-scripts is installed."

$cmdContent = @"
@echo off

if "%~1"=="-hide" (
    shift
    start "" /min cmd /c "%~f0" %*
    exit
)

bun run "%USERPROFILE%\.zhiva\scripts\src\cli.ts" %*
"@

$cmdContent | Set-Content -Path (Join-Path $zhivaBinPath "zhiva.cmd") -Force

Write-Host "[Z-IST-2-11] Adding Zhiva to PATH."
if (-not ("Win32.NativeMethods" -as [Type])) {
    Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition @"
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
public static extern IntPtr SendMessageTimeout(
    IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
    uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@
}

function Publish-Env {
    $HWND_BROADCAST = [IntPtr]0xffff
    $WM_SETTINGCHANGE = 0x1a
    $result = [UIntPtr]::Zero
    [Win32.NativeMethods]::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE,
        [UIntPtr]::Zero, "Environment", 2, 5000, [ref]$result) | Out-Null
}

function Write-Env {
    param([String]$Key, [String]$Value)
    $RegisterKey = Get-Item -Path 'HKCU:'
    $EnvRegisterKey = $RegisterKey.OpenSubKey('Environment', $true)
    if ($null -eq $Value) {
        $EnvRegisterKey.DeleteValue($Key)
    } else {
        $RegistryValueKind = if ($Value.Contains('%')) {
            [Microsoft.Win32.RegistryValueKind]::ExpandString
        } elseif ($EnvRegisterKey.GetValue($Key)) {
            $EnvRegisterKey.GetValueKind($Key)
        } else {
            [Microsoft.Win32.RegistryValueKind]::String
        }
        $EnvRegisterKey.SetValue($Key, $Value, $RegistryValueKind)
    }
    Publish-Env
}

function Get-Env {
    param([String]$Key)
    $RegisterKey = Get-Item -Path 'HKCU:'
    $EnvRegisterKey = $RegisterKey.OpenSubKey('Environment')
    $EnvRegisterKey.GetValue($Key, $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
}

Write-Host "[Z-IST-2-12] Adding Zhiva to PATH via registry and current session."

$currentPathFromRegistry = Get-Env -Key "PATH"
$zhivaBinPathNormalized = $zhivaBinPath.TrimEnd('\')

$pathArray = @()
if ($currentPathFromRegistry) {
    $pathArray = $currentPathFromRegistry -split ';' | Where-Object { $_ -and $_.TrimEnd('\') -ne $zhivaBinPathNormalized }
}
$updatedPathValue = ($pathArray + @($zhivaBinPathNormalized)) -join ';'

Write-Env -Key "PATH" -Value $updatedPathValue
$env:PATH = $updatedPathValue

Write-Host "[Z-IST-2-13] Added to user PATH (registry and current session): $zhivaBinPath"
Write-Host "[Z-IST-2-14] 💜 Installing Zhiva protocol..."

$protocol = "zhiva"
$zhivaExe = Join-Path $zhivaBinPath "zhiva.cmd"

New-Item "HKCU:\Software\Classes\$protocol" -Force | Out-Null
New-ItemProperty "HKCU:\Software\Classes\$protocol" -Name "URL Protocol" -Value "" -Force | Out-Null
New-Item "HKCU:\Software\Classes\$protocol\shell\open\command" -Force | Out-Null
Set-ItemProperty "HKCU:\Software\Classes\$protocol\shell\open\command" -Name "(default)" -Value "`"$zhivaExe`" protocol `"%1`"" -Force

Start-Process (Join-Path (Join-Path $env:USERPROFILE "\.zhiva\bin") "zhiva.cmd") -ArgumentList "self" -Wait

Write-Host "[Z-IST-2-15] 💜 Zhiva command is installed."
Write-Host ""
Write-Host "Press Enter to continue..."
Stop-Transcript