module Types where

import Control.Lens

-- | Type synonym for an application model
data Model
  = Model
  { _counter :: Int
  } deriving (Show, Eq)

counter :: Lens' Model Int
counter = lens _counter $ \record field -> record { _counter = field }

-- | Sum type for application events
data Action
  = AddOne
  | SubtractOne
  | NoOp
  | SayHelloWorld
  deriving (Show, Eq)