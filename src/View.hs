{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

module View where

import Control.Lens ((%=), (+=), (-=), (.=), (^.))
import Data.Proxy (Proxy (..))
import qualified Miso
import Miso.Html
import Miso.String (ms)
import Routes (Route (..))
import qualified Routes
import Servant.API ((:<|>) (..))
import Types

-- | Constructs a virtual DOM from a model
viewModel :: Model -> Miso.View Msg
viewModel model =
  div_
    []
    [ button_ [onClick AddOne] [text "+"],
      text . ms $ model ^. counter,
      button_ [onClick SubtractOne] [text "-"]
    ]

routeToPage :: Model -> Miso.View Msg
routeToPage model = either (const notFoundPage) id page
  where
    page = Miso.runRoute (Proxy @Route) handlers (^. currentURI) model
    handlers = topPage :<|> listPage :<|> editPage

topPage :: Model -> View Msg
topPage = listPage

listPage :: Model -> View Msg
listPage model =
  div_
    []
    [ button_ [onClick $ ChangeURI $ Routes.editLink "test"] [text "Go to edit"]
    ]

editPage :: RepoId -> Model -> View Msg
editPage query model =
  div_
    []
    [ button_ [onClick AddOne] [text "+"],
      text . ms $ model ^. counter,
      button_ [onClick SubtractOne] [text "-"]
    ]

notFoundPage :: View action
notFoundPage = errorPage "Not found"

errorPage :: String -> View action
errorPage err =
  div_
    []
    [ text . ms $ err
    ]
