#!/bin/sh

pwd=$(pwd)

tmpDir="$(mktemp -d -t bs-patform-nix)"
cleanup() {
    rm -rf "$tmpDir"
}
trap cleanup EXIT INT QUIT TERM

# Clone the repo
pushdir $pwd; git clone git@github.com:turboMaCk/bs-platform.nix.git && cd bs-patform.nix; popd

# Install using nix-env
nix-env -if $(tmpDir)/bs-patform.nix/default.nix

# Cleanup
cleanup
