# Zhiva Install Instruction

Zhiva runs on Windows and Linux. The macOS build exists but is untested on real hardware.

## Requirements

### Linux

- [Git](https://git-scm.com)
- [Bun](https://bun.sh): the installer can install it for you
- WebKitGTK 4.1 and GTK 3: required by the native window
- `xdg-utils`: required for desktop shortcuts and the `zhiva://` protocol

Install the native dependencies for your distribution:

```bash
# Debian / Ubuntu
sudo apt install libwebkit2gtk-4.1-0 libgtk-3-0 xdg-utils

# Fedora
sudo dnf install webkit2gtk4.1 gtk3 xdg-utils

# Arch
sudo pacman -S webkit2gtk-4.1 gtk3 xdg-utils

# openSUSE
sudo zypper install libwebkit2gtk-4_1-0 libgtk-3-0 xdg-utils
```

If WebKitGTK is missing, Zhiva still runs, but applications open in your browser instead of a native window.

### Windows

- [WebView2 runtime](https://developer.microsoft.com/microsoft-edge/webview2/): included in Windows 11 and most Windows 10 installs
- [Zhiva Store Auto Install](https://github.com/wxn0brP/Zhiva-windows/releases/download/latest/Zhiva-store-app.exe)

Repository: [https://github.com/wxn0brP/Zhiva-windows](https://github.com/wxn0brP/Zhiva-windows)

## Install on Linux

```bash
curl -fsSL https://raw.githubusercontent.com/wxn0brP/Zhiva/HEAD/install/prepare.sh | bash
export PATH="$HOME/.zhiva/bin:$PATH"
```

The installer checks for Git, WebKitGTK and `xdg-utils`, installs Bun when it is missing, and runs `zhiva doctor` at the end. At that point `~/.zhiva/bin` is not in `PATH` yet, so the check may report the command as missing; export the directory as shown below.

Add the following to your `.bashrc` or `.zshrc` so `zhiva` is available in new shells:

```bash
export PATH="$HOME/.zhiva/bin:$PATH"
```

If you use **zsh**, add the following to your `.zshrc` to enable auto-completion:

```bash
[ -s "$HOME/.zhiva/scripts/_zhiva" ] && source "$HOME/.zhiva/scripts/_zhiva"
```

## Install your first application

```bash
zhiva install Zhiva-store-app
zhiva start Zhiva-store-app
```

## Verify the installation

```bash
zhiva doctor
```

`doctor` checks Bun, Git, WebKitGTK, GTK 3, `xdg-utils`, the `zhiva://` protocol handler, the `zhiva` command in `PATH`, the native engine, `base-lib` and the local database. On Windows it also checks the `zhiva.cmd` launcher, the WebView2 runtime and the registry protocol handler. Every failed check includes a suggested fix.

`zhiva version` shows the CLI commit, engine version, Bun version and the Zhiva root directory.

## Troubleshooting

Installation problems, including WebKitGTK, `PATH` and the `zhiva://` protocol, are covered in [Troubleshooting](troubleshooting.md).

## Next steps

- [Getting Started](getting-started.md): create and run the first application.
- [Development](development.md): the development workflow.
- [Troubleshooting](troubleshooting.md): common problems.
