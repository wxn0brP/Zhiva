# Getting Started with Zhiva

Install Zhiva, create an application, build the frontend and run it.

## Installation

[Install instructions](installation.md)

After installation, you will have the `zhiva` command available in your terminal.

## Creating Your First Application

The easiest way to start a new Zhiva application is the `create` command, which uses the official template.

### 1. Create the Project

```bash
zhiva create my-awesome-app
cd my-awesome-app
```

The command clones the template, removes its git history, sets the metadata in `package.json` and `zhiva.json`, and installs dependencies. In a terminal it asks for the directory, display name, author and description; pass `--author`, `--display-name` and `--description` (or `--no-input`) to skip the questions.

### 2. Understand the Project Structure

The template provides a standard structure for a full-stack Zhiva application:

```
my-awesome-app/
├── src/
│   ├── index.ts         # Backend entry point (runs in Bun)
│   └── browser.ts       # Frontend entry point (runs in the webview)
├── public/
│   └── index.html       # The main HTML file for your UI
├── dist/                # (Generated) Compiled frontend code
├── package.json         # Project dependencies and scripts
├── suglite.json5        # Watch configuration for suglite
└── zhiva.json           # Zhiva-specific application manifest
```

- **`src/index.ts`**: This is your server-side code. You'll set up your static file serving and API endpoints here.
- **`src/browser.ts`**: This is your client-side code. All your frontend logic goes here.
- **`public/index.html`**: The webview loads this file, which then loads your compiled `browser.ts` script.

### 3. Build the Frontend

`zhiva create` already installed the dependencies. Rebuild the frontend after changing `src/browser.ts`:

```bash
# Build the frontend
bun run build
```

The `build` command (defined in `package.json`) compiles `src/browser.ts` and places the output in the `dist/` directory.

#### Automatic rebuilds with suglite

The template ships a `suglite.json5` file:

```json5
{
    cmd: "bun run build",
    watch: ["src"],
}
```

If you have [suglite](https://github.com/wxn0brP/suglite) installed, run it in a second terminal next to `zhiva start .`. It watches `src`, runs `bun run build` after every change and prints the output. Restart the application after a rebuild: the window keeps the JavaScript it loaded at startup.

Any other watcher works too; point it at `src` and run the `build` script.

### 4. Run the Application

You can now run your application using the `zhiva` CLI:

```bash
zhiva start .

# Or

bun run start
```

This will execute the `start` script in your `package.json` (which runs `src/index.ts`), launch the native window, and load your application.

## Next steps

- [Development](development.md): build loop, adding API routes, debugging, environment variables.
- [API Reference](api.md): backend and frontend APIs.
- [Configuration](configuration.md): every `zhiva.json` field.
- [Publishing](publishing.md): distributing an application and the store.
- [Troubleshooting](troubleshooting.md): when something does not start.
