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

Zhiva uses the system's shared native webview and the ultra-fast Bun runtime - no bundled Chromium or Node.js. Apps are tiny, start instantly, and communicate via secure REST API instead of complex IPC.

> **Status:** Active development. The project has evolved beyond a PoC but is not yet enterprise-ready.

## Why Zhiva?

Zhiva is a lightweight framework for creating cross-platform desktop applications using modern web technologies. It prioritizes simplicity, performance, and developer experience with these key advantages:

- **One-Time Global Runtime Install**: Install Zhiva once system-wide. Apps deploy via `git clone` with optional lightweight post-install scripts.
- **Tiny Bundle Sizes**: No embedded Chromium or Node.js. Uses native system webviews - resulting in apps often under 10 MB.
- **Bun-Powered Backend**: Execute TypeScript natively with faster startup and better performance.
- **Secure REST API Communication**: Replace complex IPC with familiar REST APIs and built-in authentication.
- **Minimal Configuration**: Focus on your code, not complex setup and tooling.
- **Familiar Web Stack**: Use HTML, CSS, TypeScript/JavaScript, and any frontend framework.

## Project Structure

Zhiva is a multi-repository ecosystem designed for modularity and separation of concerns:

| Repository | Purpose |
|------------|---------|
| **[Zhiva](https://github.com/wxn0brP/Zhiva)** | Main repository with documentation and project coordination |
| **[Zhiva-scripts](https://github.com/wxn0brP/Zhiva-scripts)** | Core CLI tools for application management and deployment |
| **[Zhiva-native](https://github.com/wxn0brP/Zhiva-native)** | Native engine for creating webview windows and system interactions |
| **[Zhiva-base-lib](https://github.com/wxn0brP/Zhiva-base-lib)** | TypeScript library with foundational components for Zhiva apps |
| **[Zhiva-template-app](https://github.com/wxn0brP/Zhiva-template-app)** | Starter template for new Zhiva applications |
| **[Zhiva-store-app](https://github.com/wxn0brP/Zhiva-store-app)** | App store for discovering and managing Zhiva applications |
| **[Zhiva-registry](https://github.com/wxn0brP/Zhiva-registry)** | Registry of verified/banned applications for the store |
| **[zhiva-assets](https://github.com/wxn0brP/zhiva-assets)** | Shared assets (logos, icons, etc.) |
| **[Zhiva-windows](https://github.com/wxn0brP/Zhiva-windows)** | Windows-specific components and installer |
| **[Zhiva-page](https://github.com/wxn0brP/Zhiva-page)** | Official website and marketing materials |

## Getting Started

### 1. Install Zhiva

[Install instructions](docs/installation.md)

### 2. Create from Template

```bash
git clone https://github.com/wxn0brP/Zhiva-template-app my-app
cd my-app
```

### 3. Install Dependencies & Build

```bash
# Install project dependencies
bun install

# Compile the frontend code
bun run build
```

### 4. Run Your App

```bash
zhiva start .
```

A native window will open with your application running.

## Comparison with Other Frameworks

| Feature | Zhiva | Electron | Tauri |
|---------|-------|----------|-------|
| **App Size** | ~5 MB (engine) + 100 KB app | ~120-150 MB | ~5-10 MB |
| **2 Apps Size** | ~5 MB + 200 KB | ~240-300 MB | ~10-20 MB |
| **Memory Usage** | Low | High | Very Low |
| **Backend Runtime** | Bun (Global) | Node.js (Bundled) | Rust (Compiled) |
| **UI Rendering** | Native System Webview | Chromium (bundled) | Native System Webview |
| **Communication** | REST API | IPC | IPC / Command System |
| **Native TypeScript Backend** | Yes (via Bun) | No | No (backend is Rust) |

## Platform Support

- **Windows**: Full support
- **Linux**: Full support
- **macOS**: Untested (implementation exists, but no validation on real hardware)

## License

Zhiva is open source software released under the [MIT License](LICENSE).

## Community & Resources

- [Documentation](https://wxn0brp.github.io/Zhiva/)
- [Web Page](https://wxn0brp.github.io/Zhiva-page)
- [Community Discussions](https://github.com/wxn0brP/Zhiva/discussions)
- [Join our Discord](https://discord.gg/fnHp9w629e)