---
title: "Publish a Rust CLI App with GitHub Actions"
description: "How to create a GitHub Actions workflow to automatically build a Rust app. Create a GitHub release and attach the binary to it for all platforms. For example if you have a Rust CLI app that you want to publish the binaries to GitHub so people can download your tools, this is how to do it."
pubDate: 2024-05-31
tags: ["rust", "github-actions", "ci/cd", "cargo"]
keywords: []
draft: false
dark: ./dark.png
light: ./light.png
slug: publish-cargo-app-with-github-actions
---

## Overview

## Prerequisites

## GitHub Actions Workflow

### Configure when to run

```yaml
name: Deploy # Name of the workflow

on:
  push:
    tags:
      - "[0-9]+.[0-9]+.[0-9]+" # This will run the workflow on every tag that matches the regex
env:
  # The project name specified in your Cargo.toml
  PROJECT_NAME: <REPLACE>
permissions:
  contents: write
```

With this we will automatically trigger the workflow when we push a tag
with name like `1.0.0, 1.0.1, 1.1.2` etc. Replace the `<REPLACE>` with the name of your project. You will find this in your `cargo.toml` file under `bin`, something like this:

```toml
[[bin]]
name = "<YOUR_PROJECT_NAME>"
```

### Configure rust tool chain

We now want to set up a job that will compile our Rust app.
We do this by utilizing a matrix strategy,
you can read more about this here:
<https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs>

```yaml
jobs:
  build:
    # Set the job to run on the platform specified by the matrix below
    runs-on: ${{ matrix.runner }}

    strategy:
      matrix:
        # You can add more, for any target you'd like!
        include:
          - name: linux-amd64
            runner: ubuntu-latest
            target: x86_64-unknown-linux-gnu
          - name: win-amd64
            runner: windows-latest
            target: x86_64-pc-windows-msvc
          - name: macos-amd64
            runner: macos-latest
            target: x86_64-apple-darwin
          - name: macos-arm64
            runner: macos-latest
            target: aarch64-apple-darwin

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Install Rust
        uses: dtolnay/rust-toolchain@stable
        with:
          targets: "${{ matrix.target }}"

      - name: Setup Cache
        uses: Swatinem/rust-cache@v2

      - name: Build Binary
        run: cargo build --verbose --locked --release --target ${{ matrix.target }}
```

We will now have the environment setup for each platform to be able to compile our Rust app.

### Build and attach the Binary to the Release

Now we want to actually compile the binary and attach it to the release.
We can do this as follows:

```yaml
- name: Build Binary
  run: cargo build --verbose --locked --release --target ${{ matrix.target }}

- name: Release Binary
  shell: bash
  run: |
    BIN_SUFFIX=""
    if [[ "${{ matrix.runner }}" == "windows-latest" ]]; then
      BIN_SUFFIX=".exe"
    fi

    # The built binary output location
    BIN_OUTPUT="target/${{ matrix.target }}/release/${PROJECT_NAME}${BIN_SUFFIX}"

    # Define a better name for the final binary
    BIN_RELEASE="${PROJECT_NAME}${BIN_SUFFIX}"
    BIN_RELEASE_VERSIONED="${PROJECT_NAME}-${{ github.ref_name }}-${{ matrix.name }}${BIN_SUFFIX}"

    # Move the built binary where you want it
    mv "${BIN_OUTPUT}" "./${BIN_RELEASE}"
    if [ "${{ matrix.os }}" = "windows-latest" ]; then
      7z a "./${BIN_RELEASE}-${{ matrix.name }}.zip" "./${BIN_RELEASE}"
      echo "ASSET=./${BIN_RELEASE}-${{ matrix.name }}.zip" >> $GITHUB_ENV
    else
      
      tar -czf "./${BIN_RELEASE}-${{ matrix.name }}.tar.gz" "./${BIN_RELEASE}"
      echo "ASSET=./${BIN_RELEASE}-${{ matrix.name }}.tar.gz" >> $GITHUB_ENV
    fi
```

### Create a Release

The last step is to actually publish the release with the binary files attached.

```yaml
- name: Release
  uses: softprops/action-gh-release@v1
  with:
    files: ${{ env.ASSET }} # Attach the binary to the release
```

## Summary

Here is the workflow we created, you can also see how I use this in my Open Source DNS CLI tool, [dns-cli](https://github.com/Hugo-Persson/dns-cli-tools)

```yaml
name: Deploy

on:
  push:
    tags:
      - "[0-9]+.[0-9]+.[0-9]+"
env:
  # The project name specified in your Cargo.toml
  PROJECT_NAME: dns-cli
permissions:
  contents: write

jobs:
  build:
    # Set the job to run on the platform specified by the matrix below
    runs-on: ${{ matrix.runner }}

    strategy:
      matrix:
        # You can add more, for any target you'd like!
        include:
          - name: linux-amd64
            runner: ubuntu-latest
            target: x86_64-unknown-linux-gnu
          - name: win-amd64
            runner: windows-latest
            target: x86_64-pc-windows-msvc
          - name: macos-amd64
            runner: macos-latest
            target: x86_64-apple-darwin
          - name: macos-arm64
            runner: macos-latest
            target: aarch64-apple-darwin

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Install Rust
        uses: dtolnay/rust-toolchain@stable
        with:
          targets: "${{ matrix.target }}"

      - name: Setup Cache
        uses: Swatinem/rust-cache@v2

      - name: Build Binary
        run: cargo build --verbose --locked --release --target ${{ matrix.target }}

      - name: Release Binary
        shell: bash
        run: |
          BIN_SUFFIX=""
          if [[ "${{ matrix.runner }}" == "windows-latest" ]]; then
            BIN_SUFFIX=".exe"
          fi

          # The built binary output location
          BIN_OUTPUT="target/${{ matrix.target }}/release/${PROJECT_NAME}${BIN_SUFFIX}"

          # Define a better name for the final binary
          BIN_RELEASE="${PROJECT_NAME}${BIN_SUFFIX}"
          BIN_RELEASE_VERSIONED="${PROJECT_NAME}-${{ github.ref_name }}-${{ matrix.name }}${BIN_SUFFIX}"

          # Move the built binary where you want it
          mv "${BIN_OUTPUT}" "./${BIN_RELEASE}"
          if [ "${{ matrix.os }}" = "windows-latest" ]; then
            7z a "./${BIN_RELEASE}-${{ matrix.name }}.zip" "./${BIN_RELEASE}"
            echo "ASSET=./${BIN_RELEASE}-${{ matrix.name }}.zip" >> $GITHUB_ENV
          else
            
            tar -czf "./${BIN_RELEASE}-${{ matrix.name }}.tar.gz" "./${BIN_RELEASE}"
            echo "ASSET=./${BIN_RELEASE}-${{ matrix.name }}.tar.gz" >> $GITHUB_ENV
          fi

      - name: Release
        uses: softprops/action-gh-release@v1
        with:
          files: ${{ env.ASSET }}
```
