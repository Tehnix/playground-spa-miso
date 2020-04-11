with (import ./default.nix);
release.env.overrideAttrs (old: {
  shellHook = ''
    alias hpack=${miso-pkgs.pkgs.haskell.packages.ghc865.hpack}/bin/hpack

    # Make sure our generated .cabal file and configuration is always up-to-date.
    hpack

    function refresh () {
      echo ">> Compiling index.html to file://$(pwd)/dist-newstyle/build/x86_64-linux/ghcjs-8.6.0.1/app-0.1.0.0/x/app/build/app/app.jsexe/index.html"
      ${miso-pkgs.pkgs.ag}/bin/ag -l | ${miso-pkgs.pkgs.entr}/bin/entr sh -c '${miso-pkgs.pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal --project-file=ghcjs.project new-build --ghcjs'
    }

    function clean () {
      ${miso-pkgs.pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal new-clean
    }

    function build () {
      ${miso-pkgs.pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal --project-file=ghcjs.project new-build --ghcjs
    }

    function optimize () {
      echo "Running clouse-compiler on ./result/bin/app-exe.jsexe/all.js"
      mkdir -p dist
      cp ./index.html dist/index.html
      ${miso-pkgs.pkgs.closurecompiler}/bin/closure-compiler \
        --compilation_level ADVANCED_OPTIMIZATIONS \
        --jscomp_off=checkVars \
        --externs=./result/bin/app-exe.jsexe/all.js.externs \
        ./result/bin/app-exe.jsexe/all.js > ./dist/all.js
    }
  '';
})
