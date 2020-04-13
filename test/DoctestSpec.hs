module DoctestSpec where

import Test.DocTest
import Test.Hspec

import Build_doctests (flags, module_sources, pkgs)

spec :: Spec
spec = parallel $
  describe "Error messages" $
    it "should pass the doctest" $
      doctest $
        [ "-F"
        , "-pgmF=record-dot-preprocessor"
        -- Hacky solution to get doctest to stop complaining about:
        --     attempting to use module ‘main:Prelude’ which is not loaded
        -- because we are using base-noprelude
        , "-package base"
        ] <> flags <> pkgs <> module_sources
