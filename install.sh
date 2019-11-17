#!/bin/sh

pwd=$(pwd)

tmpDir="$(mktemp -d -t bs-patform-nix.XXXXXXXXXX)"
cleanup() {
    rm -rf "$tmpDir"
}
trap cleanup EXIT INT QUIT TERM

# Clone the repo
cd $tmpDir
git clone git@github.com:turboMaCk/bs-platform.nix.git .

# Install using nix-env
nix-env -if ./default.nix
cd $pwd
