# Zhiva Documentation

This document provides a more in-depth look at the Zhiva framework, its components, and how to build applications with it.

## Core Concepts

Zhiva's architecture is built around three main components working together:

1.  **The Native Engine (`native`)**: This is a lightweight, cross-platform executable responsible for creating and managing a webview window. It acts as a bridge between the operating system and the web application, exposing APIs for native functionalities like creating windows and showing notifications.

2.  **The Base Library (`base-lib`)**: A TypeScript library that your web application will use. It provides a simple API to communicate with the native engine. Its main responsibilities are:
    *   **Web Server**: It includes a lightweight web server to serve your application's UI.
    *   **Window Management**: Functions to create and manage application windows (e.g., `oneWindow`, `openWindow`).
    *   **System Notifications**: A cross-platform function to display desktop notifications (`showNotification`).
    *   **IPC**: It handles the Inter-Process Communication between your web application (running in the webview) and the native engine process.

3.  **The Web Application**: This is the part you build. It's a standard web application (HTML, CSS, JavaScript/TypeScript) that runs inside the webview. By using `base-lib`, your web app can access native features, making it feel like a desktop application.

## The `zhiva` Command-Line Interface (CLI)

Zhiva comes with a powerful CLI tool named `zhiva` to help you manage your development workflow, from installation to execution. The CLI is located in the `scripts/zhiva` directory.

Here are the main commands available:

| Command         | Alias(es)                  | Description                                            |
| --------------- | -------------------------- | ------------------------------------------------------ |
| `start`         | `run`, `startup`, `o`, `r` | Start a Zhiva application.                             |
| `install`       | `i`, `add`                 | Install an application from a GitHub repository.       |
| `uninstall`     | `rm`, `remove`             | Uninstall an installed application.                    |
| `list`          | `l`, `ls`                  | List installed applications.                           |
| `open`          | `link`                     | Open a URL in a new Zhiva window.                      |
| `self`          | `update-self`, `self-update`| Update the `zhiva` CLI and native engine.              |
| `update`        | `u`, `up`                  | Update all installed Zhiva applications.               |
| `guess`         | `find`                     | Find an application by its name using fuzzy search.    |
| `help`          | `h`                        | Show the help message.                                 |

### Starting an Application

To start an application, use the `start` command:
```bash
zhiva start <app-name>
```
`<app-name>` can be a locally installed app (e.g., `Zhiva-store-app`) or a GitHub repository path (e.g., `username/my-repo`).

The `start` command also accepts options for controlling updates:
- `-e, --engine <mode>`: Controls the update check for the native engine (`0`: auto, `1`: skip, `2`: force).
- `-d, --deps <mode>`: Controls the update check for dependencies (`0`: auto, `1`: skip, `2`: force).

### Installing an Application

To install an application from GitHub:
```bash
zhiva install <app-name-or-repo>
```
For example:
```bash
zhiva install Zhiva-store-app # Installs from wxn0brP/Zhiva-store-app
zhiva install someuser/their-cool-app
```
The `install` command clones the repository into `~/.zhiva/apps`, installs its dependencies, and can create desktop shortcuts.

## Creating a Zhiva Application

Building a new application for Zhiva is straightforward. While the core logic is in your TypeScript/JavaScript code, much of the application's integration with the Zhiva ecosystem is controlled by a `zhiva.json` file in your project's root.

### Configuring with `zhiva.json`

This file allows you to control installation behavior, application metadata, and how it's served.

Here is an example of a `zhiva.json` file with all possible fields:

```json
{
    "name": "My Awesome App",
    "branch": "main",
    "redirect_repo": "new-org/new-repo",
    "redirect_zhiva": "config/zhiva.json#main",
    "desktop": ["share", "desktop"],
    "icon": "./assets/icon.png",
    "win_icon": "./assets/icon.ico",
    "static": {
        "dirs": {
            "/": "./public",
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

#### Field Reference

**Installation & Metadata**

*   `name` (string): The display name of your application. This is used when creating desktop shortcuts.
*   `branch` (string): Specifies the default git branch to clone when a user installs your application.
*   `redirect_repo` (string): If your repository moves, you can use this field to point the `zhiva install` command to the new location. The format is `username/repository`.
*   `redirect_zhiva` (string): If you want to keep your `zhiva.json` in a different location or branch within your repository, you can specify it here. The format is `path/to/zhiva.json#branch`.
*   `desktop` (array of strings): An array specifying where to create shortcuts on the user's system.
    *   `"desktop"`: Creates a shortcut on the user's desktop.
    *   `"share"`: Creates a shortcut in the system's application menu (on Linux and Windows).
*   `icon` (string): A path to an icon file (e.g., `.png`) to be used for the shortcut on Linux and macOS.
*   `win_icon` (string): A path to an icon file (e.g., `.ico`) to be used for the shortcut on Windows.

**Static Application Serving**

*   `static` (object): If this property is present, Zhiva will treat your application as a static web project. Instead of running a start command like `bun run start`, it will launch a built-in static server with the configuration you provide. This is ideal for simple websites or applications built with frameworks that output static files (like static site generators).
    *   `dirs` (object): A mapping of URL paths to local directories you want to serve. For example, `{"/": "./public"}` will serve the contents of the `./public` directory at the root URL of your application.
    *   `files` (object): A mapping of specific URL paths to local files. This is useful for serving single files from specific routes. For example, `{"/config.js": "./conf/app.config.js"}`.
    *   `redirects` (object): A mapping of URL paths to other paths for HTTP redirects. For example, `{"/home": "/"}` will redirect users from `/home` to the root.
