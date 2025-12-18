#!/bin/bash

if ! command -v bun &> /dev/null; then
    echo "[Z-IST-1-01] bun is not installed."
    read -p "Do you want to install bun? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        echo "[Z-IST-1-02] Installing bun..."
        curl -fsSL https://bun.sh/install | bash

        export PATH="$HOME/.bun/bin:$PATH"
        echo "[Z-IST-1-03] Added ~/.bun/bin to PATH for current session."
        echo "[Z-IST-1-04] 💜 Don't forget to add 'export PATH=\"\$HOME/.bun/bin:\$PATH\"' to your ~/.bashrc or ~/.zshrc."
    else
        echo "[Z-IST-1-05] Skipped bun installation."
        exit 1
    fi
else
    echo "[Z-IST-1-06] 💜 bun is installed."
fi

if ! command -v git &> /dev/null; then
    echo "[Z-IST-1-07] Error: git is not installed. Please install git manually."
    exit 1
else
    echo "[Z-IST-1-08] 💜 git is installed."
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

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Zhiva
Exec=sh -c '$HOME/.bun/bin/bun run $HOME/.zhiva/bin/zhiva protocol %u'
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