module App (app) where

import Miso (App (..))
import qualified Miso
import Network.URI (URI)
import Types
import qualified Update
import qualified View

app :: Miso.JSM ()
app = Miso.miso $ \uri ->
  App
    { initialAction = Initializing,
      model = initModel uri,
      update = Miso.fromTransition . Update.updateModel,
      view = View.viewModel,
      subs = [Miso.uriSub HandleURI],
      events = Miso.defaultEvents,
      mountPoint = Nothing
    }

initModel :: URI -> Model
initModel uri =
  Model
    { _counter = 0,
      _currentURI = uri
    }
