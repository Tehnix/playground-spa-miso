let
  pkgs = import <nixpkgs> {};
  miso-pkgs = import (builtins.fetchTarball {
    url = "https://github.com/dmjio/miso/archive/561ffad.tar.gz";
    sha256 = "1wwzckz2qxb873wdkwqmx9gmh0wshcdxi7gjwkba0q51jnkfdi41";
  }) {};
  ghcide-pkgs = import (builtins.fetchTarball "https://github.com/hercules-ci/ghcide-nix/tarball/master") {};
in
  {
    # Inherit allows us to use the `miso-pkgs` and `ghcide-pkgs` variable from another lexical scope.
    inherit miso-pkgs;
    inherit ghcide-pkgs;
    inherit pkgs;

    nodePackages = pkgs.nodePackages.node2nix {};
    # Our dev package set configures our Miso project with JSAddle and regular GHC.
    dev = miso-pkgs.pkgs.haskell.packages.ghc865.callCabal2nix "app" ./. { miso = miso-pkgs.miso-jsaddle; };
    # Our release package set configures our Miso project with GHCJS.
    release = miso-pkgs.pkgs.haskell.packages.ghcjs86.callCabal2nix "app" ./. {};
  }
