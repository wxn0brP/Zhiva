# Configuration: `zhiva.json`

`zhiva.json` describes an application: its metadata, how it is installed, and how it is served. It must be in the repository root. The schema requires `name`; everything else is optional.

## Example

```json
{
    "name": "My Awesome App",
    "version": "1.0.0",
    "description": "What the app does",
    "author": "your-github-name",
    "license": "MIT",
    "branch": "main",
    "shortcut": "md",
    "icon": "./assets/icon.png",
    "win_icon": "./assets/icon.ico",
    "forcePort": 8081,
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
        },
        "vars": {
            "layout": "public/layout.html"
        }
    }
}
```

Do not combine `static` with `url`. Use either one, or neither for a full-stack application. See [Application Types](application-types.md).

## Field reference

### Metadata

| Field | Type | Description |
| --- | --- | --- |
| `name` | string | **Required.** Display name, used for shortcuts and window titles |
| `version` | string | Application version, informational |
| `description` | string | Short description |
| `author` | string | Author name |
| `license` | string | License identifier, e.g. `MIT` |

### Installation

| Field | Type | Description |
| --- | --- | --- |
| `branch` | string | Branch to clone and track. Defaults to the repository default branch |
| `redirect_repo` | `owner/repository` | New location when the repository moves |
| `redirect_zhiva` | `path/to/zhiva.json#branch` | Location of the manifest, when it is not in the repository root |
| `shortcut` | `d`, `m`, `dm`, `md` | Where to create shortcuts: desktop, menu or both |
| `icon` | string | PNG icon for Linux and macOS. Local path or HTTP URL |
| `win_icon` | string | ICO icon for Windows. Local path or HTTP URL |

Icons given as URLs are downloaded into the application directory during installation.

To install without any shortcut, pass `-s n` to `zhiva install`. The value is not stored in `zhiva.json`, because the schema only accepts `d`, `m`, `dm` and `md`.

### Runtime

| Field | Type | Description |
| --- | --- | --- |
| `forcePort` | number | Preferred backend port. Takes precedence over `ZHIVA_PORT` |
| `url` | string | Load a remote URL instead of a local server |
| `static` | object | Serve static files instead of running a backend |

If the preferred port is taken, the server falls back to a random free port. The port actually used is written to `.zhiva-port` in the application directory.

### `static`

| Field | Description |
| --- | --- |
| `dirs` | URL path to directory mapping. Defaults to `{ "/": "." }` |
| `files` | URL path to single-file mapping |
| `redirects` | URL path to redirect target |
| `vars` | Falcon Frame variables passed to the static server |

A leading `-` in a `dirs` key lets several directories share the same URL root; the dashes are stripped before serving.

## Placeholders in the template

The official template ships placeholders instead of real values:

| Placeholder | Replaced with |
| --- | --- |
| `[YOUR NAME]` | author |
| `[YOUR APP NAME]` | application name |
| `[YEAR]` | current year |

`zhiva create` fills them in `package.json`, `zhiva.json`, `LICENSE` and the README. When you clone the template manually, replace them by hand.

## Validation

The official schema is [zhiva.schema.json](https://raw.githubusercontent.com/wxn0brP/Zhiva/master/zhiva.schema.json). It uses JSON Schema draft-07 and rejects unknown fields.

For autocompletion and validation in VS Code, add this to your user or workspace `settings.json`:

```json
"json.schemas": [
    {
        "fileMatch": ["zhiva.json"],
        "url": "https://raw.githubusercontent.com/wxn0brP/Zhiva/master/zhiva.schema.json"
    }
]
```

## Environment overrides

| Variable | Effect |
| --- | --- |
| `ZHIVA_PORT` | Preferred port, lower priority than `forcePort` |
| `ZHIVA_ROOT` | Zhiva data directory, default `~/.zhiva` |
| `ZHIVA_ENGINE` | Path to the native engine binary |
| `ZHIVA_ASSETS` | Path to shared `base-lib` assets |
