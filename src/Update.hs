{-# LANGUAGE AllowAmbiguousTypes #-}

module Update where

import qualified Miso
import Miso ((<#), noEff)
import Types

-- | Updates model, optionally introduces side effects.
--
-- A quick run down:
--    `(<#)` is a smart constructor for an `Effect` with exactly one action.
updateApp :: Msg -> App -> Miso.Effect Msg App
updateApp msg appModel =
  case appModel of
    Initializing initModel -> pure $ Initializing initModel
    FailedToInitialize initModel err -> pure $ FailedToInitialize initModel err
    Ready model -> do
      m <- updateModel msg model
      pure $ Ready m

updateModel :: Msg -> Model -> Miso.Effect Msg Model
updateModel msg model =
  case msg of
    HandleURI uri -> noEff model{ currentURI = uri }
    ChangeURI uri -> model <# do Miso.pushURI uri >> pure NoOp
    AddOne -> noEff model{ counter + 1}
    SubtractOne -> noEff model{ counter - 1}
    Initialize ->  model <# do Miso.consoleLog "Starting up..." >> pure NoOp
    NoOp -> model <# do Miso.consoleLog "Noop" >> pure NoOp
