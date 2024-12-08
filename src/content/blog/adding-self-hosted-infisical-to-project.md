---
title: "Simplify Secret Management with Infisical: A Guide to Self-Hosting and Integration"
description: "Discover how to self-host and integrate Infisical for streamlined secret management. This guide covers setup, Next.js and Python integration, multi-environment handling, and key rotation, helping you enhance security and simplify workflows across your projects."
pubDate: 2024-12-05T00:00:00.000Z
tags:
  - DevOps
  - Next.js
  - python
  - Secret Management
  - Self-Hosting
  - Docker
  - Security
  - Secrets Rotation
keywords: []
draft: false
cover: ./images/infisical.png
---

# What is Infisical?

**Infisical** is a powerful tool for managing secrets in software projects. It offers features that streamline secret management across multiple environments and services, making it easier to keep your application secure and maintainable.

---

## Self-Hosting Infisical

One of the standout features of Infisical is its ability to be self-hosted. This provides several advantages:

- **Full control over your data:** You always have access to your information, ensuring security and reliability.
- **Cost-effectiveness:** Self-Hosting is free and can run on your existing hardware.
- **Simplified legal compliance:** Using U.S.-based services in the EU often involves complex service agreements due to privacy laws. Hosting Infisical yourself eliminates the need for such agreements and avoids data sharing with third parties.

To self-host Infisical, I followed the [official guide](https://infisical.com/docs/self-hosting/deployment-options/docker-compose) and deployed it using Docker Compose. I configured it behind **Traefik** as a reverse proxy on a subdomain, making it accessible from the internet with a valid SSL certificate. The final setup was reachable at `https://infisical.example.com`.

---

## Integrating Infisical into Our Project

Our project architecture consists of four separate services, which makes secret management particularly challenging. Previously, we used `.env` files to manage secrets. While functional, this approach had several drawbacks:

1. **Lack of visibility:** It was hard to track which secrets were in use.
2. **Tedious rotation:** Updating secrets required manual changes in every `.env` file.
3. **Environment-specific challenges:** Managing separate `.env` files for development, staging, and production was cumbersome.

Infisical addressed these pain points by allowing us to:

- Create multiple projects for different services.
- Define environments (e.g., development, staging, production).
- Use machine and user accounts to manage access control effectively.

### Setting Up Infisical

We created three projects to align with our architecture:

1. **Backend**: Used by our Next.js backend and PostgreSQL database.
2. **Python Utilities**: Supports our Python-based Docker containers and CLI scripts.
3. **Cron Jobs**: Manages secrets for scheduled tasks.

---

## Adding Infisical to Next.js and PostgreSQL in Docker

### Local Development

Setting up Infisical locally was straightforward:

1. Install the CLI:

   ```bash
   brew install infisical/get-cli/infisical
   ```

2. Log in:

   ```bash
   infisical login
   ```

3. Initialize the project:
   ```bash
   infisical init
   ```

Secrets could then be used like this:

- Injected directly:
  ```bash
  infisical run -- pnpm dev
  ```
  I added a script in my `package.json` to fetch secrets and start the development server:

```json
"dev": "infisical run -- next dev",
```

### Docker Setup

Integrating Infisical with Docker for Next.js was more complex due to the need to inject secrets both at **build-time** and **runtime**. Here's how I tackled it:

1. **Build Script**:  
    A `build.sh` script fetches secrets and sets the appropriate environment based on the Git branch.

   ```bash
   #!/bin/bash
   source .infisical_secret
   INFISICAL_TOKEN=$(infisical login --client-id=$CLIENT_ID --client-secret=$CLIENT_SECRET --silent)
   docker build . --build-arg INFISICAL_TOKEN="$INFISICAL_TOKEN" --tag ...:"$CURRENT_BRANCH"
   ```

   **Note**: We are not passing in the secrets directly, but rather a token. This token will expire meaning you cannot access our secret by inspecting the image, our image is private but it is still good practice.

2. **Dockerfile**:  
   Secrets were injected using Infisical's CLI during the build process:

   ```Dockerfile
   ARG INFISICAL_TOKEN
   RUN infisical run --projectId ... --env $BUILD_ENV -- pnpm build
   ```

3. **Deployment**:  
   I used a `docker-compose.yaml` file and a deployment script:

   ```bash
   infisical run --env=staging --projectId ... docker compose up -d
   ```

In the future, I plan to use Infisical’s SDK for runtime secret fetching, simplifying key rotation and environment management.

---

## Adding Infisical to Python Containers

Python integration was simpler due to the lack of separate build and run phases:

1. Create a machine account in Infisical.
2. Use an `entrypoint.sh` script to fetch secrets dynamically:

   ```bash
   INFISICAL_TOKEN=$(infisical login --client-id="$CLIENT_ID" --client-secret="$CLIENT_SECRET" --silent)
   infisical run -- python script.py
   ```

3. Access secrets in Python:
   ```python
   os.environ.get("SECRET")
   ```

---

## Adding Infisical to Cron Jobs

For scheduled tasks, I created a dedicated project with a machine account. The cron scripts dynamically fetch secrets using a helper script:

```bash
INFISICAL_TOKEN=$(infisical login --client-id="$CLIENT_ID" --client-secret="$CLIENT_SECRET" --silent)
SECRET=$(infisical secrets get SECRET --projectId ... --env=prod --plain)
```

---

## Future Improvements

While the current setup uses environment variables for compatibility, this approach injects secrets during build-time, complicating key rotation. Transitioning to Infisical's SDK for runtime secret fetching will:

1. Simplify key rotations.
2. Streamline access control for different environments.

---

Infisical has significantly improved our secret management process, reducing complexity and increasing security. Whether for local development, containerized apps, or cron jobs, its flexibility has been a game-changer.
