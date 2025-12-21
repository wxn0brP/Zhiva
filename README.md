# Zhiva

Zhiva is a lightweight framework for creating cross-platform desktop applications using modern web technologies like HTML, CSS, and JavaScript/TypeScript. It prioritizes simplicity, performance, and a familiar development experience.

## Installation

[Install instructions](./docs/installation.md)

## Key Features

- **Lightweight & Fast**: Minimal resource usage and fast startup times thanks to its shared architecture and the [Bun](httpss://bun.sh) runtime.
- **Web-Based UI**: Build your user interface with the web technologies you already know.
- **Simple Communication**: Uses a standard HTTP REST API for communication between your frontend and backend, instead of complex IPC.
- **Git-Based Distribution**: Applications are standard Git repositories, making them easy to install, share, and version.
- **Shared Dependencies**: The core engine and libraries are installed once and shared by all Zhiva apps, saving significant disk space.

## Getting Started

To learn how to install Zhiva and build your first application, please see the **[Full Documentation](./docs/index.md)**.

## Project Structure

The Zhiva project is a monorepo containing several key components:

-   **`master`**: The main repository containing this README, high-level documentation, and overall project coordination.
-   **[`base-lib`](https://github.com/wxn0brP/Zhiva-base-lib)**: A TypeScript library that provides the foundational components for building Zhiva applications.
-   **[`native`](https://github.com/wxn0brP/Zhiva-native)**: The core native engine responsible for creating the webview window and handling native system interactions.
-   **[`scripts`](https://github.com/wxn0brP/Zhiva-scripts)**: A collection of utility scripts for managing the application lifecycle.
-   **[`store-app`](https://github.com/wxn0brP/Zhiva-store-app)**: An example application that serves as a simple app store for discovering and managing other Zhiva applications.

## Status

This project is in an early, experimental (Proof of Concept) stage.
The architecture and API are subject to change.

## License

The project is released under the [MIT License](./LICENSE).