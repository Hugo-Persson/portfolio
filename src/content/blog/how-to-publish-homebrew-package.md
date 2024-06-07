---
title: How to publish CLI app with Homebrew
description: >-
  In this post, I will show how to publish any CLI app to Homebrew. The formula
  will install the binaries from GitHub Releases for a completely free setup.I
  had quite a lot of problem figuring out how to do this, so I hope this post
  will help you. We will create a formula for our app and publish it to our own
  Homebrew Tap.
pubDate: 2024-06-07T00:00:00.000Z
tags:
  - homebrew
  - cli
keywords: []
draft: false
---
## Setting up a tap

The first thing we need to do is to create a tap.
A tap is a repository that contains formula.
The formula is the actual CLI program and our tap can contain many Formulas.
We can either publish our own tap our get our Formula
into the official Homebrew repository which can take some time.
In this post we will create our own tap.

The tap will be a GitHub repository that contains our Formula.

To create a tap, run:

```shell
brew tap-new <YOUR_GITHUB_USERNAME>/homebrew-<YOUR_TAP_NAME>
```

After this we will get a message that contains the path to our tap. Like this:

```
==> Created hugo-persson/dns-cli-tool-test
/opt/homebrew/Library/Taps/<YOUR_GITHUB_USERNAME>/homebrew-<YOUR_TAP_NAME>
```

We can now navigate to this folder and create a new Formula.
In your tap folder you should have the following structure:

```
.
├── Formula
└── README.md
```

## Creating a Formula
>
> For this step you need to have a compiled binary of your CLI app published on GitHub Releases. For a guide how to do this in Rust, see my post [Publish a Rust CLI App with GitHub Actions](/blog/publish-cargo-app-with-github-actions/). A simliar setup can be used for other languages.

We will now create a new Formula in the Formula folder.

```
cd Formula
touch <YOUR_FORMULA>.rb
```

The filename should be kebab-case and end with `.rb`. For example `dns-cli-tools.rb`.

Users will later install your CLI app by running:

```bash
brew tap <YOUR_GITHUB_USERNAME>/<YOUR_TAP_NAME>
brew install <YOUR_GITHUB_USERNAME>/<YOUR_TAP_NAME>/<YOUR_FORMULA>
```

We now want to define how to install the CLI app.
For this step it is important that you have the binaries published on GitHub Releases.
Below I will refer to your github url as `<YOUR_GITHUB_URL>`.
Replace this with the URL to your github repository. For example `https://github.com/Hugo-Persson/dns-cli-tools`

### Getting the SHA256 hash

We need to get the SHA256 hash for the binaries. This is to ensure that the binaries are not tampered with. We can get the SHA256 hash by running:

```bash
VERSION=1.0.0 # Replace with your version
FILE_NAME=dns-cli-macos-arm64.tar.gz # Replace with the name of your binary
wget -q "<YOUR_GITHUB_URL>/releases/download/$VERSION/$FILE_NAME"
shasum -a 256 "$FILE_NAME" | awk '{ print $1 }
```

For my CLI app, I automated this with a simple bash script like this:

```bash
#!/bin/bash
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

VERSION=$(curl --silent "https://api.github.com/repos/Hugo-Persson/dns-cli-tools/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo "Updating to version $VERSION"

# cd to script dir

# Get the directory path of the script being run
script_dir=$(dirname "$(readlink -f "$0")")

# Change the working directory to the script's directory
cd "$script_dir"
cd ..
cd Formula

sed -i "s/version \".*\"/version \"$VERSION\"/" ./dns-cli-tools.rb

BASE_URL="https://github.com/Hugo-Persson/dns-cli-tools/releases/download/$VERSION"

MAC_NAME="dns-cli-macos-arm64.tar.gz"
LINUX_NAME="dns-cli-linux-amd64.tar.gz"

wget -q "$BASE_URL/$MAC_NAME"
MAC_SHA=$(shasum -a 256 "$MAC_NAME" | awk '{ print $1 }')
sed -i "s/mac_sha = ".*"/mac_sha = \"$MAC_SHA\"/" ./dns-cli-tools.rb # Update the mac sha
rm "$MAC_NAME"

wget -q "$BASE_URL/$LINUX_NAME" >/dev/null
LINUX_SHA=$(shasum -a 256 "$LINUX_NAME" | awk '{ print $1 }')
sed -i "s/linux_sha = ".*"/linux_sha = \"$LINUX_SHA\"/" ./dns-cli-tools.rb # Update the linux sha
rm "$LINUX_NAME"
```

For the entire project see [homebrew-dns-cli-tools](https://github.com/Hugo-Persson/homebrew-dns-cli-tools).

### Creating the Formula file

We will now create the Formula file. Replace the placeholders with your own values.

```ruby
class YourFormulaName < Formula # Replace YourFormulaName with the name of your formula in CamelCase
  desc "A description of your formula"
  homepage "Link to your project"
  version "1.0.0"
  @github_base_url = "<YOUR_GITHUB_URL>/releases/download/#{version}"
  @mac_sha = "<SHA256 for macOS>" # Get this from the script above
  @linux_sha = "<SHA256 for Linux>"
  on_macos do
    url "#{@github_base_url}dns-cli-macos-arm64.tar.gz" # replace the filename with your own
    sha256 @mac_sha
  end

  # Define the URL and SHA256 for Linux
  on_linux do
    url "#{@github_base_url}/dns-cli-linux-amd64.tar.gz" # replace the filename with your own
    sha256 @linux_sha
  end

  def install
    bin.install "<BINARY_NAME>" # replace with the name of your binary
  end

  test do
    system "#{bin}/<BINARY_NAME>" # replace with the name of your binary
  end
end
```

After this you want to create a GithHub repository and push your tap to it.

After this you can install your CLI app by running:

```bash
brew tap <YOUR_GITHUB_USERNAME>/<YOUR_TAP_NAME>
brew install <YOUR_GITHUB_USERNAME>/<YOUR_TAP_NAME>/<YOUR_FORMULA>
```

