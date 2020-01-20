with (import ./default.nix);
dev.env.overrideAttrs (old: {
  shellHook = ''
    export NIX_GHC="$(which ghc)"
    export NIX_GHCPKG="$(which ghc-pkg)"
    export NIX_GHC_DOCDIR="$NIX_GHC/../../share/doc/ghc/html"
    export NIX_GHC_LIBDIR="$(ghc --print-libdir)"

    function reload () {
      echo "🚧 Currently broken until JSAddle is fixed 🚧"
      ${pkgs.haskell.packages.ghc865.ghcid}/bin/ghcid -c '${pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal new-repl app:exe:app' -T ':main' --restart 'app.cabal' --reload src
    }
    function refresh () {
      ${pkgs.haskell.packages.ghc865.ghcid}/bin/ghcid -c '${pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal new-repl' -T ':main' --restart src
    }
    function dev () {
      ${pkgs.haskell.packages.ghc865.ghcid}/bin/ghcid -c '${pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal new-repl'
    }
  '';
})
