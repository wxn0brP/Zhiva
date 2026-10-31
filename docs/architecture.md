# Zhiva Architecture

Zhiva is split into small repositories with separate responsibilities.

## Repositories

| Repository | Role |
| --- | --- |
| [Zhiva](https://github.com/wxn0brP/Zhiva) | Documentation, installer and project coordination |
| [Zhiva-scripts](https://github.com/wxn0brP/Zhiva-scripts) | The `zhiva` CLI |
| [Zhiva-native](https://github.com/wxn0brP/Zhiva-native) | Native engine: window, webview, system integration |
| [Zhiva-base-lib](https://github.com/wxn0brP/Zhiva-base-lib) | Server, API router and frontend helpers |
| [Zhiva-template-app](https://github.com/wxn0brP/Zhiva-template-app) | Application template |
| [Zhiva-store-app](https://github.com/wxn0brP/Zhiva-store-app) | Application store |
| [Zhiva-registry](https://github.com/wxn0brP/Zhiva-registry) | Verified and banned application lists |
| [Zhiva-page](https://github.com/wxn0brP/Zhiva-page) | Website |

## Components

1. **The native engine**: a C++ executable using a system webview (WebKitGTK on Linux, WebView2 on Windows). It creates the window, injects the `zhiva_*` bindings, handles the window title and opens external links.
2. **The CLI (`zhiva`)**: installs, updates and starts applications. It also manages the engine, dependencies, shortcuts and the local database.
3. **The Base Library (`base-lib`)**: a TypeScript library imported by applications. It provides a Falcon Frame server, an authenticated `apiRouter` and frontend fetch helpers.
4. **The application**: a Git repository with `zhiva.json`, a frontend and, optionally, a Bun backend.

## Startup flow

1. `zhiva start <app>` resolves the application directory (`~/.zhiva/apps/<owner>/<repo>` for installed apps, or the current directory for `.`).
2. The CLI runs the update check. The engine and dependencies are checked at most once per hour by default; `-e 1 -d 1` skips the checks and `--update` forces them.
3. The CLI runs `bun run start` with `ZHIVA_ROOT`, `ZHIVA_APP_ID` and a `NODE_PATH` that includes the application and the global `~/.zhiva/node_modules`.
4. The backend imports `base-lib` and creates the HTTP server on `127.0.0.1`.
5. `apiRouter` is mounted at `/zhiva-api`. Every request must carry the `x-zhiva-token` header. The token is generated per process with `crypto.randomBytes`.
6. `oneWindow()` starts the native engine. The engine loads the local URL with the token in the `zhiva-secret` query parameter. Frontend helpers read it and attach the header to requests.
7. Closing the window ends the process.

## Modes

- **Full-stack**: the CLI runs the `start` script, the window loads the local server.
- **Static**: the CLI runs a built-in static server and then `oneWindow()`; no application backend exists.
- **URL**: the CLI opens the remote URL in a window. No local server is started.

See [Application Types](application-types.md).

## Data directory

```
~/.zhiva/
├── apps/            # installed applications, <owner>/<repo>
├── bin/zhiva        # CLI symlink
├── master.db/       # Valthera database: installed apps, preferences, cache
├── node_modules/    # shared dependencies, including base-lib
├── scripts/         # cloned Zhiva-scripts repository
├── zhiva(.exe)      # native engine
└── zhiva.nv.txt     # engine version marker
```

Each application directory may contain `.zhiva-port` with the last port it used.

## Install and update flow

- `zhiva install owner/repo` clones the repository into `~/.zhiva/apps`, runs `bun install --production`, runs the `build` script when present, records the app in the database and creates shortcuts.
- Archives are extracted into `~/.zhiva/apps/archive/<name>`.
- `zhiva update` runs `git fetch`, compares `HEAD` with the upstream branch, and for applications with new commits runs `git pull`, `bun install --production` and the `build` script.
- `zhiva self` updates the CLI repository, `base-lib`, the shared dependencies and the engine.

## Security

- The API listens on loopback only.
- Authentication is a per-process random token, delivered to the window through its URL. It protects the local API from other origins, not from other processes running as the same user.
- Applications are not sandboxed and run with the permissions of the current user.
- The engine is built with developer tools enabled, which is convenient during development and should be considered when distributing an application.
