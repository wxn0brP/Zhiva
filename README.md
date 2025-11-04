# Zhiva

Zhiva is a framework for creating desktop applications using web technologies. It aims to combine the convenience of web-based UI development with the power of native system integration.

## Project Goals

The main goal of Zhiva is to explore the possibilities of building lightweight, cross-platform desktop applications by leveraging modern web technologies. The project focuses on creating a simple yet powerful bridge between the web frontend and the native backend.

## Installation

[Install instructions](./INSTALL.md)

## Architecture Overview

Zhiva's architecture is based on a simple concept: a native process, creates a webview window and runs a local web server. The web application, built with standard web technologies, is then loaded into the webview. A communication bridge allows the web application to interact with the native process, enabling features like window management and system notifications.

## Project Structure

The Zhiva project is a monorepo containing several key components:

-   **`master`**: The main repository containing this README, high-level documentation, and overall project coordination.
-   **[`base-lib`](https://github.com/wxn0brP/Zhiva-base-lib)**: A TypeScript library that provides the foundational components for building Zhiva applications. It includes a web server framework and a client-side API for communicating with the native host.
-   **[`native`](https://github.com/wxn0brP/Zhiva-native)**: The core native engine. It is responsible for creating and managing the webview window, handling native system interactions, and exposing a communication API to the web layer.
-   **[`scripts`](https://github.com/wxn0brP/Zhiva-scripts)**: A collection of utility scripts for setting up the development environment, installing Zhiva applications, and managing the application lifecycle.
-   **[`store-app`](https://github.com/wxn0brP/Zhiva-store-app)**: An example application that serves as a simple app store for discovering and managing other Zhiva applications.

## Status

This project is in a very early, experimental (Proof of Concept) stage. The architecture and API are subject to significant changes.

## License

The project is released under the [MIT License](./LICENSE).