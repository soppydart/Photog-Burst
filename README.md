# Photog Burst

Photog Burst is an application designed to share and showcase photographs.

## Table of Contents
- [Photog Burst](#photog-burst)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
  - [Running the Application](#running-the-application)
  - [Configuration](#configuration)

## Getting Started

1. Clone the repository:
    ```bash
    git clone https://github.com/soppydart/Photog-Burst.git
    cd Photog-Burst
    ```

2. Set up the environment variables:
    ```bash
    cp .env.template .env
    ```
    Edit the `.env` file to include the necessary configuration values.

## Running the Application

To start the application, follow these steps:

1. Start the Docker containers:
    ```bash
    docker compose -f docker-compose.development.yaml up -d
    ```

2. Run the Go server:
    ```bash
    go run cmd/server/server.go
    ```

This will start the application. The server will be accessible based on the configuration in your `.env` file.

## Configuration

The application uses a `.env` file for configuration. Ensure you have all the necessary environment variables set up in your `.env` file. Refer to the `.env.template` file for the required variables and their expected values.
