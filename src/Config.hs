{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
module Config where

import GHC.Generics
import System.Directory (getCurrentDirectory)
import Data.Yaml

configFileName = "config.yaml"

data Config = Config { clientId :: String, clientSecret :: String } deriving (Generic, FromJSON)

readConfig :: IO (Either ParseException Config)
readConfig = do
  dir <- getCurrentDirectory
  let configFile = dir ++ "/" ++ configFileName
  decodeFileEither configFile
