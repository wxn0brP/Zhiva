# Publishing an Application

A Zhiva application is a normal Git repository. There is no package registry and no publish step: users install it directly from the repository.

## Checklist

1. `zhiva.json` exists in the repository root and contains a `name`.
2. `package.json` has a `start` script, unless the application is static or URL-based.
3. `bun install` and `bun run build` work from a clean clone.
4. `zhiva start .` opens the application without errors.
5. The repository is public and contains the files the app needs at runtime.
6. The repository has the `Zhiva-app` topic.

## Minimal `zhiva.json`

```json
{
    "name": "My App",
    "description": "What the app does",
    "version": "1.0.0",
    "author": "your-github-name",
    "license": "MIT",
    "icon": "./assets/icon.png",
    "win_icon": "./assets/icon.ico"
}
```

`name` is the display name used for shortcuts. `description`, `version`, `author` and `license` are informational. See [Configuration](configuration.md) for every field.

Icons can be local paths or HTTP URLs. URLs are downloaded during installation.

## Test the installation path

Before publishing, install your own application the way a user would:

```bash
zhiva install your-name/your-app
zhiva start your-name/your-app
```

This checks that the repository is complete, that the `start` script works and that shortcuts are created correctly.

## Discovery in the store

The store and `zhiva search` query the GitHub search API for repositories with the `Zhiva-app` topic:

```
https://api.github.com/search/repositories?q=topic:Zhiva-app
```

Add the topic in the repository settings on GitHub. The store displays the repository description and star count from GitHub.

The search API allows 10 unauthenticated requests per minute per IP. The store reports the rate limit as an error instead of showing an empty list.

## Verified and banned lists

The [Zhiva registry](https://github.com/wxn0brP/Zhiva-registry) contains:

- `verified.txt`: applications reviewed by the maintainers, marked with a Verified badge,
- `banned.txt`: applications hidden from the store.

Both files contain one `owner/repository` per line. Lines starting with `#` are comments. Verification is manual. In the store, an unverified application shows a security warning before installation.

## Install badge

Add the badge to your README:

```markdown
[![Install via Zhiva](https://img.shields.io/badge/Zhiva-install-blue)](https://wxn0brp.github.io/Zhiva-page/i#app=your-name/your-app)
```

The `#app=` parameter is the `owner/repository` identifier. `zhiva create` generates this line with the correct values.

## Updates

Installed applications are updated by pulling from Git:

```bash
zhiva update
```

The command fetches every installed repository, updates the ones with new commits, runs `bun install --production` and the `build` script when present.

Useful `zhiva.json` fields:

- `branch`: the branch to track, when it is not the repository default,
- `redirect_repo`: `owner/new-repository`, when the repository moves,
- `redirect_zhiva`: `path/to/zhiva.json#branch`, when the manifest lives elsewhere.

## Versioning

There is no central version registry. `version` in `zhiva.json` is informational, and the update check compares Git commits. Tag releases if you want to document them, but users receive the latest commit on the tracked branch.

Keep the update path working: if you rename the repository, add `redirect_repo` before the old name stops resolving, otherwise existing installations will fail to update.

## Security

Installing an application runs its code with the permissions of the current user. Zhiva does not sandbox applications. Publish only code you are willing to distribute, and read the source of applications you install.
