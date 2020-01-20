{-# LANGUAGE OverloadedStrings #-}

module Update where

import Control.Lens ((%=), (+=), (-=), (.=), (^.))
import qualified Miso
import Types

-- | Updates model, optionally introduces side effects.
--
-- Instead of digging around in the model directly, we use `Transition`,
-- which is based on the StateT monad transformer, and can be used to construct
-- components. It also works very nicely with lenses based on MonadState (i.e.
-- (.=), (%=), (+=), (-=)).
--
-- For an overview of the Lens operators, check out http://hackage.haskell.org/package/lens-4.18.1/docs/Control-Lens-Operators.html.
-- A quick run down:
--    `(.=)` is also called `assign`, and allows you to assign a value
--    `(^.)` is also called `view`, and allows you to get a value
--    `(+=)` directly adds a value (much like `+=` in other languages)
--    `(-=)` directly subtracts a value (much like `-=` in other languages)
--    `(%=)` is also called `modifying`, and lets you modify something (i.e. you can
--     write `(+=)` as `counter %= (+ 1)`)
updateModel :: Msg -> Miso.Transition Msg Model ()
updateModel msg =
  case msg of
    HandleURI uri -> currentURI .= uri
    ChangeURI uri -> do
      _ <- pure $ Miso.pushURI uri
      pure ()
    Initializing -> pure ()
    FailedToInitialize err -> pure ()
    Ready model -> pure ()
    AddOne ->
      counter += 1
    SubtractOne ->
      counter -= 1
    NoOp -> do
      Miso.scheduleIO_ (Miso.consoleLog "Noop")
      pure ()
