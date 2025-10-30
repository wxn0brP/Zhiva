# Zhiva Install Instruction

## Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/wxn0brP/Zhiva-scripts/refs/heads/master/install/prepare.sh | bash
export PATH="$HOME/.zhiva/bin:$PATH"
zhiva install Zhiva-store-app
zhiva start Zhiva-store-app
```

## Windows

> **Note:**  
> Installation on Windows is currently experimental. We recommend switching to Linux for a better experience, as Windows sometimes feels like it's held together with digital duct tape.  
> Anyway, Arch in everything is better than Windows.


```powershell
powershell -c "irm https://raw.githubusercontent.com/wxn0brP/Zhiva-scripts/master/install/prepare.ps1 | iex"
$env:Path += ";$HOME\.zhiva\bin"
zhiva install Zhiva-store-app
zhiva start Zhiva-store-app
```

Or

[Zhiva Store Auto Install](https://github.com/wxn0brP/Zhiva-windows/releases/download/native/Zhiva-store-app.exe) (Experimental)