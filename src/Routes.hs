module Routes where

import Data.Proxy (Proxy(..))
import qualified Miso
import Servant.API ((:<|>), (:>), Capture)
import qualified Servant.API as Servant
import Servant.Links (URI)
import qualified Servant.Links as Servant
import Types

type Route =
  TopRoute
    :<|> ListRoute
    :<|> EditRoute

type TopRoute = Miso.View Msg

type ListRoute = "repos" :> Miso.View Msg

type EditRoute = "repos" :> Capture "ident" RepoId :> Miso.View Msg

listLink :: URI
listLink = Servant.linkURI $ Servant.safeLink (Proxy @Route) (Proxy @ListRoute)

editLink :: RepoId -> URI
editLink repoId = Servant.linkURI $ Servant.safeLink (Proxy @Route) (Proxy @EditRoute) repoId
