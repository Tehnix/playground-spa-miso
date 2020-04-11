let
  miso-pkgs = import (builtins.fetchTarball {
    url = "https://github.com/dmjio/miso/archive/561ffad.tar.gz";
    sha256 = "1wwzckz2qxb873wdkwqmx9gmh0wshcdxi7gjwkba0q51jnkfdi41";
  }) {};
  # miso-pkgs = import (builtins.fetchTarball "https://github.com/dmjio/miso/archive/6ed0800c789b4feedda81c5fb3ece7895ab54f25.tar.gz") {};
  ghcide-pkgs = import (builtins.fetchTarball "https://github.com/hercules-ci/ghcide-nix/tarball/master") {};
in
  {
    # Inherit allows us to use the `miso-pkgs` and `ghcide-pkgs` variable from another lexical scope.
    inherit miso-pkgs;
    inherit ghcide-pkgs;

    # Our dev package set configures our Miso project with JSAddle and regular GHC.
    dev = miso-pkgs.pkgs.haskell.packages.ghc865.callCabal2nix "miso-spa" ./. { miso = miso-pkgs.miso-jsaddle; };
    # Our release package set configures our Miso project with GHCJS.
    release = miso-pkgs.pkgs.haskell.packages.ghcjs86.callCabal2nix "miso-spa" ./. {};
  }
