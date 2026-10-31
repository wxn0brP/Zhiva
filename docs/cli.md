# Command-Line Interface (CLI)

The `zhiva` CLI installs, updates and starts applications.

## Main Commands

| Command   | Alias(es)                   | Description                                          |
| --------- | --------------------------- | ---------------------------------------------------- |
| `start`   | `run`, `startup`, `o`, `r`  | Start a Zhiva application.                           |
| `install` | `i`, `add`                  | Install an application from a GitHub repository.     |
| `create`  | `new`                       | Create a new application from a template.            |
| `uninstall` | `rm`, `remove`            | Uninstall an installed application.                  |
| `list`    | `l`, `ls`                   | List installed applications.                         |
| `open`    | `link`                      | Open a URL in a new Zhiva window.                    |
| `self`    | `update-self`, `self-update` | Update the `zhiva` CLI and native engine.            |
| `update`  | `u`, `up`                   | Update all installed Zhiva applications.             |
| `guess`   | `find`                      | Find an application by its name using fuzzy search.  |
| `search`  | `s`                         | Search the registry for applications.                |
| `cdf`     | `create-desktop-file`       | Create desktop shortcuts for an installed app.       |
| `db`      |                             | Interact with the Zhiva database.                    |
| `protocol` |                            | Handle `zhiva://` links.                             |
| `doctor`  |                             | Check the Zhiva installation.                        |
| `version` | `--version`, `-v`           | Show version information.                            |
| `help`    | `h`                         | Show the help message.                               |

---

### `start`

Starts a Zhiva application.

```bash
zhiva start <app-name>
```

The `<app-name>` is always based on its GitHub repository path in the format `user/repo`. However, as a shortcut for the primary developer's apps (`wxn0brP`), you can omit the username.

Use `.` to start the application in the current directory.

**Examples:**
```bash
# Start an app from another user
zhiva start some-user/their-cool-app

# Start one of the primary developer's apps (shortcut)
zhiva start Zhiva-store-app

# Start the project in the current directory
zhiva start .
```

By default the engine and dependencies are checked for updates at most once per hour. Use `-e 1` and `-d 1` to disable those checks, or `-u` to force an update now.

- `-e, --engine <mode>`: Controls the update check for the native engine (`0`: auto, at most once per hour, `1`: skip, `2`: force).
- `-d, --deps <mode>`: Controls the update check for dependencies (`0`: auto, at most once per hour, `1`: skip, `2`: force).
- `-u, --update`: Forces the engine and dependency update (`-e 2 -d 2`).

---

### `install`

Installs an application from a GitHub repository or an archive.

```bash
zhiva install <app-name-or-repo>
zhiva install ./my-app.zip
```

Like the `start` command, the app name is based on the `user/repo` path.

Archives are installed under `archive/<file-name>`. When the name cannot be derived from the file name, pass it with `-n <name>`.

**Examples:**
```bash
# Install an app from another user
zhiva install some-user/their-cool-app

# Install an app from the primary developer (wxn0brP)
# This is equivalent to 'zhiva install wxn0brP/Zhiva-store-app'
zhiva install Zhiva-store-app

# Install a local archive
zhiva install ./my-app.zip
```

The `install` command clones the repository into `~/.zhiva/apps`, installs its dependencies using `bun install`, runs the `build` script if defined in `package.json`, and can create desktop shortcuts.

---

### `create`

Creates a new application from the template.

```bash
zhiva create [name]
```

The command clones the official template, removes its git history, sets the metadata in `package.json` and `zhiva.json`, replaces the `[YOUR NAME]`, `[YOUR APP NAME]` and `[YEAR]` placeholders, points the "Install via Zhiva" badge in the README at the new repository, and installs dependencies.

When the name is omitted and the command runs in a terminal, it asks for the application directory first. When no metadata flags are passed, it then asks for the display name, author and description. If any of `--author`, `--display-name` or `--description` is passed, the command runs without questions.

**Options:**
- `-t, --template <url>`: Use another template repository.
- `-a, --author <name>`: Author name. Defaults to `git config user.name`.
- `--display-name <name>`: Display name. Defaults to a name derived from the directory.
- `--description <text>`: Description. Defaults to the display name.
- `--no-install`: Skip dependency installation.
- `--no-input`: Do not ask questions, use defaults.

**Examples:**
```bash
zhiva create my-app
zhiva create my-app --author wxn0brP --description "My first app"
zhiva create my-app --no-input
zhiva create my-app --template /path/to/local/template
cd my-app
bun run build
zhiva start .
```

A local template must be a Git repository. `git clone` copies commits, not uncommitted changes, so commit the template first or create a temporary repository with the files you want.

---

### `uninstall`

Removes a previously installed application.

```bash
zhiva uninstall <app-name>
```

---

### `list`

Lists all applications installed on your system.

```bash
zhiva list
zhiva list --json
```

`--json` prints an array of application names.

---

### `update`

Updates all installed Zhiva applications by pulling the latest changes from their respective Git repositories.

```bash
zhiva update
zhiva update --json
```

`--json` prints a map of application names to `true` (update available) or `false` (up to date) and does not modify anything.

---

### `self`

Updates the Zhiva framework itself, including the `zhiva` CLI, the shared `base-lib` and the native engine.

```bash
zhiva self
```

---

### `search`

Searches the registry for applications. Without arguments it lists every application.

```bash
zhiva search
zhiva search store
```

**Options:**
- `--json`: Print the result as JSON.
- `--pretty`: Print the JSON result with indentation.

Each entry contains the repository name, description, star count and verification status.

---

### `guess`

Finds installed applications by name using fuzzy matching. Without arguments it lists every installed application.

```bash
zhiva guess
zhiva guess store
```

---

### `cdf`

Creates desktop shortcuts for an installed application.

```bash
zhiva cdf <app-name> [flags]
```

**Flags:**
- `d`: create a desktop shortcut
- `m`: create a menu entry

Defaults to `dm` when no flags are given.

**Examples:**
```bash
zhiva cdf Zhiva-store-app d
zhiva cdf username/repo dm
```

---

### `db`

Low-level access to the Valthera database in `~/.zhiva/master.db`. The first argument is `collection.method`; JSON5 objects and arrays are parsed.

```bash
zhiva db apps.find
zhiva db pref.find
```

The result is printed as JSON. The command is meant for debugging, not for application code.

---

### `protocol`

Handles `zhiva://` links on Linux. It is registered as a desktop protocol handler by the installer and is normally called by the system, not by hand.

Supported commands:

- `zhiva://start/<app>`
- `zhiva://install/<app>`
- `zhiva://install+start/<app>`
- `zhiva://open/<url>`

```bash
zhiva protocol zhiva://start/Zhiva-store-app
```

---

### `doctor`

Checks the installation and prints one line per check with a suggested fix for failures.

```bash
zhiva doctor
```

It verifies Bun, Git, WebKitGTK, GTK 3, `xdg-utils`, the `zhiva://` handler, `PATH`, the native engine, `base-lib` and the database. On Windows it also checks the `zhiva.cmd` launcher, WebView2 and the registry protocol handler. The command exits with code `1` when a required component is missing.

---

### `version`

Shows the CLI version (or the git commit when no version is set), the engine version, the Bun version and the Zhiva root directory.

```bash
zhiva version
zhiva --version
zhiva version --json
```

---

## Exit codes

| Code | Meaning |
| --- | --- |
| `0` | Success |
| `1` | The command failed, or `zhiva doctor` found a missing component |

Errors are printed to stderr. Commands that offer `--json` print machine-readable output to stdout without colors.
