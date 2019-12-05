{ pkgs ? import <nixpkgs> {} }:
with pkgs;
import ./bs-platform.nix { inherit stdenv fetchFromGitHub ninja nodejs python3; }
