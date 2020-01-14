# BS Platform via Nix and Nix only.

This project provides native from source builds for [BuckleScript](https://github.com/bucklescript/bucklescript).
Official npm installation does't work on NixOS as it attempts to compile native dependecies in `postinstall` hook.

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

If you rock NixOS and what to install bs-platform as a system dependecy
or you using a `nix-shell` for your project you can use this expression:

```nix
# bs-platform.nix
{ pkgs ? import <nixpkgs> {} }:
let
  bs-platform-src =
    pkgs.fetchFromGitHub {
      owner = "turboMaCk";
      repo = "bs-platform.nix";
      rev = "e3ca38272c47c32e9c223c8bde31fac050e89106";
      sha256 = "18ryafbx31f4ars9k4qfz7k4vmz2z7d0xvyg1kn1x3amh27x3isz";
    };
in
(import bs-platform-src { inherit pkgs; }).bs-platform7
```

## Custom Versions and Overriding

Expression is build with overloading in mind. That's beaing said based on the
version of choice it might require more or less overloading.

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
      rev = "e3ca38272c47c32e9c223c8bde31fac050e89106";
      sha256 = "18ryafbx31f4ars9k4qfz7k4vmz2z7d0xvyg1kn1x3amh27x3isz";
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
Furthermore [overrideAttrs](https://nixos.org/nixpkgs/manual/#sec-pkg-overrideAttrs)
can be used to to apply custom patches and more.

Please check [build-bs-platform.nix](build-bs-platform.nix) for more information
like customizing OCaml versions and more.

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
      rev = "e3ca38272c47c32e9c223c8bde31fac050e89106";
      sha256 = "18ryafbx31f4ars9k4qfz7k4vmz2z7d0xvyg1kn1x3amh27x3isz";
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
