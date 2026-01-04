$logFile = Join-Path $env:TEMP "zhiva-install.log"
function Write-Log {
    param(
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    $logMessage | Tee-Object -FilePath $logFile -Append
    Write-Output $Message
}

if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Log "[Z-IST-2-01] bun is not installed."
    Write-Log "[Z-IST-2-02] Installing bun..."
    winget install bun
    Write-Log "[Z-IST-2-03] Added ~/.bun/bin to PATH."
} else {
    Write-Log "[Z-IST-2-04] 💜 bun is installed."
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Log "[Z-IST-2-05] Error: git is not installed. Please install git manually."
    exit 1
} else {
    Write-Log "[Z-IST-2-06] 💜 git is installed."
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
Write-Log "[Z-IST-2-07] 💜 Zhiva-scripts is installed."

$cmdContent = @"
@echo off
bun run "%USERPROFILE%\.zhiva\scripts\src\cli.ts" %*
"@

$cmdContent | Set-Content -Path (Join-Path $zhivaBinPath "zhiva.cmd") -Force

Write-Log "[Z-IST-2-08] Adding Zhiva to PATH."
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

Write-Log "[Z-IST-2-09] Adding Zhiva to PATH via registry and current session."

$currentPathFromRegistry = Get-Env -Key "PATH"
$zhivaBinPathNormalized = $zhivaBinPath.TrimEnd('\')

$pathArray = @()
if ($currentPathFromRegistry) {
    $pathArray = $currentPathFromRegistry -split ';' | Where-Object { $_ -and $_.TrimEnd('\') -ne $zhivaBinPathNormalized }
}
$updatedPathValue = ($pathArray + @($zhivaBinPathNormalized)) -join ';'

Write-Env -Key "PATH" -Value $updatedPathValue
$env:PATH = $updatedPathValue

Write-Log "[Z-IST-2-10] Added to user PATH (registry and current session): $zhivaBinPath"
Write-Log "[Z-IST-2-11] 💜 Installing Zhiva protocol..."

$protocol = "zhiva"
$zhivaExe = Join-Path $zhivaBinPath "zhiva.cmd"

New-Item "HKCU:\Software\Classes\$protocol" -Force | Out-Null
New-ItemProperty "HKCU:\Software\Classes\$protocol" -Name "URL Protocol" -Value "" -Force | Out-Null
New-Item "HKCU:\Software\Classes\$protocol\shell\open\command" -Force | Out-Null
Set-ItemProperty "HKCU:\Software\Classes\$protocol\shell\open\command" -Name "(default)" -Value "`"$zhivaExe`" protocol `"%1`"" -Force

Start-Process (Join-Path (Join-Path $env:USERPROFILE ".zhiva\bin") "zhiva.cmd") -ArgumentList "self" -Wait

Write-Log "[Z-IST-2-12] 💜 Zhiva command is installed."
