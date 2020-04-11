with (import ./default.nix);
dev.env.overrideAttrs (old: {
  shellHook = ''
    export NIX_GHC="$(which ghc)"
    export NIX_GHCPKG="$(which ghc-pkg)"
    export NIX_GHC_DOCDIR="$NIX_GHC/../../share/doc/ghc/html"
    export NIX_GHC_LIBDIR="$(ghc --print-libdir)"

    alias stylish-haskell=${miso-pkgs.pkgs.haskell.packages.ghc865.stylish-haskell}/bin/stylish-haskell
    alias hlint=${miso-pkgs.pkgs.haskell.packages.ghc865.hlint}/bin/hlint
    alias ghcide=${ghcide-pkgs.ghcide-ghc865}/bin/ghcide
    alias hpack=${miso-pkgs.pkgs.haskell.packages.ghc865.hpack}/bin/hpack
    alias doctest=${miso-pkgs.pkgs.haskell.packages.ghc865.doctest}/bin/doctest
    alias cabal=${miso-pkgs.pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal
    alias ghcid=${miso-pkgs.pkgs.haskell.packages.ghc865.ghcid}/bin/ghcid

    # Make sure our generated .cabal file and configuration is always up-to-date.
    hpack

    function reload () {
      echo "🚧 Currently broken until JSAddle is fixed 🚧"
      echo "🔗 (see https://github.com/ghcjs/jsaddle/issues/107) 🔗"
      ghcid -c 'cabal new-repl --ghc exe:app-exe' -T ':main' --restart 'miso-spa.cabal' --reload src
    }

    function refresh () {
      ghcid -c 'cabal new-repl --ghc exe:app-exe' -T ':main' --restart 'miso-spa.cabal' --restart src
    }

    function run-ghcid () {
      ghcid -c 'cabal new-repl --ghc'
    }
  '';
})
