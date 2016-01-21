{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Waku.Models.Url where

import Waku.Models.General
import Servant.Docs     (ToSample(..))

data Url = Url
    { urlUrl :: String
    } deriving (Eq, Generic, Show)

instance ToJSON Url where 
    toJSON = toJSONPrefixed

instance FromJSON Url where 
    parseJSON = parseJSONPrefixed

instance ToSample Url Url where
    toSample _ = Just sampleUrl

sampleUrl = Url
    { urlUrl = "http://www.wakunet.at/externals/a91a964b-6ace-454b-a5ac-5a37315d23f3"
    }
