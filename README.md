# SPA Playground: Miso
Playing around with Miso SPAs and structuring them for larger scale applications. The purpose is to avoid servers, so we are explicitly not aiming at an isomorphic setup, but purely SPA.

**To Do:**

The goal is to somewhat replicate the setup achieved in [the Elm SPA playground](https://github.com/Tehnix/playground-spa-elm):

- [ ] Routing
- [ ] GraphQL
- [ ] Material UI (might need to make a wrapper for this)
- [ ] I18n
- [ ] Authentication
- [ ] Doc Tests

## Developing

We'll use Nix to manage our tools and build our project. Nix is the best option when GHCJS is involved, so we'll set up our toolchain around working with that.

If you haven't set up Nix then [follow these steps if you are on macOS](https://gist.github.com/Tehnix/38efa7ff1215ae49bf17925ce1684266#setting-up-nix), or simply run `sh <(curl https://nixos.org/nix/install) --daemon` on Linux.

After you have Nix running, set up our caches for much faster builds,

```bash
$ nix-env -iA cachix -f https://cachix.org/api/v1/install # Install cachix for quick builds
$ cachix use hercules-ci # Add general cachix
$ cachix use miso-haskell # Add Miso's cachix
```
<!--
Unfortunately installing our desired formatter is a few more steps (make sure to also add `~/.cabal/bin/` to your `$PATH`),

```
$ nix-shell # Drop into the nix shell
$ cabal new-update # Make sure cabal has the package list
$ cabal new-install ormolu
``` -->

Use your editor,

```bash
$ nix-shell
$ code . # For VS Code, replace with your desired editor
```


Run `ghcid` (typechecking, warnings, etc) in a terminal with,

```bash
$ nix-shell --run dev
```

Run our site on `http://localhost:8080` with hot-reloading (broken until [jsaddle#107](https://github.com/ghcjs/jsaddle/issues/107) is fixed),

```bash
$ nix-shell --run reload
```

This works by [switching between GHC and GHCJS](https://github.com/dmjio/miso/blob/master/sample-app-jsaddle/Main.hs#L32-L40) depending on the target.

## Building for Release

```bash
$ nix-build -A release && nix-shell --run optimize
```

Your optimized `all.js` and `index.html` will now be located in `dist/`.

## Setup

### 🚧 GraphQL 🚧

We'll use [morpheus](https://github.com/morpheusgraphql/morpheus-graphql).

### 🚧 Material UI 🚧

Material-UI could potentially be ported easily by using [material-components-web-elm](https://github.com/aforemny/material-components-web-elm/tree/2.0.1) as the base, and then migrating the [Elm files](https://github.com/aforemny/material-components-web-elm/tree/2.0.1/src/Material) to Miso/Haskell syntax


### 🚧 i18n 🚧
- i18n support can quickly be built, taking inspiration from [i18next-elm](https://github.com/ChristophP/elm-i18next/tree/4.0.0), which more or less just implements a [single file](https://github.com/ChristophP/elm-i18next/blob/4.0.0/src/I18Next.elm)

### 🚧 Verified Examples in Documentation 🚧

Look at [doctest](https://hackage.haskell.org/package/doctest)

### 🚧 CI 🚧

We use Github actions to build the project, run tests, and run doc tests in the CI pipeline. Check out the workflows in `.github/workflows/` to see the specific workflows that are set up.

## Resources

- [Getting Started Haskell Project with Nix](https://maybevoid.com/posts/2019-01-27-getting-started-haskell-nix.html)
- [How to simply get your dependencies with Nix](https://dev.to/monacoremo/how-to-simply-get-your-dependencies-with-nix-2ce1)
- Take inspiration from the [web-haskell boilerplate](https://github.com/dandoh/web-haskell), which sets up GraphQL, dotenv, jwt etc
