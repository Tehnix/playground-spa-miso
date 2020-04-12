{-# LANGUAGE OverlappingInstances #-}
module Types where

import Data.Generics.Labels ()
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
      { config     :: MisoString,
        currentURI :: URI
      }
  deriving (Show, Eq, Generic)

data Model
  = App
      { counter    :: Int,
        currentURI :: URI
      }
  deriving (Show, Eq, Generic)

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
