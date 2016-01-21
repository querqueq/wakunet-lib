{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Waku.Models.Chat where

import Waku.Models.General
import Data.Time        (UTCTime(..),fromGregorian)
import Data.Maybe       (fromMaybe)
import Servant.Docs     (ToSample(..))

data ChatDescriptor = ChatDescriptor
    { cdChatId          :: Id
    , cdParticipants    :: [Id]
    , cdMessages        :: [ChatMessage]
    } deriving (Eq, Generic, Show)

instance ToJSON ChatDescriptor where 
    toJSON = toJSONPrefixed

instance FromJSON ChatDescriptor where 
    parseJSON = parseJSONPrefixed

data ChatMessage = ChatMessage
    { cmMessageId       :: Id
    , cmChatId          :: Id
    , cmSent            :: String
    , cmSenderId        :: Id
    , cmHasRead         :: [Id]
    , cmMessage         :: String
    } deriving (Eq, Generic, Show)

instance ToJSON ChatMessage where 
    toJSON = toJSONPrefixed

instance FromJSON ChatMessage where 
    parseJSON = parseJSONPrefixed

instance HasId ChatDescriptor where
    identifier (ChatDescriptor {..}) = cdChatId

instance HasId ChatMessage where
    identifier (ChatMessage {..}) = cmMessageId

instance ToSample ChatDescriptor ChatDescriptor where
    toSample _ = Just $ sampleChatDescriptor 1

instance ToSample ChatMessage ChatMessage where
    toSample _ = Just $ sampleChatMessage 1

defaultChatDescriptor = ChatDescriptor
    { cdChatId = 1
    , cdParticipants = [5,13]
    , cdMessages = [sampleChatMessage 1]
    }

sampleChatDescriptor 1 = defaultChatDescriptor

defaultChatMessage = ChatMessage
    { cmMessageId = 22
    , cmChatId = 1
    , cmSent = show $ UTCTime (fromGregorian 2016 2 1) (10*60*60)
    , cmSenderId = 5
    , cmHasRead = [13]
    , cmMessage = "Hello!"
    }

sampleChatMessage 1 = defaultChatMessage
