---
title: "My Mac Setup"
description: "..."
pubDate: 2024-12-10
tags: []
keywords: []
draft: true
cover: ./images/traefik-multi-host.png
---

1. Go to Admin interface
2. Go to Applications -> Applications
3. Select "Create with wizard"
4. Enter information like this
5. For provider type "OAuth2/OIDC"
6. For "Authorization flow" select explicit
7. Store your Client ID and Client Secret
8. For "Redirect URIs/Origins" enter the domain for your audiobookshelf instance, for me "https://audiobookshelf.evercode.se"
9. After this complete the setup

Now you have configured everything in Authentik and you can configure the remaining in Audiobookshelf.

Go to Settings -> Authentication and enable "OpenID Connect Authentication". You can autopulate the fields by entering: `https://<YOUR_AUTHENTIK_DOMAIN>/application/o/audiobookshelf/` and clicking "Auto Populate".
Note: "audiobookshelf" refers to the slug we created for the application in the wizard, <YOUR_AUTHENTIK_DOMAIN> should be replaced with your domain for authentik

After this all fields except "Client ID" and "Client Secret" should be populated. Enter the Client ID and Client Secret you got from Authentik and click "Save".

You can if you want configure some of the other settings to your liking.

Now everything should be configured and you can test the login by going to the login page and clicking the button with the button text your configured in Audiobookshelf.
