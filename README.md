# SPA Playground: Miso ![ci](https://github.com/Tehnix/playground-spa-miso/workflows/ci/badge.svg)
Playing around with Miso SPAs and structuring them for larger scale applications. The purpose is to avoid servers, so we are explicitly not aiming at an isomorphic setup, but purely SPA.

**To Do:**

The goal is to somewhat replicate the setup achieved in [the Elm SPA playground](https://github.com/Tehnix/playground-spa-elm):

- [ ] Routing
- [ ] GraphQL
- [ ] Material UI (might need to make a wrapper for this)
- [ ] I18n
- [x] Doc Tests
- [x] CI
- [x] Relude (alternative Prelude)

## Developing

Clone down the repo and its submodules,

```bash
$ git clone git@github.com:Tehnix/playground-spa-miso.git
$ git submodule init
$ git submodule update
```

We'll use Nix to manage our tools and build our project. Nix is the best option when GHCJS is involved, so we'll set up our toolchain around working with that.

If you haven't set up Nix then [follow these steps if you are on macOS](https://gist.github.com/Tehnix/38efa7ff1215ae49bf17925ce1684266#setting-up-nix), or simply run `sh <(curl https://nixos.org/nix/install) --daemon` on Linux.

After you have Nix running, set up our caches for much faster builds, and some node dependencies for development,

```bash
$ nix-env -iA cachix -f https://cachix.org/api/v1/install # Install cachix for quick builds
$ cachix use hercules-ci # Add general cachix
$ cachix use miso-haskell # Add Miso's cachix
$ npm i
```

**IDE**

For VS Code, we recommend using the [nix-env-selector](https://github.com/arrterian/nix-env-selector) extension. For other editors, open your editor from within a `nix-shell` session,

```bash
$ nix-shell
$ code . # For VS Code, replace with your desired editor
```

In the nix-shell, you will have access to ghcide, ghcid and hlint.

Run `ghcid` (typechecking, warnings, etc) in a terminal with,

```bash
$ npm run ghcid # or nix-shell --run run-ghcid
```

**Local Development**

Run our site on `http://localhost:8080` with hot-reloading (broken until [jsaddle#107](https://github.com/ghcjs/jsaddle/issues/107) is fixed),

```bash
$ npm run dev:reload # nix-shell --run reload
```

This works by [switching between GHC and GHCJS](https://github.com/dmjio/miso/blob/master/sample-app-jsaddle/Main.hs#L32-L40) depending on the target.

Alternatively you can compile the site on file changes, and access it on [http://127.0.0.1:8081](http://127.0.0.1:8081),

```bash
$ npm run dev
[serve] Starting up http-serve for dist-newstyle/build/x86_64-linux/ghcjs-8.6.0.1/app-0.1.0.0/x/app/build/app/app.jsexe
[serve] Available on:
[serve]   http://127.0.0.1:8081
[ghcjs] Building library for....
```

## Building for Release

```bash
$ npm run build # or nix-build -A release && nix-shell --run optimize
```

Your optimized `all.js` and `index.html` will now be located in `dist/`. You can test it out with `npm run serve:release`.

## Setup

### 🚧 GraphQL 🚧

We'll use [morpheus](https://github.com/morpheusgraphql/morpheus-graphql).

### 🚧 Material UI 🚧

Material-UI could potentially be ported easily by using [material-components-web-elm](https://github.com/aforemny/material-components-web-elm) as the base, and then migrating the [Elm files](https://github.com/aforemny/material-components-web-elm/src/Material) to Miso/Haskell syntax


### 🚧 i18n 🚧

i18n support can quickly be built, taking inspiration from [i18next-elm](https://github.com/ChristophP/elm-i18next/tree/4.0.0), which more or less just implements a [single file](https://github.com/ChristophP/elm-i18next/blob/4.0.0/src/I18Next.elm)

### Verified Examples in Documentation

We use [doctest](https://hackage.haskell.org/package/doctest) to verify all examples in code comments. They can be run with `cabal new-test test:doctests` inside a nix-shell session, and are automatically run in the CI.

Comments are only evalauted in haddock comments. A quick overview:

```
-- $setup
-- >>> let x = 23 :: Int

-- | Compute Fibonacci numbers
--
-- Examples:
--
-- >>> x + 10 + ten
-- 43
--
-- >>> :{
--  let
--    y = 1
--    z = 2
--  in x + y + z + ten
-- :}
-- 36
ten = 10
```

The above illustrates using `$setup` to setup code that should not be included in documentation, along with multi-line blocks (similar to ghci).

### CI

We use Github actions to build the project, run tests, and run doc tests in the CI pipeline. Check out the workflows in `.github/workflows/` to see the specific workflows that are set up.

### Relude as alternative Prelude

We are using [Relude](https://github.com/kowainik/relude) instead of the default Prelude, for safer defaults. You can read a bit about how an alternative Prelude works in the [typeclasses introduction to `NoImplicitPrelude`](https://typeclasses.com/ghc/no-implicit-prelude).

## Resources

- [Relude](https://kowainik.github.io/projects/relude) the alternative Prelude
- [Getting Started Haskell Project with Nix](https://maybevoid.com/posts/2019-01-27-getting-started-haskell-nix.html)
- [How to simply get your dependencies with Nix](https://dev.to/monacoremo/how-to-simply-get-your-dependencies-with-nix-2ce1)
- Take inspiration from the [web-haskell boilerplate](https://github.com/dandoh/web-haskell), which sets up GraphQL, dotenv, jwt etc
