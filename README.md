# Photog Burst

A file-sharing application.

## Table of Contents
- [Photog Burst](#photog-burst)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
  - [Running the Application](#running-the-application)
  - [Configuration](#configuration)


## Getting Started

### Prerequisites

- Golang
- Docker
- Docker Compose

### Installation

1. Clone the repository:
```bash
git clone https://github.com/soppydart/Photog-Burst.git
cd Photog-Burst
```

2. Install dependencies:
```bash
go mod download
```

3. Set up the environment variables:
```bash
cp .env.example .env
```

## Running the Application

To start the application, run:

```bash
docker compose up
```
This will start the application on the default port specified in the Docker Compose configuration.

## Configuration

The application uses a .env file for configuration. Ensure you have all the necessary environment variables set up in your .env file.