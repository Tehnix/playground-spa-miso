let
  pkgs = import <nixpkgs> { };
  ghcide-pkgs = import (builtins.fetchTarball
    "https://github.com/hercules-ci/ghcide-nix/tarball/master") { };

  # FIXME: This overlay currently doesn't kick-in, so `base-noprelude` is broken for GHCJS until it is fixed.
  base-noprelude-src = pkgs.fetchFromGitHub {
    owner = "codetalkio";
    repo = "base-noprelude";
    rev = "00b9f86b788d5e3558846b292a6bf6b25816647b";
    sha256 = "0ziqdg5n4fg83wykbbdhbmki5mksyzaxvw3bma2qain9hz5bran6";
  };
  overlay = pkgs: super:
    with pkgs.haskell.lib; {
      haskell = pkgs.haskell // {
        packages = pkgs.haskell.packages // {
          ghcjs86 = pkgs.haskell.packages.ghcjs86.override {
            overrides = selfPkgs: superPkgs:
              with pkgs.haskell.lib; rec {
                base-noprelude =
                  selfPkgs.callCabal2nix "base-noprelude" base-noprelude-src
                  { };
              };
          };
          ghc865 = pkgs.haskell.packages.ghc865.override {
            overrides = selfPkgs: superPkgs:
              with pkgs.haskell.lib; rec {
                base-noprelude =
                  selfPkgs.callCabal2nix "base-noprelude" base-noprelude-src
                  { };
              };
          };
        };
      };
    };
  miso-pkgs = import (builtins.fetchTarball
    "https://github.com/dmjio/miso/archive/351738c1e14d11dc3afd00a21ae248acb58c5917.tar.gz") {
      overlays = [ overlay ];
    };
in {
  # Inherit allows us to use the `miso-pkgs` and `ghcide-pkgs` variable from another lexical scope.
  inherit pkgs;
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
