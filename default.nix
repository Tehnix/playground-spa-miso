let
  pkgs = import <miso-pkgs-base> { };
  ghcide-pkgs = import (builtins.fetchTarball
    "https://github.com/hercules-ci/ghcide-nix/tarball/master") { };

  base-noprelude-src = pkgs.fetchFromGitHub {
    owner = "kowainik";
    repo = "base-noprelude";
    rev = "e5cb48f7f344de339b9ce5e4473dfbd532ba52bc";
    sha256 = "02rl1isbzd9r1hmg7js1fm9l9qg8j0c27rhjbwli6fqnq221fbrf";
  } { };
  overlay = pkgs: super:
    with pkgs.haskell.lib; {
      haskell = pkgs.haskell // {
        packages = pkgs.haskell.packages // {
          ghcjs86 = pkgs.haskell.packages.ghcjs86.override {
            overrides = selfPkgs: superPkgs:
              with pkgs.haskell.lib; rec {
                base-noprelude =
                  selfPkgs.callCabal2nix "base-noprelude" base-noprelude-src;
              };
          };
          ghc865 = pkgs.haskell.packages.ghc865.override {
            overrides = selfPkgs: superPkgs:
              with pkgs.haskell.lib; rec {
                base-noprelude =
                  selfPkgs.callCabal2nix "base-noprelude" base-noprelude-src;
              };
          };
        };
      };
    };
  miso-pkgs = import (builtins.fetchTarball
    "https://github.com/dmjio/miso/archive/9701b0931dd3d1d7f940e94f30932d413ee8e572.tar.gz") {
      overlays = [ overlay ];
    };
in {
  # Inherit allows us to use the `miso-pkgs` and `ghcide-pkgs` variable from another lexical scope.
  inherit miso-pkgs;
  inherit ghcide-pkgs;

  # Our dev package set configures our Miso project with JSAddle and regular GHC.
  dev = miso-pkgs.pkgs.haskell.packages.ghc865.callCabal2nix "miso-spa" ./. {
    miso = miso-pkgs.miso-jsaddle;
  };
  # Our release package set configures our Miso project with GHCJS.
  release =
    miso-pkgs.pkgs.haskell.packages.ghcjs86.callCabal2nix "miso-spa" ./. { };
}
