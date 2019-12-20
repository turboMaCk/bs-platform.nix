{ pkgs ? import <nixpkgs> {} }:
with pkgs;
{
  bs-platform6 = import ./bs-platform6.nix {
    inherit stdenv fetchFromGitHub ninja nodejs python3;
  };
  bs-platform7 = import ./bs-platform7.nix {
    inherit stdenv fetchFromGitHub ninja nodejs python3;
  };
}
