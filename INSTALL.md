# Zhiva Install Instruction

## Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/wxn0brP/Zhiva-scripts/refs/heads/master/install/prepare.sh | bash
export PATH="$HOME/.zhiva/bin:$PATH"
zhiva-install Zhiva-store-app
zhiva-startup Zhiva-store-app
```

## Windows

```powershell
powershell -c "irm https://raw.githubusercontent.com/wxn0brP/Zhiva-scripts/master/install/prepare.ps1 | iex"
$env:Path += ";$HOME\.zhiva\bin"
zhiva-install Zhiva-store-app
zhiva-startup Zhiva-store-app
```