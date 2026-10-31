# Application Types

Zhiva supports three kinds of applications. The mode is selected in `zhiva.json`; the checks run in this order:

1. `static` is present: static server, no backend process,
2. `url` is present: the window loads a remote URL,
3. neither: full-stack mode, Zhiva runs the `start` script from `package.json`.

`static` and `url` are mutually exclusive. `name` is required by the schema.

## 1. Full-stack (default)

The application runs a Bun backend, usually with `base-lib`, and the window loads the local server.

- **Use cases**: local databases, file system access, shell commands, authenticated APIs, persistent state.
- **Requirements**: `package.json` with a `start` script, `zhiva.json` with a `name`.
- **Communication**: an authenticated REST API through `apiRouter`.

A minimal backend:

```typescript
import { app, oneWindow } from "@wxn0brp/zhiva-base-lib/server";
import { apiRouter } from "@wxn0brp/zhiva-base-lib/api";

app.static("public");
app.static("dist");

apiRouter.get("/hello", async () => {
    return { err: false, msg: "Hello world!" };
});

oneWindow();
```

The frontend calls `fetchApiJson("hello")`. See [API Reference](api.md) and [Development](development.md).

## 2. Static-only

Zhiva serves built files with its own server. No application backend is started, so there is no `apiRouter` and no API token.

- **Use cases**: SPAs built with Vite, React, Vue, Svelte or Angular, documentation sites, static tools.
- **Configuration**: the `static` object in `zhiva.json`.

```json
{
    "name": "My Static App",
    "icon": "./public/icon.png",
    "static": {
        "dirs": {
            "/": "./public",
            "-/": "./dist",
            "/assets": "./dist/assets"
        },
        "files": {
            "/config.js": "./src/config.js"
        },
        "redirects": {
            "/old": "/new"
        }
    }
}
```

- `dirs`: maps URL paths to directories. If omitted, Zhiva serves `.` at `/`.
- Negative prefixes (`-/`) allow several directories to share the same URL root; the leading dashes are stripped.
- `files`: maps a URL to a single file.
- `redirects`: maps a URL to a redirect target.
- `vars`: Falcon Frame variables, for example `{ "layout": "public/layout.html" }`.

Assemble the build output yourself and point `dirs` at it. Installation still runs `bun install --production` and the `build` script when `package.json` defines them, so you can build the assets during install instead of committing `dist/`; if you do not define a build step, commit the built files.

## 3. URL-based

The window loads a remote website. No local server, no API, no token.

- **Use cases**: wrapping an existing web application or service in a window.
- **Configuration**: the `url` field in `zhiva.json`.

```json
{
    "name": "My Wrapped App",
    "icon": "./assets/icon.png",
    "url": "https://example.com"
}
```

The page runs with the permissions of the remote site, not of a Zhiva application. Window bindings such as `zhiva_closeApp` and `zhiva_openExternal` are still injected, but the site may not use them. If the native engine is unavailable, the URL opens in the default browser.

## Choosing a mode

| Requirement | Mode |
| --- | --- |
| Local files, database, shell commands | Full-stack |
| Existing static build, no backend | Static |
| Existing website, no local code | URL |

For a new project, start with `zhiva create`, which generates a full-stack application. Remove the backend only when you are sure the app needs no server-side logic.
