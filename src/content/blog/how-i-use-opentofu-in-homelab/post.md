---
title: How I use OpenTofu (Terraform) to automate Authentik
description: "In my Home Lab, I use Authentik to manage authentication and authorization for all users. This works great, but I often find myself doing tedious tasks like setting up my services. 
pubDate: 2025-05-19
tags:
  - Authentik
  - HomeLab
  - Terraform
  - OpenTofu
draft: false
keywords: []
light: ./light.png
dark: ./dark.png
slug: how-i-use-opentofu-in-homelab
---
## Why OpenTofu?

[OpenTofu](https://opentofu.org) is an open-source Infrastructure-as-Code (IaC) engine that
remains syntax-compatible with Terraform while being **fully community-governed**.  
I use it to describe every Authentik object—users, groups, applications, and providers—in plain
HCL. After a quick `tofu apply`, my Authentik instance is **reproducible, version-controlled, and
self-documenting**.

Without IaC, adding a new service meant clicking through the UI, copying client IDs,
forgetting which scopes to check, and inevitably missing a step. Now it's a single
pull request.

---

## Preparing Authentik

### Generate an API token

1. In the Authentik UI, go to **Settings → Tokens and App passwords**.
2. Click **Create Token**
3. Copy the token

### Provider configuration

```terraform
terraform {
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2025.4"
    }
  }
}

provider "authentik" {
  host  = "https://authentik.example.com"
  token = var.authentik_token
}
```

Save the token in `terraform.tfvars` like this:
```terraform title="terraform.tfvars"
authentik_token = "your_api_token_here"
```

---
### Creating users

Many people need access to my HomeLab for different use cases. In this section, I show how I create users with a random password.

First, I generate a unique password like this:

```terraform
resource "random_password" "ludvig_password" {
  length  = 16
  special = true
}
```

Then

### Managing access

The first thing I want to configure for my users is which services they have access to. I do this by creating groups and assigning users to those groups.

Each group has a certain set of services that belong together. For example, I have a group called `family` that gives access to our shared recipe bank. To create a group and assign users to it, I use the following code:

```terraform
resource "authentik_group" "group_name" {  # <- Replace with your group name
  name  = "a name" # <- Replace with your group name
  users = [authentik_user.user_name.id, authentik_user.user_name2.id] # You can add multiple users here
}
resource "authentik_policy_binding" "binding" {
  for_each = toset([
    module.app1.application_id,
    module.app2.application_id,
  ])

  target = each.value
  group  = authentik_group.group_name.id
  order  = 1
}
```

This creates a group with the name `group_name` and assigns the users `user_name` and `user_name2` to it. The `authentik_policy_binding` resource is used to bind the group to the services you want them to have access to. Replace `binding` with a descriptive name for your binding. Then I configure this binding to have access to `app1` and `app2`. See below for app configuration.

### Create an application

An application in Authentik is a service that users can access. You then configure each application with a provider to authenticate users. I use OIDC and Proxy authentication and will detail how to configure these further in this post.

To configure an application, I have abstracted the process into a module that I can reuse for each application. I have two modules for this: one for OIDC and one for Proxy authentication. See the respective sections below for details on how to create these modules and use them.

### Creating a module

A module in OpenTofu is a reusable piece of code that can be used to create resources. I have created two modules: one for OIDC and one for Proxy authentication. To create a module, you need to create a folder with the name of the module and a file called `main.tf` inside it. I have the following structure for my modules:

```
.
└── modules/
    ├── proxy_app/
    │   ├── main.tf
    │   └── variables.tf
    ├── directory_app/
    │   ├── main.tf
    │   └── variables.tf
    └── ...
```

### Creating Proxy authentication

Proxy authentication is used for services that do not support OIDC. It acts as a middleman between the user and the service, allowing the user to authenticate with Authentik and then access the service. This is combined with a reverse proxy. See my other blog post on how to configure integration with Traefik.

#### Using the module

A proxy application is configured with a module that takes the following parameters:

- `name`: The name of the application.
- `slug`: The URL-friendly identifier for the application, used in the `external_host`.

It is used like this:

```terraform title="main.tf"
module "zigbee2mqtt" {
  source = "./modules/proxy_app"
  slug   = "zigbee2mqtt"
  name   = "Zigbee2MQTT"
  providers = {
    authentik = authentik
  }
}
```

We do this for all the services, then we bind them to the outpost used by Traefik. See my other blog post on how to configure integration with Traefik. The binding is done like this:

```terraform title="main.tf"
resource "authentik_outpost" "embedded_outpost" {
  name = "authentik Embedded Outpost"
  protocol_providers = [
    11,
    13,
    29,
    module.zigbee2mqtt.proxy_id,
    # ... Other proxies
  ]
}
```

#### Creating the module

If you have configured Traefik middleware for Authentik, you can use the following module to create a Proxy authentication service:

```terraform title="modules/proxy_app/main.tf"
terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
    }
  }
}
data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default-invalidation-flow" {
  slug = "default-invalidation-flow"
}

resource "authentik_provider_proxy" "proxy" {
  name                  = "Provider for ${var.name}"
  external_host         = coalesce(var.external_host, "https://${var.slug}.evercode.se")
  authorization_flow    = data.authentik_flow.default-authorization-flow.id
  invalidation_flow     = data.authentik_flow.default-invalidation-flow.id
  mode                  = "forward_single"
  access_token_validity = "days=14"

}

# I want to give all admins access to this application, so I create a data source for the admins group
data "authentik_group" "admins" {
  name = "admins"
}

resource "authentik_application" "app" {
  name              = var.name
  slug              = var.slug
  meta_launch_url   = "https://${var.slug}.evercode.se" # Replace with your own URL
  meta_icon         = coalesce(var.meta_icon, "https://cdn.jsdelivr.net/gh/selfhst/icons/webp/${var.slug}.webp")
  protocol_provider = authentik_provider_proxy.proxy.id
}

# Then I create a policy binding to give the admins group access to this application
resource "authentik_policy_binding" "admin_binding" {
  target = authentik_application.app.uuid
  group  = data.authentik_group.admins.id
  order  = 0
}


# I also want to output the ID of the proxy and the application, so I can use them in other modules or resources
output "proxy_id" {
  value = authentik_provider_proxy.proxy.id
}

output "app_id" {
  value = authentik_application.app.uuid
}
```

```terraform title="modules/proxy_app/variables.tf"
variable "name" {
  description = "Name of the application"
  type        = string
}

variable "slug" {
  description = "URL-friendly identifier for the application, used in the external_host"
  type        = string
}

variable "meta_icon" {
  type        = string
  description = "Will use auto icon from selfhst if not provided using slug as service name. Provide to use different icon"
  default     = null
}

variable "external_host" {
  type        = string
  description = "External host URL for the application, defaults to https://<slug>.evercode.se if not provided"
  default     = null
}
```

### Creating OIDC service

An OIDC service is used for services that support OIDC authentication. It allows users to authenticate with Authentik and then access the service. I have created a module for this as well. See below for details on how to create this module.

#### Using the module

Each OIDC service is configured with a module that takes the following parameters:

- `name`: The name of the application.
- `slug`: The URL-friendly identifier for the application, used in the external host.
- `client_id`: A unique identifier for the OIDC client. This is used to identify the application in Authentik. Generate this as a UUID.
- `redirect_url`: A list of redirect URLs for the application. These are the URLs that the user will be redirected to after authentication.

Then I use the module like this:

```terraform title="main.tf"
module "proxmox" {
  source       = "./modules/directory_app"
  slug         = "proxmox"
  redirect_url = ["https://proxmox.evercode.se"]
  name         = "Proxmox"
  client_id    = "..."
  providers = {
    authentik = authentik
  }
}
```

#### Creating the module

Here's how to create the module:

```terraform title="modules/directory_app/main.tf"
terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
    }
  }
}



data "authentik_group" "admins" {

  name = "admins"
}


data "authentik_flow" "default-invalidation-flow" {
  slug = "default-invalidation-flow"
}
data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}


resource "authentik_provider_oauth2" "provider" {
  name      = "Provider for ${var.name}"
  client_id = var.client_id
  allowed_redirect_uris = [
    for url in var.redirect_url : {
      matching_mode = "strict"
      url           = url
    }
  ]
  property_mappings = [
    "006713cb-0047-403a-b827-5aaa4784f341", # email
    "8dd24234-e040-4614-8227-29ff5791e031", # profile
    "c82dabbe-52a0-43b0-a21b-222a09f45509", #openid
  ]
  signing_key = var.signing_key

  access_token_validity = "days=14"
  access_code_validity  = "minutes=10"

  invalidation_flow  = data.authentik_flow.default-invalidation-flow.id
  authorization_flow = data.authentik_flow.default-authorization-flow.id
}
output "client_secret" {
  value = authentik_provider_oauth2.provider.client_secret
}


resource "authentik_policy_binding" "admin_binding" {
  target = authentik_application.app.uuid
  group  = data.authentik_group.admins.id
  order  = 0
}

resource "authentik_application" "app" {
  name              = var.name
  slug              = var.slug
  meta_icon         = coalesce(var.meta_icon, "https://cdn.jsdelivr.net/gh/selfhst/icons/webp/${var.slug}.webp")
  meta_launch_url   = coalesce(var.meta_launch_url, "https://${var.slug}.evercode.se") # Replace with your own URL
  protocol_provider = authentik_provider_oauth2.provider.id
}


output "application_id" {
  value = authentik_application.app.uuid
}

```

```terraform title="modules/directory_app/variables.tf"
variable "name" {
  description = "Name of the application"
  type        = string
}

variable "slug" {
  description = "URL-friendly identifier for the application, used in the external_host"
  type        = string
}

variable "signing_key" {
  description = "Signing key for the application, only needed on import, if `tofu plan` warns define this"
  type        = string
  default     = null
}

variable "client_id" {
  description = "Client id for provider"
  type        = string
}


variable "redirect_url" {
  description = "Redirect URLs for the application"
  type        = list(string)
}

variable "meta_launch_url" {
  description = "External host URL for the application, defaults to https://<slug>.evercode.se if not provided"
  type        = string
  default     = null
}
variable "meta_icon" {
  type        = string
  description = "Will use auto icon from selfhst if not provided using slug as service name. Provide to use different icon"
  default     = null
}
```

### Importing data

Before starting to use OpenTofu, I needed to import the data I already had in Authentik. I had created multiple services and users already and did not want to lose them. The process to import data follows these steps:

1. Define config (this is what we did above)
2. Find the ID for your service
3. Run import command

#### Accessing API

Go to `https://authentik.company/api/v3/`
NOTE: Do not forget the ending `/`—you will get a 404 error otherwise.

Enter your API key you obtained in the earlier section.

#### Users

To import users, I created a config for the user I needed.
Use the endpoint `/core/users`. You get a response like this back:

```json
{
  "pagination": {
    ...
  },
  "results": [
    {
      "pk": 15, // <- Look for this for the user you want to import
      "username": "John Doe",  // Name of your user
    },
    ...
  ]
}
```

```sh
tofu import authentik_user.hugo $PK
```

#### Application

Use the endpoint `/core/applications/`

```json
{
  "pagination": {
    ...
  },
  "results": [
    {
      "pk": "75f3a423-5a3f-4119-a3ce-398d8fd16d24", // <- Look for this
       "name": "Audiobookrequest", // Your service name
    },
    ...
  ]
}
```

The first step is to figure out the UUID:

```sh
tofu import module.$NAME.authentik_application.$NAME $PK
```

#### Proxy

Use the endpoint `/outposts/proxy/`

```json
{
  "pagination": {
    ...
  },
  "results": [
    {
      "pk": 36, // <- Look for this
          "name": "Provider for Bazarr", // <- your provider name
  ]
}
```

```sh
tofu import module.sonarr.authentik_provider_proxy.proxy $PK
```

#### OAuth provider

Use the endpoint `/providers/oauth2/`

```json
{
  "pagination": {
    ...
  },
  "results": [
    {
      "pk": 42, // <- Look for this
      "name": "Provider for Audiobookrequest", // <- your provider name
    },
    ...
  ]
}
```

```sh
tofu import module.$NAME.authentik_provider_oauth2.provider $PK
```
