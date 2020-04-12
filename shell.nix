with (import ./default.nix);
dev.env.overrideAttrs (old: {
  shellHook = ''
    export NIX_GHC="$(which ghc)"
    export NIX_GHCPKG="$(which ghc-pkg)"
    export NIX_GHC_DOCDIR="$NIX_GHC/../../share/doc/ghc/html"
    export NIX_GHC_LIBDIR="$(ghc --print-libdir)"

    export PATH="${bootPkgs.stylish-haskell}/bin:$PATH"
    export PATH="${bootPkgs.hlint}/bin:$PATH"
    export PATH="${ghcide-pkgs.ghcide-ghc865}/bin:$PATH"
    export PATH="${miso-pkgs.pkgs.haskell.packages.ghc865.hpack}/bin:$PATH"
    export PATH="${bootPkgs.doctest}/bin:$PATH"
    export PATH="${bootPkgs.cabal-install}/bin:$PATH"
    export PATH="${bootPkgs.ghcid}/bin:$PATH"
    export PATH="${miso-pkgs.pkgs.haskell.packages.ghc865.record-dot-preprocessor}/bin:$PATH"

    # Make sure our generated .cabal file and configuration is always up-to-date.
    hpack

    function reload () {
      echo "🚧 Currently broken until JSAddle is fixed 🚧"
      echo "🔗 (see https://github.com/ghcjs/jsaddle/issues/107) 🔗"
      ghcid -c 'cabal v2-repl --ghc exe:app-exe' -T ':main' --restart 'miso-spa.cabal' --reload src
    }

    function refresh () {
      ghcid -c 'cabal v2-repl --ghc exe:app-exe' -T ':main' --restart 'miso-spa.cabal' --restart src
    }

    function run-ghcid () {
      ghcid -c 'cabal v2-repl --ghc exe:app-exe'
    }
  '';
})
