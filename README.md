# BS Platform via Nix and Nix only.

This project provides native from source builds for [BuckleScript](https://github.com/bucklescript/bucklescript).
Official npm installation does't work on NixOS as it attempts to compile native dependecies in `postinstall` hook.

## Quick Start

If you're in hurry just `nix-env` install this project.
**Make sure you have [nix installed](https://nixos.org/nix/)!**

```
$ curl https://github.com/turboMaCk/bs-platform.nix/blob/master/install.sh | sh
```

## Include to Your Expression

If you rock NixOS and what to install bs-platform as a system dependecy
or you using a `nix-shell` for your project you can use this expression:

```nix
# bs-platform.nix
{ stdenv, fetchFromGitHub, ninja, nodejs, python3, ... }:
let
  bs-platform =
    fetchFromGitHub {
      owner = "turboMaCk";
      repo = "bs-platform.nix";
      rev = "e37dbb37be393739c9ee0a0dc9c315229ad4a9ed";
      sha256 = "1kjj1mqw46l1y2p2z7hc2s80v1fcqr13jgb62l6xgv88dvr9499y";
    };
in
import "${bs-platform}/bs-platform.nix" { inherit stdenv fetchFromGitHub ninja nodejs python3; }
```

## Examples

### Nix Shell

BuckleScipt is expecting to find binaries within the `node_modules` and essentially just calls into
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
      rev = "e37dbb37be393739c9ee0a0dc9c315229ad4a9ed";
      sha256 = "1kjj1mqw46l1y2p2z7hc2s80v1fcqr13jgb62l6xgv88dvr9499y";
    };
  bs-platform =
    import "${bs-platform-src}/bs-platform.nix"
      { inherit stdenv fetchFromGitHub ninja nodejs python3; };
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
