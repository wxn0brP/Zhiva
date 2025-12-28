# Welcome to Zhiva

Zhiva is a lightweight framework for building cross-platform desktop applications using modern web technologies (HTML, CSS, JavaScript/TypeScript). It combines the ease and familiarity of web UI development with native system integration, while remaining significantly lighter and faster than alternatives like Electron.

## Project Goals

The primary goal of Zhiva is to explore the possibilities of creating minimal, performant desktop applications by leveraging the web ecosystem. It focuses on providing a simple yet powerful bridge between a web-based frontend and native capabilities, without introducing heavy runtime overhead.

## Key Features

- **Web technologies for UI**: Build your application interface with standard web tools and frameworks.
- **Bun-powered backend**: Fast JavaScript/TypeScript runtime for the server and optional application logic.
- **HTTP REST API communication**: Simple, familiar REST endpoints instead of complex IPC mechanisms.
- **Serverless mode**: Run purely static web apps without writing any backend code.
- **URL-based mode**: Load any external URL directly in the app window.
- **Git-based applications**: Each app is a standard Git repository (e.g., hosted on GitHub), enabling easy installation, updates, and versioning.
- **Shared dependencies**: Core components (native engine, base library, etc.) are installed globally once and shared across all applications — saving disk space and simplifying updates.
- **Standard `package.json` support**: Applications can declare their own dependencies and a `"build"` script (e.g., for compiling React, Vite, or Svelte projects).

## Why Choose Zhiva?

- **Lightweight**: Minimal resource usage and small footprint.
- **Fast startup**: Thanks to Bun and shared binaries.
- **Familiar tooling**: Standard web development workflow.
- **Easy distribution**: Share apps as Git repositories.
- **Rapid iteration**: Perfect for tools, utilities, prototypes, and internal apps.

Zhiva is an experimental project aimed at pushing the boundaries of what's possible with lightweight web-to-desktop bridges. It prioritizes simplicity, performance, and developer experience.
