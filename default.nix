{ pkgs ? import <nixpkgs> {} }:
with pkgs;
{
  bs-platform6 = import ./build-bs-platform.nix {
    inherit stdenv fetchFromGitHub ninja runCommand nodejs python3;
    version = "6.2.1";
    ocaml-version = "4.06.1";
    src = fetchFromGitHub {
        owner = "BuckleScript";
        repo = "bucklescript";
        rev = "59357b7a2a5063718a385438e5cb0de7bd3b5398";
        sha256 = "0zx9nq7cik0c60n3rndqfqy3vdbj5lcrx6zcqcz2d60jjxi1z32y";
        fetchSubmodules = true;
    };
  };
  bs-platform7 = import ./build-bs-platform.nix {
    inherit stdenv fetchFromGitHub ninja runCommand nodejs python3;
    version = "7.0.1";
    ocaml-version = "4.06.1";
    src = fetchFromGitHub {
        owner = "BuckleScript";
        repo = "bucklescript";
        rev = "52770839e293ade2bcf187f2639000ca0a9a1d46";
        sha256 = "0s7g2zfhshsilv9zyp0246bypg34d294z27alpwz03ws9608yr7k";
        fetchSubmodules = true;
    };
  };
}
