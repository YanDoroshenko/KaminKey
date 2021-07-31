{-# LANGUAGE OverloadedStrings #-}
module Main where

import Config

import Control.Applicative (empty)
import Control.Monad.IO.Class
import Network.HTTP.Req
import Data.Aeson
import Data.Aeson.Types
import Data.Maybe

clientId1 = "540844003997239"

clientSecret1 = "35b837649a84d763fa2eb6f8ee333077"

clientCredentials :: String
clientCredentials = "client_credentials"

data Token = Token { token :: String }

instance FromJSON Token where
  parseJSON (Object v) = Token <$> v .: "access_token"
  parseJSON _ = empty

main :: IO ()
main = runReq defaultHttpConfig $ do
  maybeConfig <- liftIO $ readConfig
  case maybeConfig of
    (Right config) -> do
      tokenResp <-
        req
          GET
          (https "graph.facebook.com" /: "oauth" /: "access_token")
          NoReqBody -- use built-in options or add your own
          jsonResponse -- specify how to interpret response
          (mconcat [("client_id" =: (clientId config)), ("client_secret" =: (clientSecret config)), ("grant_type" =: clientCredentials)])  -- query params, headers, explicit port number, etc.
      let x = parseMaybe parseJSON $ responseBody tokenResp :: Maybe Token
      liftIO $ print $ fromMaybe "empty" (token <$> x)
    (Left err) -> liftIO $ print $ "Can't parse config: " ++ (show err)
