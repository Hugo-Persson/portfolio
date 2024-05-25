---
title: "Wireguard with DNS in Docker"
description: "In this guide, I'll show you how I set up a Wireguard server and a DNS server on the same host in my HomeLab. Many users face issues using a local DNS server with Wireguard. I'll explain how to configure Wireguard to access local devices and use a local DNS server like AdGuard Home, with both running in Docker on the same machine."
pubDate: 2024-05-24
tags: ["wireguard", "docker", "dns"]
---

## Summary

In this guide, I'll show you how I set up a Wireguard server
and a DNS server on the same host in my HomeLab.
Many users face issues using a local DNS server with Wireguard.
I'll explain how to configure Wireguard to access local devices
and use a local DNS server like AdGuard Home,
with both running in Docker on the same machine.

## Guide

For my HomeLab I tried to setup a Wireguard server and DNS server on the same Host and it was just not working. If I used a DNS server like `1.1.1.1` it worked but not when using `192.168.x.x` that is my local DNS server. In this article I am going to show how to setup Wireguard to access all your local devices and use a local DNS server like **AdGuard Home**. A prerequisite is that we are running both our DNS server and Wireguard server in Docker on the same machine. For DNS server I am using **AdGuard Home** and for Wireguard server I am using _wg-easy_, but this should work for any DNS server and wireguard server.

### Configuring DNS container

Before setting up Wireguard we need to tweak one thing with our DNS server. For this to work our DNS container and Wireguard need to be on the same Docker network. First we create a network for this with:

```shell
docker network create --subnet=172.22.0.0/16 dns
```

> We use the subnet `172.22.0.0/16` here,
> this could be any subnet but we need to set a subnet to be able to set a
> IPV4 adress for our container

After this we need to connect our DNS container to this network, we do this defining our network in our `docker-compose` by adding this to the file:

```yaml
networks:
  dns:
    external: true
```

After this we need to add the following to our DNS service:

```shell
networks:
      dns:
        ipv4_address: 172.22.0.2 # We later use this to configure our DNS server for our clients
```

You can now recreate your container with:

```shell
docker compose up -d
```

### Configuring Wireguard

It is now time to setup our _wg-easy_ container.

Create a new directory for this, like this:

```shell
mkdir wireguard
```

And create a `docker-compose.yaml` file with the following content:

```yaml unwrap:true title:"docker-compose.yaml"
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

You can now recreate your container with:

```shell
docker compose up -d
```

For info about how to configure client and such, see the official documentation:
<https://github.com/wg-easy/wg-easy/blob/master/README.md>
