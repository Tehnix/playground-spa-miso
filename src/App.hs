module App (app) where

import Control.Lens ((%=), (+=), (-=), (.=), (^.))
import Miso (App (..))
import qualified Miso
import Miso.Html
import Miso.String (ms)
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
      events = Miso.defaultEvents,
      subs = [Miso.uriSub HandleURI],
      mountPoint = Nothing
    }

initModel :: URI -> Model
initModel uri =
  Model
    { _counter = 0,
      _currentURI = uri
    }
