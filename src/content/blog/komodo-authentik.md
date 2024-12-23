---
title: "Setting Up Authentik for Komodo: A Step-by-Step Guide"
description: "In this post, I will walk you through the process of integrating Komodo with Authentik for secure authentication using OIDC. Giving you a streamlined and secure authentication process."
pubDate: 2024-12-23
tags:
  - Komodo
  - Authentik
  - OAuth2
  - DevOps
  - Docker
keywords: []
draft: false
cover: ./images/authentik-komodo.jpg
---

## Step 1: Create an OAuth2 Service in Authentik

1. Open the **Admin Interface** in Authentik.
2. Navigate to **Applications** -> **Applications**.
3. Click on **Create with wizard**.
4. Enter the following details:
   - **Name**: Komodo
   - **Slug**: komodo  
     Then, click **Next**.
5. For the **Provider Type**, select **OAuth2/OIDC**.
6. Under **Authorization Flow**, choose **Explicit**.
7. Save the generated **Client ID** and **Client Secret** for later use.
8. In the **Redirect URIs/Origins** field, enter:  
   `<DOMAIN>/auth/oidc/callback`  
   Replace `<DOMAIN>` with the domain of your Komodo instance. For example: `https://komodo.evercode.se`.

After completing these steps, the Authentik configuration is ready. Next, you'll configure Komodo.

---

## Step 2: Configure Komodo

Komodo's configuration can be done via environment variables or the `komodo-config.toml` file. For this guide, we separate non-sensitive values into an `.env` file and sensitive values into the encrypted `komodo-config.toml`.

### Environment File (.env)

Here's an example of the `.env` file:

```env
## OIDC Login
KOMODO_OIDC_ENABLED=true
## URL of the OIDC provider, must be reachable from the Komodo Core container.
KOMODO_OIDC_PROVIDER=<DOMAIN>/application/o/komodo/
## URL for redirecting users after authentication. Optional if it's the same as above.
KOMODO_OIDC_REDIRECT_HOST=<DOMAIN>
# KOMODO_OIDC_USE_FULL_EMAIL=true
```

Replace `<DOMAIN>` with your Komodo domain.

### Configuration File (komodo-config.toml)

The sensitive credentials are stored in `komodo-config.toml`:

```toml
## OIDC Client ID
## Environment Variable: KOMODO_OIDC_CLIENT_ID or KOMODO_OIDC_CLIENT_ID_FILE
oidc_client_id = "..."

## OIDC Client Secret
## Environment Variable: KOMODO_OIDC_CLIENT_SECRET or KOMODO_OIDC_CLIENT_SECRET_FILE
oidc_client_secret = "..."
```

---

## Step 3: Enable User Registration and Onboarding

To allow Authentik users to register accounts in Komodo, set the following options in either the `.env` or `komodo-config.toml` file:

```env
## Allow new user signups.
KOMODO_DISABLE_USER_REGISTRATION=false
## Automatically enable new user accounts upon login.
KOMODO_ENABLE_NEW_USERS=true
```

After saving these changes, restart your Komodo instance. When you visit the login page, you should now see an option to log in using OIDC. Log in with your Authentik credentials to register a user.

---

## Step 4: Assign Admin Permissions to Authentik User

Your newly registered Authentik user will have standard permissions by default. To grant administrative permissions, follow these steps:

1. Log out of your Authentik user.
2. Log in with your local admin account.
3. Navigate to **Settings** -> **Users**.
4. Select the newly registered Authentik user.
5. Click the **Make Admin** button.

You can now log back into Komodo using your Authentik user, which should have full administrative permissions.

---

## Step 5 (Optional): Disable Local Login

If you prefer to restrict access to Komodo through Authentik only, you can disable local login. This simplifies security by requiring only the Authentik account to be protected.

Add the following setting to your `.env` or `komodo-config.toml` file:

```env
## Disable login with username and password.
KOMODO_LOCAL_AUTH=false
```

You can also disable new user registrations if you don’t want additional Authentik users to create Komodo accounts.

---

With these steps completed, your Komodo instance is now fully integrated with Authentik, providing a streamlined and secure authentication process.
