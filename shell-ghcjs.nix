with (import ./default.nix);
release.env.overrideAttrs (old: {
  shellHook = ''
    alias hpack=${miso-pkgs.pkgs.haskell.packages.ghc865.hpack}/bin/hpack
    alias http-serve=${nodePackages.http-serve}

    # Make sure our generated .cabal file and configuration is always up-to-date.
    hpack
    cabal --project-file=ghcjs.project v2-configure --ghcjs

    function refresh () {
      echo ">> Compiling index.html to file://$(pwd)/dist-newstyle/build/x86_64-linux/ghcjs-8.6.0.1/app-0.1.0.0/x/app/build/app/app.jsexe/index.html"
      ${pkgs.ag}/bin/ag -l | ${pkgs.entr}/bin/entr sh -c '${pkgs.haskell.packages.ghc865.cabal-install}/bin/cabal --project-file=ghcjs.project new-build --ghcjs'
    }
  '';
})
