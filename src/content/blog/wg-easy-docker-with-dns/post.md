---
title: "Wireguard with DNS in Docker"
description: "I'll explain how to configure Wireguard to access local devices and use a local DNS serve like AdGuard Home, with both running in Docker on the same machine."
pubDate: 2024-05-24
tags: ["wireguard", "docker", "dns"]
keywords: []
draft: false
light: ./light.png
dark: ./dark.png
slug: wg-easy-docker-with-dns
---

## Guide

For my HomeLab, I attempted to set up a **WireGuard** server and DNS server on the same host, but it was not working. While using a DNS server like `1.1.1.1` worked, my local DNS server at `192.168.x.x` did not. In this article, I will show you how to configure **WireGuard** to access all your local devices and use a local DNS server like **AdGuard Home**. The prerequisite is running both the DNS server and **WireGuard** server in Docker on the same machine. I use **AdGuard Home** for the DNS server and _wg-easy_ for the **WireGuard** server, but this setup should work for any DNS server and **WireGuard** server.

### Configuring the DNS Container

Before setting up **WireGuard**, we need to tweak the DNS server. Both the DNS container and **WireGuard** must be on the same Docker network. First, create a network with:

```shell
docker network create --subnet=172.22.0.0/16 dns
```

> We use the subnet `172.22.0.0/16` here. This could be any subnet, but we need to set a subnet to assign an IPV4 address to our container.

Next, connect the DNS container to this network by defining the network in your `docker-compose` file:

```yaml
networks:
  dns:
    external: true
```

Then, add the following to your DNS service configuration:

```yaml
networks:
  dns:
    ipv4_address: 172.22.0.2 # This will be used to configure our DNS server for clients
```

Recreate your container with:

```shell
docker compose up -d
```

### Configuring **WireGuard**

Now, set up the _wg-easy_ container.

Create a new directory, like this:

```shell
mkdir **WireGuard**
```

Then, create a `docker-compose.yaml` file with the following content:

```yaml
networks:
  dns:
    external: true

services:
  wg-easy:
    environment:
      # Change Language:
      # (Supports: en, ua, ru, tr, no, pl, fr, de, ca, es, ko, vi, nl, is, pt, chs, cht, it, th, hi)
      - LANG=en
      # ⚠️ Required:
      # Change this to your host's public address
      - WG_HOST=wireguard.evercode.se

      # Optional:
      # - PASSWORD=foobar123
      # - PORT=51821
      # - WG_PORT=51820
      # - WG_DEFAULT_ADDRESS=10.8.0.x
      - WG_DEFAULT_DNS=172.22.0.2 # This is the DNS defined earlier
      - WG_MTU=1384
      - WG_ALLOWED_IPS=0.0.0.0/0, 192.168.50.0/24, 172.22.0.0/16
      - WG_PERSISTENT_KEEPALIVE=24
      # - WG_PRE_UP=echo "Pre Up" > /etc/wireguard/pre-up.txt
      # - WG_POST_UP=echo "Post Up" > /etc/wireguard/post-up.txt
      # - WG_PRE_DOWN=echo "Pre Down" > /etc/wireguard/pre-down.txt
      # - WG_POST_DOWN=echo "Post Down" > /etc/wireguard/post-down.txt
      - UI_TRAFFIC_STATS=true
      - UI_CHART_TYPE=2 # (0 Charts disabled, 1 # Line chart, 2 # Area chart, 3 # Bar chart)

    image: ghcr.io/wg-easy/wg-easy
    container_name: wg-easy
    networks:
      dns:
        ipv4_address: 172.22.0.3
    volumes:
      - ./config:/etc/wireguard
    ports:
      - "51820:51820/udp"
      - "51821:51821/tcp"
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv4.conf.all.src_valid_mark=1
```

Recreate your container with:

```shell
docker compose up -d
```

For information on configuring clients and more details, refer to the official documentation: <https://github.com/wg-easy/wg-easy/blob/master/README.md>.
