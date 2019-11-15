{ stdenv, fetchgit }:
let
  rev = "6.2.0";
  src = import ./src.nix { inherit fetchgit; };
in
stdenv.mkDerivation rec {
  version = "4.06.1";
  name = "ocaml-${version}+bs-${rev}";
  inherit src;
  configurePhase = ''
    ls -la ocaml
    cd ocaml
    ./configure -prefix $out
  '';
  buildPhase = ''
    make -j9 world.opt
  '';
  installPhase = ''
    make install
  '';

  meta = with stdenv.lib; {
    branch = "4.06";
    platforms = with platforms; linux;
  };
}
