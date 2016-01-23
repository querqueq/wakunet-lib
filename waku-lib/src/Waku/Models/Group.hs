{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Waku.Models.Group where

import Waku.Models.General
import Data.Time        (UTCTime(..),fromGregorian)
import Data.Maybe       (fromMaybe)
import Servant.Docs     (ToSample(..))

data Group = Group
    { groupId            :: Id
    , groupName     :: String
    , groupContentKey    :: ContentKey
    } deriving (Eq, Generic, Show)

instance ToJSON Group where 
    toJSON = toJSONPrefixed

instance FromJSON Group where 
    parseJSON = parseJSONPrefixed

instance HasId Group where
    identifier (Group {..}) = groupId

instance HasType Group where
    getSuperType (Group {..}) = contentType groupContentKey

instance ToSample Group Group where
    toSample _ = Just $ sampleGroup 1

instance ToSample [Group] [Group] where
    toSample _ = Just [sampleGroup 1]

defaultGroup = Group
    { groupId = 42
    , groupName = "Default Group"
    , groupContentKey = ContentKey 42 "group"
    }

sampleGroup 1 = defaultGroup
