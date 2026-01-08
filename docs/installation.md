# Zhiva Install Instruction

## Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/wxn0brP/Zhiva/HEAD/install/prepare.sh | bash
export PATH="$HOME/.zhiva/bin:$PATH"
zhiva install Zhiva-store-app
zhiva start Zhiva-store-app
```

Remember to add the following to your `.bashrc` or `.zshrc` file:

```bash
export PATH="$HOME/.zhiva/bin:$PATH"
```

If you use **zsh**, add the following to your `.zshrc` file to enable **auto-completion** for Zhiva commands:

```bash
[ -s "$HOME/.zhiva/scripts/_zhiva" ] && source "$HOME/.zhiva/scripts/_zhiva"
```

## Windows

[Zhiva Store Auto Install](https://github.com/wxn0brP/Zhiva-windows/releases/download/native/Zhiva-store-app.exe)

Repository: [https://github.com/wxn0brP/Zhiva-windows](https://github.com/wxn0brP/Zhiva-windows)