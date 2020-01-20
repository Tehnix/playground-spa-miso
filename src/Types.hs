{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE TemplateHaskell #-}

module Types where

import Control.Lens
import Miso (URI)

-- | Type synonym for an application model
data Model
  = Model
      { _counter :: Int,
        _currentURI :: URI
      }
  deriving (Show, Eq)

makeLensesWith classUnderscoreNoPrefixFields ''Model

type RepoId = String

-- | Sum type for application events
data Msg
  = HandleURI URI
  | ChangeURI URI
  | Initializing
  | FailedToInitialize String
  | Ready Model
  | NoOp
  | AddOne
  | SubtractOne
  deriving (Show, Eq)
