# Troubleshooting

Start with `zhiva doctor`. It checks Bun, Git, WebKitGTK, GTK 3, `xdg-utils`, the protocol handler, `PATH`, the engine, `base-lib` and the database, and prints the command that fixes each failed check. The command exits with code `1` when a required component is missing.

```bash
zhiva doctor
```

## The window does not open, the app opens in the browser

WebKitGTK is missing. The engine cannot start, so Zhiva falls back to the default browser and shows a notification.

Install the native libraries for your distribution:

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

Then run the check again.

## `zhiva: command not found`

`~/.zhiva/bin` is not in `PATH`. Add it to your shell profile:

```bash
export PATH="$HOME/.zhiva/bin:$PATH"
```

Open a new shell, or source the profile, and run `zhiva version`.

## The window is empty or closes immediately

Run the application from a terminal:

```bash
zhiva start <app-name>
```

The backend output, including errors from `src/index.ts`, is printed there. For an installed application, the shortcut hides this output.

Common causes:

- the `start` script in `package.json` fails,
- `public/index.html` is missing,
- the frontend was not built (`bun run build`),
- the port is taken and the window loads a stale instance.

The chosen port is stored in `.zhiva-port` in the application directory.

## Port already in use

Set a fixed port in `zhiva.json`:

```json
{ "forcePort": 8081 }
```

or start with `ZHIVA_PORT=8081 zhiva start .`. If the port is taken, the server falls back to a random free port; the value in `.zhiva-port` is updated.

## `zhiva://` links do nothing

The protocol handler is not registered. Check it with:

```bash
xdg-mime query default x-scheme-handler/zhiva
```

Register it again:

```bash
xdg-mime default zhiva-protocol.desktop x-scheme-handler/zhiva
```

`xdg-utils` must be installed. Re-running the installer also restores the handler.

## The store is empty or shows an error

The store loads its list from the GitHub search API, which allows 10 unauthenticated requests per minute per IP. When the limit is hit, the store shows `Could not load applications` instead of a list. Wait a minute and reload.

If you are offline, the store reports that too. The rest of the CLI works offline for installed applications.

## `install` says the app is not valid

Every application must contain `zhiva.json` in its repository root, and the repository must be a normal Git repository. Check that the repository is not empty and that `zhiva.json` is committed.

## `zhiva install ./file.zip` asks for a name

The name is derived from the archive file name. If the file name is not usable, pass it explicitly:

```bash
zhiva install ./file.zip -n my-app
```

Supported formats: `.zip`, `.tar.gz`, `.tar.bz2`, `.tar.xz`, `.7z`. The matching tool must be available. On Windows, `.zip` uses `unzip` when present, otherwise `tar` or PowerShell `Expand-Archive`; `.7z` requires 7-Zip.

## Updates behave unexpectedly

`zhiva start` checks the engine and dependencies at most once per hour. Control it with:

```bash
zhiva start . -e 1 -d 1      # skip engine and dependency checks
zhiva start . --update       # force both
zhiva self                   # update the CLI, base-lib and engine
```

## Windows

The Windows installer installs Git and Bun when they are missing, adds `%USERPROFILE%\.zhiva\bin` to the user `PATH`, creates the `zhiva.cmd` launcher and registers `zhiva://` links.

**`zhiva` is not recognized**

The `PATH` change applies to new terminals. Close and reopen the terminal.

**Shortcuts do nothing, or `zhiva://` links do not open**

The installer creates `%USERPROFILE%\.zhiva\bin\zhiva.cmd` and the `zhiva://` registry entry. If either is missing, for example after a manual setup, re-run the Windows installer. The environment check reports both as `launcher` and `protocol handler`.

**The window does not open**

The WebView2 runtime is missing. The environment check reports it as `webview2`. Install the [Evergreen WebView2 runtime](https://developer.microsoft.com/microsoft-edge/webview2/) and run the check again.

**Installing an application fails at the clone step**

Git is required. The Windows installer provides it; after a manual setup, install [Git for Windows](https://git-scm.com/download/win) and reopen the terminal. `zhiva install` reports the missing dependency before it tries to clone.

## macOS

The macOS build exists but is untested on real hardware. Windows and Linux are the supported platforms.

## Still stuck

1. `zhiva version`
2. run the app from a terminal and copy the output
3. open an issue at [github.com/wxn0brP/Zhiva/issues](https://github.com/wxn0brP/Zhiva/issues) with the environment check output and the application logs
