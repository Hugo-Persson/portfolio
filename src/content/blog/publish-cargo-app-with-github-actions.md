---
title: "Publish a Rust App with GitHub Actions"
description: "In this guide, I'll show you how to publish an existing Rust app to GitHub using GitHub Actions. "
pubDate: 2024-05-24
tags: ["rust", "github-actions", "ci/cd", "cargo"]
draft: true
---

## Overview

We are gooing to create a Github Actions workflow to automaticly build our Rust app. Create a github release and attach the binary to it for all platforms. This will be run automatically on every push to the main branch.

## Preqrequisites

## Github Actions Workflow

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

With this we will automaticly trigger the workflow when we push a tag
with name like `1.0.0, 1.0.1, 1.1.2` etc.

### Configure rust toolchain

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

### Build and attach the Binary to the Release

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

```yaml
- name: Release
  uses: softprops/action-gh-release@v1
  with:
    files: ${{ env.ASSET }}
```

## Summary

Here is the workflow we created:

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
