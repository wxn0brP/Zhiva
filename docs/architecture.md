# Zhiva Architecture

Zhiva's architecture is designed to be modular and leverage familiar web development patterns while remaining lightweight.

## Core Components

1.  **The Native Engine**: A lightweight, cross-platform executable responsible for creating and managing a webview window. It acts as the bridge between the operating system and the web application.

2.  **The Bun Runtime**: Zhiva uses [Bun](https://bun.sh/) as its fast JavaScript/TypeScript runtime. The runtime is responsible for executing your application's backend server code (`src/index.ts`) and launching the native engine.

3.  **The Base Library (`base-lib`)**: A shared TypeScript library (`@wxn0brp/zhiva-base-lib`) that provides the core logic and APIs for Zhiva applications. Internally, `base-lib` utilizes the `falcon-frame` library to provide its server-side functionalities.
    *   **Server/API Framework**: It exposes an Express-like API for building your backend:
        *   `app`: An application instance used to configure the web server (e.g., serving static directories with `app.static()`).
        *   `oneWindow`: A function to create the main application window.
        *   `apiRouter`: A router for defining secure API endpoints that are automatically authenticated.
    *   **Convenient Response Handling**: API handlers can simply return a JavaScript `object` or `string`, and the framework automatically formats it as a JSON or text HTTP response, enhancing Developer Experience (DX).
    *   **Client-side API**: For the frontend, it provides helpers to communicate with the native layer for features like window management and notifications.

4.  **Your Application**: A standard web project in a Git repository. It typically consists of:
    *   **Backend Code (e.g., `src/index.ts`)**: Runs on the server using Bun and sets up the server and API routes using the `base-lib`.
    *   **Frontend Code (e.g., `src/browser.ts`)**: Runs in the webview. It's usually compiled into a `dist` folder, which is then served by the `app`.
    *   **Static Assets (e.g., `public/`)**: Contains `index.html` and other assets.

## Communication and Startup Flow

1.  The `zhiva` CLI starts your application's main script (e.g., `bun run src/index.ts`).
2.  Your backend script imports `app` and `oneWindow` from the base library.
3.  You configure the server by calling `app.static("public")` and `app.static("dist")` to serve your HTML, CSS, and compiled JavaScript.
4.  You call `await oneWindow()` to create and display the desktop application window.
5.  Your script also imports `apiRouter` to define secure API endpoints (e.g., `apiRouter.get(...)`).
6.  The native engine loads the `index.html` from your `public` directory.
7.  Your frontend JavaScript (from `dist/`) runs in the webview and makes `fetch` calls to your `apiRouter` endpoints (e.g., `/api/installed`).
8.  The `apiRouter` handles the request, executes your logic, and returns a JSON or text response based on the returned `object` or `string`.

This entire process is secure and self-contained, with the `apiRouter` ensuring that only your application's UI can access the backend APIs.