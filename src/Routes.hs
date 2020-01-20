{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeOperators #-}

module Routes where

import Data.Proxy (Proxy (..))
import qualified Miso
import qualified Servant.API as Servant
import Servant.API ((:<|>), (:>), Capture)
import qualified Servant.Links as Servant
import Servant.Links (URI)
import Types

type Route =
  TopRoute
    :<|> ListRoute
    :<|> EditRoute

type TopRoute = Miso.View Msg

type ListRoute = "repos" :> Miso.View Msg

type EditRoute = "repos" :> Capture "ident" RepoId :> Miso.View Msg

listLink :: URI
listLink = Servant.safeLink (Proxy @Route) (Proxy @ListRoute)

editLink :: RepoId -> URI
editLink = Servant.safeLink (Proxy @Route) (Proxy @EditRoute)
