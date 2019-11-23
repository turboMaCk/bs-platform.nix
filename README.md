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
      rev = "2483f8a2b8d47e48175c1eb84e1f0b61afe02fe3";
      sha256 = "1vjfgdyznz26awg2xkfw7s9a12bi58d2cbmmxkl8vywz0hkpsxy1";
    };
in
import "${bs-platform}/bs-platform.nix" { inherit stdenv fetchFromGitHub ninja nodejs python35; }
```

## Examples

### Nix Shell

```nix
{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  bs-platform-src =
    pkgs.fetchFromGitHub {
      owner = "turboMaCk";
      repo = "bs-platform.nix";
      rev = "2483f8a2b8d47e48175c1eb84e1f0b61afe02fe3";
      sha256 = "1vjfgdyznz26awg2xkfw7s9a12bi58d2cbmmxkl8vywz0hkpsxy1";
    };
  bs-platform =
    import "${bs-platform-src}/bs-platform.nix"
      { inherit stdenv fetchFromGitHub ninja nodejs python35; };
in
mkShell {
    buildInputs = [ bs-platform yarn ];
}
```
