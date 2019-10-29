{-# LANGUAGE DeriveAnyClass #-}
module Lib where

import GHC.Generics
import Data.Aeson

import Aws.Lambda
import qualified SongMaker

data APIGatewayRequest = APIGatewayRequest
  { resource :: String
  --, path :: ByteString
  --, httpMethod :: Method
  --, headers :: RequestHeaders
  --, queryStringParameters :: [(ByteString, Maybe ByteString)]
  --, pathParameters :: HashMap String String
  --, stageVariables :: HashMap String String
  , reqBody :: String
  } deriving (Generic, FromJSON)

data APIGatewayResponse = APIGatewayResponse
  { statusCode :: Int
  --, headers :: [(HeaderName, ByteString)]
  , respBody :: String
  } deriving (Generic, ToJSON)
  
handler :: APIGatewayRequest -> Context -> IO (Either String APIGatewayResponse)
handler req context = do
  let res = SongMaker.convertStringLatex $ reqBody req
  case res of
    Left err -> return $ Left err
    Right tex -> return $ Right $ (APIGatewayResponse 200 tex)
