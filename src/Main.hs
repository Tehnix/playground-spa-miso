{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE CPP #-}
module Main where

#ifndef __GHCJS__
import Miso (JSM)
import qualified Miso as Miso
import Language.Javascript.JSaddle.Warp as JSaddle
-- import qualified Network.Wai.Handler.Warp as Warp
-- import qualified Network.WebSockets as WebSockets
#endif

import qualified App as App

-- | Set up our app with JSAddle or the plain app, depending on if our target
-- is GHC or GHCJS.
#ifndef __GHCJS__
runApp :: JSM () -> IO ()
runApp f =
  JSaddle.run 8080 f
  -- Warp.runSettings (Warp.setPort 8080 (Warp.setTimeout 3600 Warp.defaultSettings)) =<<
  --  JSaddle.jsaddleOr defaultConnectionOptions (f >> Miso.syncPoint) JSaddle.jsaddleApp
#else
runApp :: IO () -> IO ()
runApp app = app
#endif

main :: IO ()
main = runApp $ App.app
