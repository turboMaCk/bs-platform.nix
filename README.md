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
{ fetchFromGitHub, stdenv, fetchFromGitHub, ninja, nodejs, python35, ... }:
let
  bs-platform =
    fetchFromGitHub {
      owner = "turboMaCk";
      repo = "bs-platform.nix";
      rev = "c20e8dc8703ad7975c99d76b5779d31c86078d98";
      sha256 = "06wii6487crawi7ngbls59snvygqhh29jz5f9q106m3vp9jzy7h9";
    };
in
import "${bs-platform}/bs-platform.nix" { inherit stdenv fetchFromGitHub ninja nodejs python35; }
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
      rev = "c20e8dc8703ad7975c99d76b5779d31c86078d98";
      sha256 = "06wii6487crawi7ngbls59snvygqhh29jz5f9q106m3vp9jzy7h9";
    };
  bs-platform =
    import "${bs-platform-src}/bs-platform.nix"
      { inherit stdenv fetchFromGitHub ninja nodejs python35; };
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
