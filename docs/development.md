# Development

This page describes the day-to-day workflow of a Zhiva application: running it, rebuilding the frontend, adding API endpoints and debugging.

## Project

This page assumes the project already exists. See [Getting Started](getting-started.md) for `zhiva create`, the template layout and the build command.

## Run the application

```bash
zhiva start .
```

The command runs the `start` script from `package.json` (the backend) and opens the window when the server is ready. Backend logs are printed to this terminal.

Press `Ctrl+C` in the terminal or close the window to stop the application.

## Build loop

The backend runs TypeScript directly, so `src/index.ts` changes require only a restart. The frontend has to be rebuilt:

1. change `src/browser.ts`,
2. run `bun run build`,
3. restart the application.

For automatic rebuilds, the template ships a `suglite.json5` file:

```json5
{
    cmd: "bun run build",
    watch: ["src"],
}
```

If you use [suglite](https://github.com/wxn0brP/suglite), run `suglite` in a second terminal. Other tools work the same way: point them at `src` and run the `build` script.

Restart the application after a rebuild. The window keeps the JavaScript it loaded at startup.

## Add an API endpoint

Define the route in `src/index.ts`:

```typescript
import { app, oneWindow } from "@wxn0brp/zhiva-base-lib/server";
import { apiRouter } from "@wxn0brp/zhiva-base-lib/api";

app.static("public");
app.static("dist");

apiRouter.get("/notes", async () => {
    return { err: false, notes: [] };
});

apiRouter.post("/notes", async req => {
    return { err: false, note: req.body };
});

oneWindow();
```

Call it from `src/browser.ts`:

```typescript
import { fetchApiJson, fetchApiPost } from "@wxn0brp/zhiva-base-lib/front/api";

interface NotesResponse {
    err: boolean;
    notes: string[];
}

const data = await fetchApiJson<NotesResponse>("notes");
const created = await fetchApiPost<NotesResponse>("notes", { text: "hello" });
```

`fetchApiJson` calls `/zhiva-api/notes` and adds the authentication token automatically. A shared type imported by both files keeps the backend and frontend in sync:

```typescript
// src/types.ts
export interface Note {
    id: string;
    text: string;
}
```

See [API Reference](api.md) for the full backend and frontend API.

## Static assets

`app.static("public")` serves `public/` at `/`, and `app.static("dist")` serves `dist/` at `/`. Both are called in the template. For a layout shared by pages, use Falcon Frame variables:

```typescript
app.setVar("layout", "public/layout.html");
```

Static-only applications do not need any of this; see [Application Types](application-types.md).

## Debugging

- **Backend output**: run the application from a terminal with `zhiva start .`. Output from `console.log`, errors and stack traces appear there.
- **Installed applications**: start them from a terminal with `zhiva start <app-name>`; shortcuts hide the terminal.
- **Environment**: see [Troubleshooting](troubleshooting.md) for the environment check, port issues and missing libraries.
- **Developer tools**: the native engine is built with WebKit/WebView developer tools enabled.
- **Port**: the chosen port is written to `.zhiva-port` in the application directory. If it is taken, the server falls back to a random port.

## Browser preview

Opening the frontend in a regular browser works only for static content. There is no window object and no `zhiva-secret` token, so `fetchApi` calls return `401`. For previewing API-driven apps, mock the endpoints in development, as the store does in `apps/store/src/ui/api-mock.ts`.

## Environment variables

| Variable | Purpose |
| --- | --- |
| `ZHIVA_ROOT` | Zhiva data directory, default `~/.zhiva` |
| `ZHIVA_PORT` | Preferred backend port |
| `ZHIVA_ENGINE` | Path to the native engine binary |
| `ZHIVA_ASSETS` | Path to the shared `base-lib` assets |
| `ZHIVA_DEVELOPMENT_DISABLE_SECURE_TOKEN` | Disables API authentication. Development only, never in a distributed application. |

`forcePort` in `zhiva.json` takes precedence over `ZHIVA_PORT`.

## Next steps

- [API Reference](api.md)
- [Configuration](configuration.md)
- [Publishing](publishing.md)
- [Troubleshooting](troubleshooting.md)
