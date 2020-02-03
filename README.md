# BS Platform via Nix and Nix only.

[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2FturboMaCk%2Fbs-platform.nix%2Fbadge%3Fref%3Dmaster&style=flat)](https://actions-badge.atrox.dev/turboMaCk/bs-platform.nix/goto?ref=master)

Nix expressions for [BuckleScript](https://github.com/bucklescript/bucklescript) compiler known as `bs-platform`.
Official npm installation does't work on NixOS as it attempts to compile native dependecies in `postinstall` hook.
Furthermore nix provides several advantages over official npm distribution and can be used across variety of operating systems.

## Quick Start

If you're in hurry just `nix-env` install this project.
**Make sure you have [nix installed](https://nixos.org/nix/)!**

> Use [Cachix binary cache](https://bs-platform.cachix.org/) to speedup the installation process
> ```
> $ cachix use bs-platform
> ```

```
$ nix-env -if https://github.com/turboMaCk/bs-platform.nix/archive/master.tar.gz -A bs-platform7
```

### Available Versions

| Version | Attribute    |
| ------- | ------------ |
| `7.0.1` | bs-platform7 |
| `6.2.1` | bs-platform6 |

## Include to Your Expression

If you rock NixOS and what to install bs-platform as a system dependency
or you using a `nix-shell` for your project you can use this expression:

```nix
# bs-platform.nix
{ pkgs ? import <nixpkgs> {} }:
let
  bs-platform-src =
    pkgs.fetchFromGitHub {
      owner = "turboMaCk";
      repo = "bs-platform.nix";
      rev = "2cbefeb081303f6364f28fcdca750a4453886bc1";
      sha256 = "02axqi00g3w6glwhms8dlb2sg1ac0v7bp9g9cbik0ky3x38fa29b";
    };
in
(import bs-platform-src { inherit pkgs; }).bs-platform7
```

## Custom Versions and Overriding

Expression is build with overriding in mind. That's being said based on the
version of choice it might require more or less customizations.

This is an example of how `bs-platform.nix` can be used to build
version 7.0.0:

```nix
# bs-platform700.nix
{ pkgs ? import <nixpkgs> {} }:
let
  bs-platform-src =
    pkgs.fetchFromGitHub {
      owner = "turboMaCk";
      repo = "bs-platform.nix";
      rev = "2cbefeb081303f6364f28fcdca750a4453886bc1";
      sha256 = "02axqi00g3w6glwhms8dlb2sg1ac0v7bp9g9cbik0ky3x38fa29b";
    };
in with pkgs;
import "${bs-platform-src}/build-bs-platform.nix" {
  inherit stdenv fetchFromGitHub ninja runCommand nodejs python3;
  version = "7.0.0";
  ocaml-version = "4.06.1";
  src = fetchFromGitHub {
    owner = "BuckleScript";
    repo = "bucklescript";
    rev = "6dcf1f6ab5e35557098c3c1615ca804850c1813c";
    sha256 = "0jc4ndmr5s09hrjxw5zqi676w7b8jfafxqiyng8d9d3i1lzzaggj";
    fetchSubmodules = true;
  };
}
```

Note that [overrideAttrs](https://nixos.org/nixpkgs/manual/#sec-pkg-overrideAttrs)
can be used to apply custom patches etc.

Please check [build-bs-platform.nix](build-bs-platform.nix) for more information
like customizing OCaml versions.

## Examples

### Nix Shell

BuckleScript is expecting to find binaries within the `node_modules` and essentially just calls into
them when ever you run any command within the project.
Libraries and other dependencies are then usually installed by `npm` or `yarn`.
**We recommend using npm** over yarn because yarn ignores the symlinks within `node_modules` and
tries to reinstall all packages (same is true for symlink created by `bsb -init`).

Your `shell.nix` may look like this:

```nix
{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  bs-platform-src =
    pkgs.fetchFromGitHub {
      owner = "turboMaCk";
      repo = "bs-platform.nix";
      rev = "2cbefeb081303f6364f28fcdca750a4453886bc1";
      sha256 = "02axqi00g3w6glwhms8dlb2sg1ac0v7bp9g9cbik0ky3x38fa29b";
    };
  bs-platform =
    (import bs-platform-src { inherit pkgs; }).bs-platform7;
in
mkShell {
    buildInputs = [ bs-platform nodejs ];

    shellHook = ''
      mkdir -p node_modules
      ln -sfn ${bs-platform} ./node_modules/bs-platform
      ln -sfn ${bs-platform}/bin/* ./node_modules/.bin
      echo "bs-platform linked to $(pwd)/node_modules/bs-platform"

      npm install
    '';
}
```
