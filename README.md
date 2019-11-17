# BS Platform for NIX Expressions

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
{ fetchFromGitHub, stdenv, fetchgit, ninja, nodejs, ocamlPackages, python35, ... }:
let
  bs-platform =
    fetchFromGitHub {
      owner = "turboMaCk";
      repo = "bs-platform.nix";
      rev = "18b0dd7bb41c054b9cc3e3141f437e3fab8e4884";
      sha256 = "16fq5pnzcj7h15r1gdl9n49fg25ai76cngir6ci9xj8sc5kfcmja";
    };
in
import "${bs-platform}/bs-platform.nix" { inherit stdenv fetchgit ninja nodejs ocamlPackages python35; }
```
