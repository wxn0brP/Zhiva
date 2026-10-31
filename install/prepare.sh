#!/bin/bash

if ! command -v bun &> /dev/null; then
    echo "[Z-IST-1-01] bun is not installed."
    echo "[Z-IST-1-02] Installing bun..."
    curl -fsSL https://bun.sh/install | bash

    export PATH="$HOME/.bun/bin:$PATH"
    echo "[Z-IST-1-03] Added ~/.bun/bin to PATH for current session."
    echo "[Z-IST-1-04] 💜 Don't forget to add 'export PATH=\"\$HOME/.bun/bin:\$PATH\"' to your ~/.bashrc or ~/.zshrc."
else
    echo "[Z-IST-1-06] 💜 bun $(bun --version) is installed."

    BUN_MAJOR="$(bun --version | cut -d. -f1)"
    if [ "$BUN_MAJOR" -lt 1 ] 2>/dev/null; then
        echo "[Z-IST-1-21] Warning: bun $(bun --version) is old. Update it with 'bun upgrade'."
    fi
fi

if ! command -v git &> /dev/null; then
    echo "[Z-IST-1-07] Error: git is not installed. Please install git manually."
    exit 1
else
    echo "[Z-IST-1-08] 💜 git is installed."
fi

if [ "$(uname -s)" = "Linux" ]; then
    echo "[Z-IST-1-15] Checking system libraries..."

    if command -v apt-get &> /dev/null; then
        INSTALL_HINT="sudo apt install libwebkit2gtk-4.1-0 libgtk-3-0 xdg-utils"
    elif command -v dnf &> /dev/null; then
        INSTALL_HINT="sudo dnf install webkit2gtk4.1 gtk3 xdg-utils"
    elif command -v pacman &> /dev/null; then
        INSTALL_HINT="sudo pacman -S webkit2gtk-4.1 gtk3 xdg-utils"
    elif command -v zypper &> /dev/null; then
        INSTALL_HINT="sudo zypper install libwebkit2gtk-4_1-0 libgtk-3-0 xdg-utils"
    else
        INSTALL_HINT="install the WebKitGTK 4.1, GTK 3 and xdg-utils packages for your distribution"
    fi

    WEBKIT_OK=0
    if command -v pkg-config &> /dev/null; then
        if pkg-config --exists webkit2gtk-4.1 2>/dev/null || pkg-config --exists webkit2gtk-4.0 2>/dev/null; then
            WEBKIT_OK=1
        fi
    fi
    if [ $WEBKIT_OK -eq 0 ] && command -v ldconfig &> /dev/null; then
        if ldconfig -p 2>/dev/null | grep -q 'libwebkit2gtk-4.1' || ldconfig -p 2>/dev/null | grep -q 'libwebkit2gtk-4.0'; then
            WEBKIT_OK=1
        fi
    fi

    if [ $WEBKIT_OK -eq 1 ]; then
        echo "[Z-IST-1-16] 💜 WebKitGTK found."
    else
        echo "[Z-IST-1-17] Warning: WebKitGTK was not found. The native window will not start;"
        echo "             applications will open in your browser instead."
        echo "             Install it with: $INSTALL_HINT"
    fi

    if ! command -v xdg-open &> /dev/null || ! command -v xdg-mime &> /dev/null; then
        echo "[Z-IST-1-18] Warning: xdg-utils was not found. Desktop shortcuts and the"
        echo "             zhiva:// protocol will not work."
        echo "             Install them with: $INSTALL_HINT"
    fi
fi

mkdir -p $HOME/.zhiva/bin
if [ ! -d $HOME/.zhiva/scripts ]; then
    git clone https://github.com/wxn0brP/Zhiva-scripts.git $HOME/.zhiva/scripts
else
    git -C $HOME/.zhiva/scripts pull
fi
cp $HOME/.zhiva/scripts/package.json $HOME/.zhiva/package.json
cd $HOME/.zhiva
bun install --production --force
bun run $HOME/.zhiva/scripts/src/cli.ts self
echo "[Z-IST-1-09] 💜 Zhiva-scripts is installed."

ln -s $HOME/.zhiva/scripts/src/cli.ts $HOME/.zhiva/bin/zhiva
chmod +x $HOME/.zhiva/bin/*

echo "[Z-IST-1-10] 💜 Installing Zhiva protocol..."

DESKTOP_FILE="$HOME/.local/share/applications/zhiva-protocol.desktop"
mkdir -p "$(dirname "$DESKTOP_FILE")"

BUN_BIN="$(command -v bun)"
[ -z "$BUN_BIN" ] && BUN_BIN="$HOME/.bun/bin/bun"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Zhiva
Exec=sh -c '"$BUN_BIN" run "$HOME/.zhiva/bin/zhiva" protocol %u'
Type=Application
Terminal=false
MimeType=x-scheme-handler/zhiva
EOF

chmod +x "$DESKTOP_FILE"

CURRENT_HANDLER=$(xdg-mime query default x-scheme-handler/zhiva 2>/dev/null || echo "")
if [ "$CURRENT_HANDLER" != "$(basename "$DESKTOP_FILE")" ]; then
    if xdg-mime default "$(basename "$DESKTOP_FILE")" x-scheme-handler/zhiva; then
        echo "[Z-IST-1-11] Zhiva protocol installed!"
    else
        echo "[Z-IST-1-12] Warning: Failed to register Zhiva protocol. Make sure xdg-utils is installed."
    fi
else
    echo "[Z-IST-1-13] Zhiva protocol is already registered."
fi

echo "[Z-IST-1-14] 💜 Zhiva command is installed."

echo "[Z-IST-1-20] Checking the installation..."

if ! "$HOME/.zhiva/bin/zhiva" doctor; then
    echo "[Z-IST-1-21] Some checks failed. Fix them before installing applications."
fi

case ":$PATH:" in
    *":$HOME/.zhiva/bin:"*)
        ;;
    *)
        echo "[Z-IST-1-22] Zhiva is installed, but $HOME/.zhiva/bin is not in your PATH."
        echo "             Add this line to your ~/.bashrc or ~/.zshrc:"
        echo "             export PATH=\"\$HOME/.zhiva/bin:\$PATH\""
        ;;
esac
