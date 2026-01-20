#!/bin/bash

main() {
    # Define version from your screenshot
    HUGO_VERSION=0.115.0
    export TZ=Europe/Belgrade

    # Install Hugo Extended
    echo "Installing Hugo v${HUGO_VERSION}..."
    curl -LJO https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz
    tar -xf "hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
    cp hugo /opt/buildhome
    rm LICENSE README.md hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz

    # Verify installed version
    echo "Verifying installation..."
    echo Go: "$(go version)"
    echo Hugo: "$(./hugo version)"
    echo Node: "$(node --version)"

    # Clone themes/submodules (Blowfish theme)
    echo "Updating submodules..."
    git submodule update --init --recursive
    git config core.quotepath false

    # Build the website
    echo "Building the Site..."
    ./hugo --gc --minify
}

set -euo pipefail
main "$@"