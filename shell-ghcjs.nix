with (import ./default.nix);
release.env.overrideAttrs (old: {
  shellHook = ''
    export PATH="${miso-pkgs.pkgs.haskell.packages.ghcjs86.hpack}/bin:$PATH"
    export PATH="${bootPkgs.cabal-install}/bin:$PATH"
    export PATH="${miso-pkgs.pkgs.closurecompiler}/bin:$PATH"
    export PATH="${miso-pkgs.pkgs.entr}/bin:$PATH"
    export PATH="${miso-pkgs.pkgs.ag}/bin:$PATH"
    export PATH="${miso-pkgs.pkgs.haskell.packages.ghc865.record-dot-preprocessor}/bin:$PATH"

    export PATH_TO_CABAL_OUTPUT=dist-newstyle/build/x86_64-linux/ghcjs-8.6.0.1/miso-spa-0.1.0.0/x/app-exe/build/app-exe/app-exe.jsexe
    export PATH_TO_NIX_OUTPUT=result/bin/app-exe.jsexe

    # Make sure our generated .cabal file and configuration is always up-to-date.
    hpack

    function refresh () {
      echo ">> Compiling index.html to file://$(pwd)/$PATH_TO_CABAL_OUTPUT/index.html"
      ag -l | entr sh -c 'cabal --project-file=ghcjs.project v2-build --ghcjs'
    }

    function clean () {
      cabal v2-clean
    }

    function build () {
      cabal --project-file=ghcjs.project v2-build --ghcjs
    }

    function optimize () {
      echo "Running clouse-compiler on ./$PATH_TO_CABAL_OUTPUT/all.js"
      mkdir -p dist
      cp ./index.html dist/index.html

      closure-compiler \
        --compilation_level ADVANCED_OPTIMIZATIONS \
        --jscomp_off=checkVars \
        --externs=./$PATH_TO_CABAL_OUTPUT/all.js.externs \
        ./$PATH_TO_CABAL_OUTPUT/all.js > ./dist/all.js
    }
  '';
})
