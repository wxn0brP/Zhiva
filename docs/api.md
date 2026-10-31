# API Reference

Zhiva applications have two sides:

- **backend** (`src/index.ts`), a Bun process that imports `@wxn0brp/zhiva-base-lib/server` and `@wxn0brp/zhiva-base-lib/api`,
- **frontend** (`src/browser.ts`), compiled JavaScript running in the webview, which imports `@wxn0brp/zhiva-base-lib/front/api`.

They communicate through a local HTTP server. The frontend never talks to the backend directly; the native engine loads a local URL with a secret token attached.

## Backend

### Imports

```typescript
import { app, oneWindow, waitToStart, port } from "@wxn0brp/zhiva-base-lib/server";
import { apiRouter, apiSecret } from "@wxn0brp/zhiva-base-lib/api";
```

The package root re-exports the server module, so `import { app } from "@wxn0brp/zhiva-base-lib"` is equivalent.

### `app`

A Falcon Frame instance.

```typescript
app.static("public");                         // serve ./public at /
app.static("/assets", "./dist/assets");       // serve a directory under a path
app.static("dist", {
    errorIfDirNotFound: false,
});
```

Other methods used by applications:

| Method | Purpose |
| --- | --- |
| `app.static(url, dir?, options?)` | Serve a directory |
| `app.get(url, handler)` | Define a route on the main server |
| `app.use(url, middleware)` | Mount middleware |
| `app.setVar(name, value)` | Set a Falcon Frame variable, e.g. a layout |
| `app.getApp()` | Access the underlying server |

`apiRouter` is mounted automatically at `/zhiva-api`.

### `apiRouter`

A Falcon Frame `Router` for authenticated endpoints.

```typescript
apiRouter.get("/notes", async req => {
    return { err: false, notes: [] };
});

apiRouter.post("/notes", async req => {
    return { err: false, note: req.body };
});
```

Handlers can return:

- an object, sent as a JSON response,
- a string, sent as a text response,
- `undefined`, in which case you should use `res` directly (`res.status(500).send(...)`).

Recommended response shape:

```typescript
{ err: boolean, msg?: string, code?: string, ...data }
```

A request without the `x-zhiva-token` header receives:

```json
{ "err": true, "msg": "Unauthorized", "code": "UNAUTHORIZED" }
```

with HTTP status `401`.

### `oneWindow(path?, title?)`

Creates the application window after the server starts.

```typescript
await oneWindow();
await oneWindow("/settings", "Settings");
```

- `path` defaults to `/`.
- `title` is optional; the window also tracks `document.title` changes.
- Closing the window ends the process.
- If the native engine cannot start, Zhiva shows a notification and opens the URL in the default browser.

### Server lifecycle and ports

The server binds to `127.0.0.1`. The port comes from, in order:

1. `forcePort` in `zhiva.json`,
2. the last port stored in `.zhiva-port` in the application directory,
3. `ZHIVA_PORT`,
4. a random free port.

Because the saved port wins over `ZHIVA_PORT`, use `forcePort` to pin a port, or remove `.zhiva-port` after changing the variable. If the preferred port is taken, the server falls back to a random one.

## Frontend

### Imports

```typescript
import {
    fetchApi,
    fetchApiJson,
    fetchApiPost,
    zhivaApiToken,
} from "@wxn0brp/zhiva-base-lib/front/api";

import { isZhiva } from "@wxn0brp/zhiva-base-lib/front/utils";
```

### `fetchApi(url, opts?, query?)`

Fetches `/zhiva-api/<url>` and adds the `x-zhiva-token` header.

```typescript
const response = await fetchApi("notes", {}, { limit: "10" });
const data = await response.json();
```

- `url` is relative to `/zhiva-api/`.
- `query` values are stringified and appended to the URL.
- The returned value is a normal `Response`, without error handling.

### `fetchApiJson<T>(url, opts?, query?)`

Parses the response as JSON and types it:

```typescript
interface NotesResponse {
    err: boolean;
    notes: string[];
}

const data = await fetchApiJson<NotesResponse>("notes");
```

### `fetchApiPost<T>(url, body?, opts?, query?)`

Sends a JSON `POST` and parses the response:

```typescript
const result = await fetchApiPost<{ err: boolean; id: string }>("notes", {
    text: "hello",
});
```

`fetchApiJson` and `fetchApiPost` do not throw on HTTP errors or on `err: true`. Check the `err` field yourself, or wrap the call.

### Token

The token is generated per process with `crypto.randomBytes`, and the frontend receives it in the window URL as the `zhiva-secret` query parameter. `fetchApi` reads it automatically and exposes it as `zhivaApiToken`.

Do not log the token, copy it into other origins or put it in a URL of a remote page. The token only protects the local API, it is not an account credential.

## Window bindings

The native engine exposes asynchronous functions on `window`, available only inside Zhiva:

| Binding | Purpose |
| --- | --- |
| `zhiva_isApp` | Returns whether the page runs in Zhiva |
| `zhiva_closeApp()` | Closes the window and exits the process |
| `zhiva_setWindowTitle(title)` | Sets the window title |
| `zhiva_openExternal(url)` | Opens a URL in the system browser |
| `zhiva_echo(value)` | Debug helper that prints to the backend log |

The engine also:

- updates the window title when `document.title` changes,
- opens `<a target="_blank">` links in the system browser.

Use `isZhiva` from `@wxn0brp/zhiva-base-lib/front/utils` instead of checking the globals directly.

There are no TypeScript wrappers for the bindings yet. When you call them, guard for their presence:

```typescript
const openExternal = (window as any).zhiva_openExternal;
if (typeof openExternal === "function") await openExternal(url);
```

## Security model

- Only the local server is exposed, on `127.0.0.1`.
- Every `apiRouter` route requires the token, even in development, unless `ZHIVA_DEVELOPMENT_DISABLE_SECURE_TOKEN=I KNOW WHAT I AM DOING` is set.
- The token is per process, not per user.
- Applications run with the full permissions of the user who started them. Install only repositories you trust.
