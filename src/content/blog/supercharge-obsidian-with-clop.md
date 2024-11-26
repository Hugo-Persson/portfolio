---
title: "How Clop Slashed My Obsidian Vault Size by 75%: A Developer’s Guide to Smart Media Optimization"
description: "Discover how to automatically compress images, PDFs, and recordings in your Obsidian vault while maintaining quality. This practical guide shows you how to set up Clop for effortless media optimization and potentially reduce your vault size by up to 75%"
pubDate: 2024-11-27
tags: ["obsidian", "mac-tools"]
keywords: []
draft: false
cover: ./images/obsidian-clop/obsidian+clop.png
---

## Why use Clop?

Your Obsidian vault is more than just text - it’s a collection of rich media that helps capture and illustrate your thoughts. But as your knowledge base grows, so does its size. Enter Clop, a powerful optimization tool that can significantly reduce your vault’s footprint without compromising quality.

### The Power of Compression

In my testing, Clop has demonstrated remarkable results:

- Screenshots compressed by up to 75%
- PDF files reduced by up to 90%

To illustrate the potential impact, I developed a simple analysis script for my vault, which revealed this breakdown even after optimization:

```
Analysis of directory: .
---------------------------------
Total files:     7758
Images: 841 (10.84%)
PDFs: 28 (.36%)
Recordings: 2 (.02%)
Markdown files: 2654 (34.20%)
```

You can find the script and try on your own vault here: https://gist.github.com/Hugo-Persson/8ba1a360be0685f91e14e60f3bda263a

If I would not have used Clop then the size of my vault would probably have been at least 2x the size it currently is.

## Installing Clop

### Manual

Clop has both a free and paid version. The free version is limited to 5 files per session and is great for trying out the tool. The paid version is an one time purchase of $15 and has no limitations.
You can install this tool either from their website or from HomeBrew.
Website: https://lowtechguys.com/clop/
HomeBrew: `brew install --cask clop`

### SetApp

The pro version is also included in SetApp, if you do not already have a subscription to SetApp then I would recommend trying it out. It's a great way to try out a lot of different tools. You can use my link for a 30 day free trial.
https://go.setapp.com/invite/yzegqcgr

## Automated Optimization Setup

Configure Clop to automatically monitor your Obsidian vault:

1. Launch Clop
2. Configure watch paths for each media type:
   - Video menu → Watch paths → Add vault location
   - Images menu → Watch paths → Add vault location
   - PDF menu → Watch paths → Add vault location 3. Enable “Launch at login” in General settings 4. Customize notification preferences under “Floating results”
3. Enable “Launch at login” in General settings
4. Customize notification preferences under “Floating results”

After this you can paste or move images/pdf/recordings into your vault and Clop will automatically optimize them and notify you when it's done.

## Bulk Optimization for Existing Files

It is great that Clop can automatically optimize new files but what about the files that are already in your vault? You can easily optimize these by using the CLI integration.

First enable the CLI integration by opening the menu bar menu and clicking "Install command-line integration". After this you should have the command `clop` available in your terminal.

Then open your Obsidian vault directory in your terminal. First I would recommend doing a backup of you vault to make sure no file is compressed beyond your liking. Then you can run:

```sh
clop optimize **/*.{png,jpg,pdf,mp4,mov,avi}
```

After this you will get an output like:

```
✓ TOTAL: ...
```

Where you will see how much space is saved, I would be intrigued to see how much space you can save in your vault, please comment how much space you saved!
