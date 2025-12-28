# Configuration: zhiva.json

The `zhiva.json` file is the heart of a Zhiva application. It allows you to control installation behavior, application metadata, and how the application is served.

## Example `zhiva.json`

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
            "-/": "./dist",
            "/assets": "./dist/assets"
        },
        "files": {
            "/config.js": "./src/config.js"
        },
        "redirects": {
            "/old": "/new"
        }
    },
    "url": "https://example.com"
}
```

---

## Field Reference

### Installation & Metadata

*   `name` (string): The display name of your application. This is used when creating desktop shortcuts.
*   `branch` (string): Specifies the default git branch to clone when a user installs your application. Defaults to the repository's default branch.
*   `redirect_repo` (string): If your repository moves, you can use this field to point the `zhiva install` command to the new location. The format is `username/repository`.
*   `redirect_zhiva` (string): If you want to keep your `zhiva.json` in a different location or branch within your repository, you can specify it here. The format is `path/to/zhiva.json#branch`.
*   `desktop` (array of strings): An array specifying where to create shortcuts on the user's system.
    *   `"desktop"`: Creates a shortcut on the user's desktop.
    *   `"share"`: Creates a shortcut in the system's application menu (on Linux and Windows).
*   `icon` (string): A path to an icon file (`.png`) to be used for the shortcut on Linux and macOS. This can also be an HTTP/HTTPS URL, from which Zhiva will download the icon during installation.
*   `win_icon` (string): A path to an icon file (`.ico`) to be used for the shortcut on Windows. This can also be an HTTP/HTTPS URL, from which Zhiva will download the icon during installation.

---

### Application Serving

You can define how your application is served. You can either run a full-stack application, a simple static server, or load a remote URL.

*   **Full-stack (Default)**: If neither `static` nor `url` property is defined, Zhiva expects a `start` script in your `package.json`. Zhiva will run your server to handle all file serving and API logic.

*   **Static Server (`static`)**: If the `static` property is present, Zhiva will treat your application as a static web project. Instead of running a start command, it will launch a built-in static server with the configuration you provide. This is ideal for simple websites or applications built with frameworks that output static files (like Vite, React, or static site generators).

    *   `dirs` (object): A mapping of URL paths to local directories you want to serve.
        *   Example: `{"/": "./public"}` will serve the contents of the `./public` directory at the root URL of your application.
        *   To serve multiple directories at the same root URL, you can use a negative path prefix. For example, `{"/": "public", "-/": "./dist"}` will serve the contents of both the `./public` and `./dist` directories at the root.
    *   `files` (object): A mapping of specific URL paths to local files. This is useful for serving single files from specific routes. Example: `{"/config.js": "./conf/app.config.js"}`.
    *   `redirects` (object): A mapping of URL paths to other paths for HTTP redirects. Example: `{"/home": "/"}`.

*   **Remote URL (`url`)**: If the `url` property is present, Zhiva will open the specified URL directly in the application window. This is useful for wrapping existing web applications or websites. The `url` and `static` properties are mutually exclusive.

    *   Example: `"url": "https://example.com"` will load the Example website.

## Validating `zhiva.json`

To get autocompletion and validation for `zhiva.json` in VS Code, add the following to your user or workspace `settings.json` file:

```json
"json.schemas": [
    {
        "fileMatch": [
            "zhiva.json"
        ],
        "url": "https://raw.githubusercontent.com/wxn0brP/Zhiva/master/zhiva.schema.json"
    }
],
```
This uses the official [zhiva.schema.json](https://raw.githubusercontent.com/wxn0brP/Zhiva/master/zhiva.schema.json) for validation.
