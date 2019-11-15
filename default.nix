{ pkgs ? import <nixpkgs> {} }:
with pkgs;
import ./bs-platform.nix { inherit stdenv fetchgit ninja nodejs ocamlPackages python35; }
