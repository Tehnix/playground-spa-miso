{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
module App (app) where

import Miso (App(..), View, Transition, Effect, onClick, button_, div_, text)
import qualified Miso as Miso
import Miso.String
import Control.Lens

import Types

app = Miso.startApp App {..}
  where
    initialAction = SayHelloWorld -- initial action to be executed on application load
    model  = Model 0              -- initial model
    update = Miso.fromTransition . updateModel -- update function
    view   = viewModel            -- view function
    events = Miso.defaultEvents        -- default delegated events
    subs   = []                   -- empty subscription list
    mountPoint = Nothing          -- mount point for application (Nothing defaults to 'body')


-- | Updates model, optionally introduces side effects
updateModel :: Action -> Transition Action Model ()
updateModel action =
  case action of
    AddOne
      -> counter += 1
    SubtractOne
      -> counter -= 1
    NoOp
      -> pure ()
    SayHelloWorld
      -> Miso.scheduleIO_ (Miso.consoleLog "Hello World")

-- | Constructs a virtual DOM from a model
viewModel :: Model -> View Action
viewModel x = div_ [] [
   button_ [ onClick AddOne ] [ text "+" ]
 , text . ms $ x^.counter
 , button_ [ onClick SubtractOne ] [ text "-" ]
 ]
