---
title: "Migrating to Komodo with Git-Based Resource Syncs for my HomeLab"
description: "Learn how I transitioned my HomeLab setup from Portainer to Komodo using Git-based Resource Syncs. This guide covers setting up, deploying, and syncing configurations for improved replicability and version control."
pubDate: 2024-12-17T00:00:00.000Z
tags:
  - HomeLab
  - Resource Sync
  - Configuration Management
  - Replicability
  - DevOps
  - Self-Hosting
  - Automation
  - Docker
keywords: []
draft: false
cover: ./images/komodo-resource-sync.png
---

# Migrating My HomeLab Setup to Komodo

A couple of weeks ago, I decided to migrate my HomeLab setup from Portainer to Komodo. While I’ve enjoyed the process of configuring everything through the UI, I was concerned about replicability since all my configurations were done directly in the UI.

That’s when I discovered [Resource Syncs](https://komodo.evercode.se/resource-syncs). Resource Syncs allow you to define your configuration in TOML files, which Komodo can read from. These files can be placed in a Git repository, enabling Komodo to automatically deploy changes on push. Additionally, changes made in the UI can be synced back to the Git repository. This feature is incredible—not only does it ensure replicability by securely storing your configurations in your Git repository, but it also provides version control. You can revert changes and easily restore earlier configurations.

In this post, I’ll walk you through how to set this up in three steps:

1. Setting up a Resource Sync, creating a Resource Sync, and configuring the Git repository.
2. Pushing changes to deploy them in Komodo.
3. Storing UI changes in the Git repository.

---

## Setting Up a Resource Sync

There are two types of Resource Syncs: **Managed** and **Unmanaged**. Managed Resource Syncs ensure that your Komodo instance and the Resource Sync configuration stay synchronized. If there are discrepancies between the two, actions must be taken to bring them back into sync. For this guide, I’ll focus on the Managed option.

### Key Concepts of Resource Syncs

Before we begin, it’s important to understand a few key concepts:

- **Refresh**  
  This pulls the latest changes from the Git repository but does not execute them. Think of it like a `git diff`, allowing you to see the differences between the Resource Sync files and the Komodo instance state.

- **Execute Change**  
  This applies a specific change from a Resource Sync file to the Komodo instance, similar to accepting a single "hunk" during a Git merge.

- **Execute Sync**  
  This applies all changes from the Resource Sync file to the Komodo instance. It’s akin to "accept all their changes" in a Git merge.

- **Commit**  
  This updates the Resource Sync file to reflect the current state of the Komodo instance, effectively overriding the file. It works like a Git commit followed by a force push.

### Step 1: Setting Up the Git Repository

The first step was creating a Git repository to store my configuration. Initially, I considered adding this to my existing HomeLab repository. However, this posed a challenge: if Komodo executed an "Execute Sync" on every push, it could unintentionally overwrite UI changes when I edited my Compose files. To avoid this, I created a separate repository called [homelab-komodo-resources](https://github.com/Hugo-Persson/homelab-komodo-resources).

In this repository, I created a `default.toml` file to store my configuration. Initially, the file was empty because I wanted to commit my existing UI configurations to it.

Next, I created a Resource Sync in Komodo. I named it `homelab-komodo-resources` and configured it as follows:

```toml
[[resource_sync]]
name = "komodo-resource-sync"
[resource_sync.config]
repo = "hugo-persson/homelab-komodo-resources"
git_account = "hugo-persson"
resource_path = ["default.toml"]
managed = true
```

To populate the `default.toml` file, I navigated to the Resource Sync in Komodo and clicked **Refresh**. This pulled the latest changes from the Git repository and showed what needed to be updated. Since nothing was defined in the configuration, everything was marked for deletion. I then clicked **Commit Changes**, which created a commit in the Git repository with the current state of the Komodo instance.

---

## Triggering Sync on Push

To trigger synchronization automatically on push, follow these steps:

1. Copy the webhook URL: `Webhook Url - Execute Sync`.
2. In your GitHub repository, navigate to **Settings > Webhooks > Add Webhook**.
3. Add the webhook URL and set the content type to `application/json`.
4. Add a secret key. This should match the `WEBHOOK_SECRET` defined in your configuration.
5. Save the settings. 🎉

Now, whenever you push changes to your Git repository, they’ll be automatically deployed to Komodo.

### Pre Push Hook

The current workflow is great but has one major flaw. If I push something while having uncommited changes in the UI I will lose my UI changes. To avoid this, I created a pre-push hook that checks if there are any uncommited changes in the UI. If there are, the push will be aborted. I used the amazing Ko

```ts
import { KomodoClient, Types } from "komodo_client";
import "dotenv/config";
import { exit } from "process";

async function main() {
  const komodo = KomodoClient("https://komodo.evercode.se", {
    type: "api-key",
    params: {
      key: process.env.API_KEY!,
      secret: process.env.API_SECRET!,
    },
  });
  try {
    const id = "komodo-resource-sync";
    const res = await komodo.write("RefreshResourceSyncPending", {
      sync: id,
    });
    const updates = res.info?.resource_updates ?? [];
    if (updates.length > 0) {
      console.error("Updates are pending", updates);
      exit(1);
    }
    exit(0);
  } catch (e) {
    console.log("error", e);
    exit(1);
  }
}
main();
```

---

## Storing UI Changes in the Git Repository

If you make changes in the Komodo UI, you can easily store these updates in your Git repository. To do this:

1. Navigate to the Resource Sync in Komodo.
2. Click **Commit Changes**.
   This will create a commit with the current state of the Komodo instance and push it to your Git repository.

---

By combining the intuitive UI of Komodo with the power of Git-based Resource Syncs, I’ve achieved a seamless and replicable HomeLab setup. I hope this guide helps you get started with your own setup!

```

```
