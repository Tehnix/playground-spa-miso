with (import ./default.nix);
# dev.env.overrideAttrs (old: {
#   shellHook = ''
#     export NIX_GHC="$(which ghc)"
#     export NIX_GHCPKG="$(which ghc-pkg)"
#     export NIX_GHC_DOCDIR="$NIX_GHC/../../share/doc/ghc/html"
#     export NIX_GHC_LIBDIR="$(ghc --print-libdir)"

#     rm cabal.project.local
#     function reload () {
#       echo "🚧 Currently broken until JSAddle is fixed 🚧"
#       ${pkgs.haskell.packages.ghc865.ghcid}/bin/ghcid -c '${pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal new-repl app:exe:app' -T ':main' --restart 'app.cabal' --reload src
#     }
#     function refresh () {
#       ${pkgs.haskell.packages.ghc865.ghcid}/bin/ghcid -c '${pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal new-repl app:exe:app' -T ':main' --restart 'app.cabal' --restart src
#     }
#     function dev () {
#       ${pkgs.haskell.packages.ghc865.ghcid}/bin/ghcid -c '${pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal new-repl'
#     }
#     function optimize () {
#       mkdir -p dist
#       # cp ./result/bin/app.jsexe/index.html dist/index.html
#       ${pkgs.closurecompiler}/bin/closure-compiler \
#         --compilation_level ADVANCED_OPTIMIZATIONS \
#         --jscomp_off=checkVars \
#         --externs=./result/bin/app.jsexe/all.js.externs \
#         ./result/bin/app.jsexe/all.js > ./dist/all.js
#     }
#   '';
# })

release.env.overrideAttrs (old: {
  shellHook = ''
    cabal configure --ghcjs
    function refresh () {
      echo ">> Compiling index.html to file://$(pwd)/dist-newstyle/build/x86_64-linux/ghcjs-8.6.0.1/app-0.1.0.0/x/app/build/app/app.jsexe/index.html"
      ${pkgs.ag}/bin/ag -l | ${pkgs.entr}/bin/entr sh -c '${pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal new-build'
    }
  '';
})
