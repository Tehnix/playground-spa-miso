module App (app) where

import Miso (App(..))
import qualified Miso
import Network.URI (URI)
import Types
import qualified Update
import qualified View
import Zrelude


app :: Miso.JSM ()
app = do
  uri <- Miso.getCurrentURI
  Miso.startApp
    Miso.App
      { initialAction = Initialize,
        model = initModel uri,
        update = Update.updateApp,
        view = View.viewApp,
        subs = [Miso.uriSub HandleURI],
        events = Miso.defaultEvents,
        mountPoint = Nothing
      }

initModel :: URI -> Types.App
initModel uri = Initializing $ InitModel "" uri
