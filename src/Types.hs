{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE TemplateHaskell #-}

module Types where

import Control.Lens
import Network.URI (URI)

-- | Type synonym for an application model
data App
  = Initializing InitModel
  | FailedToInitialize InitModel ErrorMessage
  | Ready Model
  deriving (Show, Eq)

type ErrorMessage = MisoString

data InitModel
  = InitModel
      { _config     :: MisoString,
        _currentURI :: URI
      }
  deriving (Show, Eq)

data Model
  = App
      { _counter    :: Int,
        _currentURI :: URI
      }
  deriving (Show, Eq)


makeLensesWith classUnderscoreNoPrefixFields ''InitModel
makeLensesWith classUnderscoreNoPrefixFields ''Model

type RepoId = String

-- | Sum type for application events
data Msg
  = HandleURI URI
  | ChangeURI URI
  | Initialize
  | NoOp
  | AddOne
  | SubtractOne
  deriving (Show, Eq)
