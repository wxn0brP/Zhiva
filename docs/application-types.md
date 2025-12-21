# Application Types

Zhiva supports two main types of applications, giving you the flexibility to choose the right approach for your project's needs.

## 1. Serverless (Static-only)

This is the simplest way to create a Zhiva application and is perfect for pure frontend projects.

- **How it works**: You provide a directory with built static files (e.g., `dist/` or `build/`). Zhiva's built-in web server hosts these files directly.
- **Use cases**:
    - Single Page Applications (SPAs) built with frameworks like React, Vue, Svelte, or Angular.
    - Static websites or documentation sites.
- **Configuration**: To enable this mode, add the `"static"` property to your `zhiva.json`.

### Example

A `zhiva.json` for a static Vite application built into the `dist` directory:

```json
{
    "name": "My Static App",
    "icon": "./public/icon.png",
    "static": {
        "dirs": {
            "/": "./public",
            "-/": "./dist"
        }
    }
}
```

## 2. Full-stack (with Backend)

For applications that require server-side logic, Zhiva provides a powerful backend framework internally powered by the `falcon-frame` library, exposed through its `base-lib`.

- **How it works**: You write your backend code in a main entry file (e.g., `src/index.ts`). You import `app` and `oneWindow` from `@wxn0brp/zhiva-base-lib/server` to serve static files and create the application window. For API endpoints, you import `apiRouter` from `@wxn0brp/zhiva-base-lib/api`. This provides an Express-like API experience.

- **Convenient Response Handling**: For enhanced Developer Experience (DX), API handlers can simply return a JavaScript `object` or `string`, and the framework will automatically convert it into a proper JSON or text HTTP response.

- **Secure `apiRouter`**: This router is designed for secure API communication. It automatically handles authentication, ensuring that only your application's frontend can access its endpoints.

- **Use cases**:
    - Applications that need to interact with a local database or file system.
    - Tools that need to execute shell commands.
    - Applications requiring a persistent and secure state on the server.

- **Configuration**: This is the default mode. If the `"static"` property is **not** present in `zhiva.json`, Zhiva runs the file specified in your `package.json`'s `"start"` script.

### Example

A typical full-stack Zhiva application has separate files for the backend (`src/index.ts`) and frontend (`src/browser.ts`).

**Backend (`src/index.ts`)**
```typescript
// Import the necessary components from Zhiva's base library
import { apiRouter } from "@wxn0brp/zhiva-base-lib/api";
import { app, oneWindow } from "@wxn0brp/zhiva-base-lib/server";

// Serve static assets from the public and dist directories
app.static("public");
app.static("dist");

// Define a secure API endpoint to get a list of installed apps
apiRouter.get("/installed", async (req) => {
    // ... logic to get installed apps ...
    const installedApps = ["wxn0brP/example-app"];
    // Simply return an object, and it will be sent as JSON
    return { apps: installedApps, message: "Apps fetched successfully" };
});

apiRouter.get("/hello", (req) => {
    // Return a string, and it will be sent as plain text
    return "Hello from Zhiva backend!";
});

apiRouter.get("/error", (req, res) => {
    // Like express, you can send a response with res.status()
    res.status(500).send("Internal Server Error");
})

// Create the application window
oneWindow();

// The server is started automatically by Zhiva.
```

**Frontend (`src/browser.ts`)**
Your frontend code (which is compiled into the `dist` folder) can then make simple `fetch` calls.

```typescript
import { fetchApi } from "@wxn0brp/zhiva-base-lib/front/api";

async function getApps() {
    const response = await fetchApi('installed');
    const data = await response.json();
    console.log(data.apps); // -> ["wxn0brP/example-app"]
}

async function sayHello() {
    const response = await fetchApi('hello');
    const text = await response.text();
    console.log(text); // -> "Hello from Zhiva backend!"
}

getApps();
sayHello();
```

In these examples, API handlers can return a JavaScript object or a string directly, providing a clear and concise way to define responses without explicit `res.json()` or `res.send()` calls. The `req` object is available for accessing query parameters, headers, etc.