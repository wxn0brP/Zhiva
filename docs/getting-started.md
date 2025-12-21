# Getting Started with Zhiva

This guide will walk you through installing Zhiva and creating your first application.

## Installation

[Install instructions](installation.md)

After installation, you will have the `zhiva` command available in your terminal.

## Creating Your First Application

The easiest way to start a new Zhiva application is by using the official template.

### 1. Clone the Template

Use `git` to clone the template repository to your local machine:

```bash
git clone https://github.com/wxn0brP/Zhiva-template-app my-awesome-app
cd my-awesome-app
```

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
└── zhiva.json           # Zhiva-specific application manifest
```

- **`src/index.ts`**: This is your server-side code. You'll set up your static file serving and API endpoints here.
- **`src/browser.ts`**: This is your client-side code. All your frontend logic goes here.
- **`public/index.html`**: The webview loads this file, which then loads your compiled `browser.ts` script.

### 3. Install Dependencies and Build

The template comes with a `package.json` file that defines the necessary dependencies and scripts.

```bash
# Install dependencies
bun install

# Build the frontend
bun run build
```

The `build` command (defined in `package.json`) compiles `src/browser.ts` and places the output in the `dist/` directory.

### 4. Run the Application

You can now run your application using the `zhiva` CLI:

```bash
zhiva start .

# Or

bun run start
```

This will execute the `start` script in your `package.json` (which runs `src/index.ts`), launch the native window, and load your application.

For a full guide on configuration and APIs, see the other documentation pages.
