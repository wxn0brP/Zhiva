# Welcome to Zhiva

Zhiva is a lightweight framework for building cross-platform desktop applications with HTML, CSS and TypeScript. It uses the system webview and the Bun runtime instead of bundling a browser and Node.js, so applications stay small and start fast.

The backend is a normal Bun process, the frontend is served by a local HTTP server, and the two communicate through a small authenticated REST API instead of IPC.

## Quick Start

### 1. Install Zhiva

```bash
curl -fsSL https://raw.githubusercontent.com/wxn0brP/Zhiva/HEAD/install/prepare.sh | bash
export PATH="$HOME/.zhiva/bin:$PATH"
```

On Windows, use the [installer](https://github.com/wxn0brP/Zhiva-windows/releases/download/latest/Zhiva-store-app.exe).

### 2. Install an application

```bash
zhiva install Zhiva-store-app
zhiva start Zhiva-store-app
```

### 3. Create your own application

```bash
zhiva create my-app
cd my-app
bun run build
zhiva start .
```

## Key Features

- **System webview**: uses WebKitGTK on Linux and WebView2 on Windows, without a bundled Chromium.
- **Bun backend**: TypeScript runs natively, without a build step on the server side.
- **REST instead of IPC**: the frontend calls `apiRouter` endpoints with helpers from `base-lib`.
- **Git-based distribution**: applications are regular Git repositories, installed and updated with the CLI.
- **Static and URL modes**: serve a built SPA, or wrap an existing website in a window.
- **Shared runtime**: the engine, `base-lib` and dependencies are installed once in `~/.zhiva`.

## Documentation

| Page | What it covers |
| --- | --- |
| [Installation](installation.md) | Requirements, installation, verifying the setup |
| [Getting Started](getting-started.md) | Creating and running the first application |
| [Development](development.md) | Project structure, build loop, debugging, environment variables |
| [API Reference](api.md) | Backend `app`/`apiRouter`, frontend `fetchApi` helpers, window bindings |
| [CLI Reference](cli.md) | Every command, option and exit code |
| [Configuration](configuration.md) | All `zhiva.json` fields |
| [Application Types](application-types.md) | Full-stack, static and URL-based applications |
| [Publishing](publishing.md) | Distributing an application and getting it into the store |
| [Architecture](architecture.md) | How the CLI, engine, Base Library and applications fit together |
| [Troubleshooting](troubleshooting.md) | Common problems and their fixes |

## Platform Support

- **Linux**: supported. Requires WebKitGTK 4.1 and GTK 3.
- **Windows**: supported. Requires the WebView2 runtime.
- **macOS**: the implementation exists but is untested on real hardware.

Zhiva is an experimental project. It is used for tools, utilities, prototypes and internal applications.
