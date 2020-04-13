import Distribution.Extra.Doctest (defaultMainWithDoctests)

-- | This sets up the generation of `Build_doctests`. Note that the name "app-test" must match
-- the name of the test-suite specified in package.yaml.
main :: IO ()
main = defaultMainWithDoctests "app-test"
