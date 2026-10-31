# Zhiva

<p align="center">
  <a href="LICENSE">
    <img alt="GitHub license" src="https://img.shields.io/github/license/wxn0brP/Zhiva">
  </a>
  <a href="https://discord.gg/fnHp9w629e">
    <img alt="Join us on Discord" src="https://img.shields.io/badge/Join%20us%20on-Discord-7289DA.svg">
  </a>
  <a href="https://github.com/wxn0brP/Zhiva/stargazers">
    <img alt="GitHub stars" src="https://img.shields.io/github/stars/wxn0brP/Zhiva?style=flat">
  </a>
</p>

<p align="center">
  <img alt="Windows" src="https://img.shields.io/badge/Windows-Supported-blue.svg?style=flat-square&logo=windows">
  <img alt="Linux" src="https://img.shields.io/badge/Linux-Supported-orange.svg?style=flat-square&logo=linux">
  <img alt="macOS" src="https://img.shields.io/badge/macOS-Untested-lightgrey.svg?style=flat-square&logo=apple">
</p>

**Build lightweight cross-platform desktop apps with TypeScript, HTML, and CSS**

Zhiva uses the system webview and the Bun runtime instead of bundling Chromium and Node.js. Applications stay small, start fast, and talk to the backend through an authenticated REST API instead of IPC.

> **Status:** Active development. The project is past the proof of concept, but not yet enterprise-ready.

Supported on Windows and Linux. The macOS build exists but is untested on real hardware.

## Quick Start

Install Zhiva once:

```bash
curl -fsSL https://raw.githubusercontent.com/wxn0brP/Zhiva/HEAD/install/prepare.sh | bash
export PATH="$HOME/.zhiva/bin:$PATH"
```

On Windows, use the [installer](https://github.com/wxn0brP/Zhiva-windows/releases/download/latest/Zhiva-store-app.exe).

Create and run an application:

```bash
zhiva create my-app
cd my-app
bun run build
zhiva start .
```

Detailed instructions: [Installation](docs/installation.md) and [Getting Started](docs/getting-started.md).

## Why Zhiva?

- **Small applications**: no bundled Chromium or Node.js.
- **Bun backend**: TypeScript runs natively, with no server-side build step.
- **REST instead of IPC**: familiar HTTP endpoints with built-in authentication.
- **Git-based distribution**: applications are installed and updated with the CLI.
- **Familiar web stack**: HTML, CSS, TypeScript and any frontend framework.

## Documentation

- [Documentation](https://wxn0brp.github.io/Zhiva/)
- [Development](docs/development.md)
- [API Reference](docs/api.md)
- [CLI Reference](docs/cli.md)
- [Publishing](docs/publishing.md)
- [Troubleshooting](docs/troubleshooting.md)

## Community

- [Discussions](https://github.com/wxn0brP/Zhiva/discussions)
- [Discord](https://discord.gg/fnHp9w629e)

## License

MIT. See [LICENSE](LICENSE).
