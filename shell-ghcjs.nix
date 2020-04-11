with (import ./default.nix);
release.env.overrideAttrs (old: {
  shellHook = ''
    alias hpack=${miso-pkgs.pkgs.haskell.packages.ghc865.hpack}/bin/hpack

    alias closure-compiler=${miso-pkgs.pkgs.closurecompiler}/bin/closure-compiler
    alias entr=${miso-pkgs.pkgs.entr}/bin/entr
    alias ag=${miso-pkgs.pkgs.ag}/bin/ag
    alias cabal=${miso-pkgs.pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal

    # Make sure our generated .cabal file and configuration is always up-to-date.
    hpack

    function refresh () {
      echo ">> Compiling index.html to file://$(pwd)/dist-newstyle/build/x86_64-linux/ghcjs-8.6.0.1/miso-spa-0.1.0.0/x/app-exe/build/app-exe/app-exe.jsexe/index.html"
      ag -l | entr sh -c 'cabal --project-file=ghcjs.project new-build --ghcjs'
    }

    function clean () {
      cabal new-clean
    }

    function build () {
      cabal --project-file=ghcjs.project new-build --ghcjs
    }

    function optimize () {
      echo "Running clouse-compiler on ./dist-newstyle/build/x86_64-linux/ghcjs-8.6.0.1/miso-spa-0.1.0.0/x/app-exe/build/app-exe/app-exe.jsexe/all.js"
      mkdir -p dist
      cp ./index.html dist/index.html

      closure-compiler \
        --compilation_level ADVANCED_OPTIMIZATIONS \
        --jscomp_off=checkVars \
        --externs=./dist-newstyle/build/x86_64-linux/ghcjs-8.6.0.1/miso-spa-0.1.0.0/x/app-exe/build/app-exe/app-exe.jsexe/all.js.externs \
        ./dist-newstyle/build/x86_64-linux/ghcjs-8.6.0.1/miso-spa-0.1.0.0/x/app-exe/build/app-exe/app-exe.jsexe/all.js > ./dist/all.js
    }
  '';
})
