---
title: "Dynamic Traefik Configuration for multi host setup"
description: "In my Home Lab I have multiple hosts, some on the same machine virtualized with proxmox and some on different machines. I want to have a single entrypoint to my homelab protected with Traefik and Authelia. This is how I set it up."
pubDate: 2024-12-10
tags: ["rust", "github-actions", "ci/cd", "cargo"]
keywords: []
draft: false
cover: ./images/traefik-multi-host.png
---

## Overview

My current HomeLab setup looks like this:

_TODO: Insert image_

One major annoyance in my setup has been routing Traefik between multiple hosts. Currently, I’ve achieved this using a static file configuration, where I manually define which ports on each server are used for each service. I then allow these ports through the firewalls on the respective servers.

While this approach works, it requires a lot of manual effort and is prone to errors. To address these issues, I aimed to automate and enhance this process, making it both dynamic and secure. My solution involves leveraging Traefik’s [HTTP Provider](https://doc.traefik.io/traefik/providers/http/) to dynamically update Traefik's configuration from a simple config file.

### Goals

Here’s what I wanted to achieve:

1. Edit a simple config file to define the services I want to expose.
2. Commit changes to the configuration.
3. Validate the configuration using a pre-commit hook.
4. Push the configuration to the repository if validation passes.
5. Trigger a Komodo build action to create a Docker image.
6. Deploy the Docker image in a container on the same Docker network as Traefik.
7. Notify a Discord channel when the new configuration is live.
8. Allow Traefik to read the configuration from a REST endpoint and update accordingly.

### Desired Config Structure

The configuration file is structured as follows:

```toml
# The name of the server is `public`
[server.public]
# IP of the public server
ip = "192.168.50.6"

# Define a service named `example-name` to run on the public server and expose port 5002.
# The service will be accessible at: `example-name.example.com`
[server.public.example-name]
port = 5002
# Optional field to protect the service using Authelia
authelia = true

# Example of a service without Authelia protection
[server.public.example2]
port = 5009
```

---

## Web API Provider

The first step was building the service. I had several technology options for this task. All the service needed to do was:

- Parse a `.toml` file.
- Process the configuration.
- Generate a JSON object to expose through a REST API.

I chose **Rust** for this project because it’s a language I enjoy learning and using. Additionally, parsing `.toml` files and creating JSON is straightforward with the Serde library. Building a simple web API is also easy with `actix-web`.

### CLI Commands

I used **Clap** to handle command-line arguments and implemented two commands:

- `start-api`: Starts the web API.
- `validate`: Validates the configuration file.

The source code is available in my [GitHub repository](https://github.com/Hugo-Persson/traefik-multi-host-mapper).

---

## Pre-Commit Hook

To ensure configuration files are valid before being committed, I created a pre-commit hook.

### Setting Up the Hook

1. Create a directory for hooks and set it as the `core.hooksPath` in Git:

   ```sh
   mkdir hooks
   git config core.hooksPath hooks
   ```

2. Create the `pre-commit` file in the hooks directory with the following content:

   ```bash
   #!/bin/bash

   # If `config.toml` is staged, validate it before committing
   if git diff --cached --name-only | grep -qE "config\.toml$"; then
     echo "Validating config.toml..."
     if ! cargo run -- validate; then
       echo "Configuration is invalid. Please fix it before committing."
       echo "Run 'cargo run -- validate' for details."
       exit 1
     fi
   fi

   echo "Pre-commit hook passed."
   ```

This ensures that any invalid configurations are caught early.

---

## Automated Build and Deployment

I wanted to fully automate the workflow: edit `config.toml`, push changes, and let the system handle the rest. This includes:

1. Building the Docker image.
2. Pushing it to a registry.
3. Deploying it to the server.

### Using Komodo for CI/CD

I used **Komodo**, a Rust-based CI/CD tool, for this process.

#### Setting Up the Registry

1. Add the GitHub Container Registry to Komodo:
   - Navigate to `Settings -> Providers` in Komodo.
   - Configure the provider:
     - **Domain**: `ghcr.io`
     - **Username**: Your GitHub username.
     - **Password**: A personal access token, generated as per [this guide](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-with-a-personal-access-token-classic).

#### Creating a Stack

I created a Komodo stack with the following configuration:

```toml
[[stack]]
name = "multi-host-config-provider"
[stack.config]
server = "server-2zqef"
run_directory = "coordinator/multi-host-mapper"
git_account = "hugo-persson"
repo = "Hugo-Persson/HomeLab" # My private repository for HomeLab configurations
webhook_enabled = false
```

This stack points to a Docker Compose file in the repository's `run_directory`:

```yaml
services:
  traefik-multi-host:
    container_name: traefik-multi-host
    image: ghcr.io/hugo-persson/multi-host-config-provider:latest
    restart: unless-stopped
    networks:
      - traefik # Traefik will connect here to retrieve the configuration
networks:
  traefik:
    external: true
```

---

## Automating Configuration Updates

To automatically update the container whenever `config.toml` changes, I used **Komodo Procedures**. Procedures allow you to define a sequence of steps triggered by specific events.

### Procedure for Updating the Container

Here’s the procedure I created:

```toml
[[procedure]]
name = "update-traefik-multi-host"

# Build the Docker image
[[procedure.config.stage]]
name = "Build Image"
enabled = true
executions = [
  { execution.type = "RunBuild", execution.params.build = "multi-host-config-provider", enabled = true }
]

# Deploy the new container
[[procedure.config.stage]]
name = "Deploy Stack"
enabled = true
executions = [
  { execution.type = "DeployStack", execution.params.stack = "multi-host-config-provider", enabled = true }
]
```

### Adding a Webhook

To trigger the procedure on push, I added a webhook from Komodo to my GitHub repository (`Settings -> Webhooks`). The content type must be `application/json` for it to work.

---

## Integrating with Traefik

Finally, I configured Traefik to read the configuration from the Web API. Since the containers are on the same Docker network, communication is seamless.

I added the following to `traefik.toml`:

```toml
providers:
  http:
    endpoint: "http://traefik-multi-host:8080/json"
```

---

## Conclusion

With this setup, any changes to `config.toml` are automatically validated, built, deployed, and reflected in Traefik’s configuration. Notifications are sent to Discord, keeping me informed every step of the way.

### Future improvements

- Generate UFW rules for the services.
