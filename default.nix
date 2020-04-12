let
  bootPkgs = import <nixpkgs> { };
  ghcide-pkgs = import (builtins.fetchTarball
    "https://github.com/hercules-ci/ghcide-nix/tarball/master") { };
  miso-pkgs = import (builtins.fetchTarball
    "https://github.com/codetalkio/miso/archive/fc52d0c5ca57b170552b96d695da9761a5db3610.tar.gz")
    { };

  # NOTE: Switch back to Miso's packages when we figure out how to do overlays.
  # # We use a patched fork of base-noprelude which is compatible with GHCJS.
  # base-noprelude-src = bootPkgs.fetchFromGitHub {
  #   owner = "codetalkio";
  #   repo = "base-noprelude";
  #   rev = "00b9f86b788d5e3558846b292a6bf6b25816647b";
  #   sha256 = "0ziqdg5n4fg83wykbbdhbmki5mksyzaxvw3bma2qain9hz5bran6";
  # };
  # # The recordDotSyntax preprocessor is not in the package set.
  # record-dot-preprocessor-src = bootPkgs.fetchFromGitHub {
  #   owner = "ndmitchell";
  #   repo = "record-dot-preprocessor";
  #   rev = "a513c0cb496b93b1981308ef7847099e218427ba";
  #   sha256 = "0lzm51ji4y10a496cn68610f9a29jbfcdj6lz8f4csvq470gcfry";
  # };
  # packageOverrides = selfPkgs: superPkgs: {
  #   base-noprelude =
  #     selfPkgs.callCabal2nix "base-noprelude" base-noprelude-src { };
  #   record-dot-preprocessor = selfPkgs.callCabal2nix "record-dot-preprocessor"
  #     record-dot-preprocessor-src { };
  # };
  # overlay = self: pkgs:
  #   with pkgs.haskell.lib; {
  #     haskell = pkgs.haskell // {
  #       packages = pkgs.haskell.packages // {
  #         ghcjs86 = pkgs.haskell.packages.ghcjs86.override {
  #           overrides = packageOverrides;
  #         };
  #         # FIXME: Currently enabling the override for ghc865 causes nix to fail with:
  #         # error: attribute 'miso-jsaddle' missing
  #         ghc865 = pkgs.haskell.packages.ghc865.override {
  #           overrides = packageOverrides;
  #         };
  #       };
  #     };
  #   };
  # miso-pkgs = import (builtins.fetchTarball
  #   "https://github.com/dmjio/miso/archive/5d7f377e3f8baf10ef259a6baf267a5705ebd175.tar.gz") {
  #     overlays = [ overlay ];
  #   };
in {
  # Inherit allows us to use the `miso-pkgs` and `ghcide-pkgs` variable from another lexical scope.
  inherit bootPkgs;
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
