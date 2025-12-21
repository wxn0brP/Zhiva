# Command-Line Interface (CLI)

Zhiva comes with a powerful CLI tool named `zhiva` to help you manage your development workflow, from installation to execution.

## Main Commands

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

---

### `start`

Starts a Zhiva application.

```bash
zhiva start <app-name>
```

The `<app-name>` is always based on its GitHub repository path in the format `user/repo`. However, as a shortcut for the primary developer's apps (`wxn0brP`), you can omit the username.

**Examples:**
```bash
# Start an app from another user
zhiva start some-user/their-cool-app

# Start one of the primary developer's apps (shortcut)
zhiva start Zhiva-store-app
```

The `start` command also accepts options for controlling updates:
- `-e, --engine <mode>`: Controls the update check for the native engine (`0`: auto, `1`: skip, `2`: force).
- `-d, --deps <mode>`: Controls the update check for dependencies (`0`: auto, `1`: skip, `2`: force).

---

### `install`

Installs an application from a GitHub repository.

```bash
zhiva install <app-name-or-repo>
```

Like the `start` command, the app name is based on the `user/repo` path.

**Examples:**
```bash
# Install an app from another user
zhiva install some-user/their-cool-app

# Install an app from the primary developer (wxn0brP)
# This is equivalent to 'zhiva install wxn0brP/Zhiva-store-app'
zhiva install Zhiva-store-app
```

The `install` command clones the repository into `~/.zhiva/apps`, installs its dependencies using `bun install`, runs the `build` script if defined in `package.json`, and can create desktop shortcuts.

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
```

---

### `update`

Updates all installed Zhiva applications by pulling the latest changes from their respective Git repositories.

```bash
zhiva update
```

---

### `self`

Updates the Zhiva framework itself, including the `zhiva` CLI and the shared native engine.

```bash
zhiva self
```