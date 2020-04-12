module Zrelude
  ( module Relude
  , fms
  , MisoString
  )
where

import Miso.String (FromMisoString, MisoString, fromMisoString)
import Relude

-- | Convenience function, shorthand for `fromMisoString`
fms :: FromMisoString a => MisoString -> a
fms = fromMisoString
