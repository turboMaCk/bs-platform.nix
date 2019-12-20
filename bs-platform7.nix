{ stdenv, fetchFromGitHub, ninja, nodejs, python3 }:
let
  version = "7.0.1";
  ocaml-version = "4.06.1";
  src = fetchFromGitHub {
    owner = "BuckleScript";
    repo = "bucklescript";
    rev = "${version}";
    sha256 = "0s7g2zfhshsilv9zyp0246bypg34d294z27alpwz03ws9608yr7k";
    fetchSubmodules = true;
  };
  ocaml =  import ./ocaml.nix {
    bs-version = version;
    version = ocaml-version;
    inherit stdenv;
    src = "${src}/ocaml";
  };
in
stdenv.mkDerivation {
  inherit src version;
  pname = "bs-platform";
  BS_RELEASE_BUILD = "true";
  buildInputs = [ nodejs python3 ];

  patchPhase = ''
    sed -i 's:./configure.py --bootstrap:python3 ./configure.py --bootstrap:' ./scripts/install.js

    mkdir -p ./native/${ocaml-version}/bin
    ln -sf ${ocaml}/bin/*  ./native/${ocaml-version}/bin

    rm -f vendor/ninja/snapshot/ninja.linux
    cp ${ninja}/bin/ninja vendor/ninja/snapshot/ninja.linux
  '';

  configurePhase = ''
    node scripts/ninja.js config
  '';

  buildPhase = ''
    node scripts/ninja.js build
  '';

  installPhase = ''
    node scripts/install.js

    mkdir -p $out/bin

    cp -rf jscomp lib vendor odoc_gen native $out
    cp bsconfig.json package.json $out

    ln -s $out/lib/bsb $out/bin/bsb
    ln -s $out/lib/bsc $out/bin/bsc
    ln -s $out/lib/bsrefmt $out/bin/bsrefmt
  '';
}
