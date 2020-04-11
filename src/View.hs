module View where

import Data.Proxy (Proxy(..))
import qualified Miso
import Miso.Html
import Miso.String (ms)
import Routes (Route)
import qualified Routes
import Servant.API ((:<|>)(..))
import Types

viewApp :: App -> Miso.View Msg
viewApp appModel =
  case appModel of
    Initializing _initModel -> div_ [] [text "Initializing..."]
    FailedToInitialize _initModel err -> div_ [] [text ("Failed to initialize: " <> err)]
    Ready model -> div_ [] [routeToPage model]

routeToPage :: Model -> Miso.View Msg
routeToPage model = either (const notFoundPage) id page
  where
    page = Miso.runRoute (Proxy @Route) handlers (\m -> m.currentURI) model
    handlers = topPage :<|> listPage :<|> editPage

topPage :: Model -> View Msg
topPage = listPage

listPage :: Model -> View Msg
listPage _model =
  div_
    []
    [ button_ [onClick $ ChangeURI $ Routes.editLink "test"] [text "Go to edit"]
    ]

editPage :: RepoId -> Model -> View Msg
editPage _query model =
  div_
    []
    [ button_ [onClick AddOne] [text "+"],
      text . ms $ model.counter,
      button_ [onClick SubtractOne] [text "-"]
    ]

notFoundPage :: View action
notFoundPage = errorPage "Not found"

errorPage :: MisoString -> View action
errorPage err =
  div_
    []
    [ text err
    ]
