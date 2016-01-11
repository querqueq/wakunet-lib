{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Models.Event where

import Models.General
import Data.Time        (UTCTime(..),fromGregorian)
import Data.Maybe       (fromMaybe, maybe)
import Servant.Docs     (ToSample(..))

data Event = Event
    { eventId               :: Id
    , eventCreatorId        :: Id
    , eventTitle            :: String
    , eventFromDate         :: UTCTime
    , eventToDate           :: UTCTime
    , eventAllDay           :: Bool
    , eventLocation         :: String
    , eventDescription      :: String
    , eventParticipants     :: [Id]
    , eventType             :: Maybe String
    , eventContentKey       :: ContentKey
    } deriving (Eq, Generic, Show)


instance ToJSON Event where 
    toJSON = toJSONPrefixed

instance FromJSON Event where 
    parseJSON = parseJSONPrefixed

instance HasHappened Event where
    happened (Event {..}) = eventFromDate

instance HasId Event where
    identifier (Event {..}) = eventId   

instance HasCreator Event where
    creator (Event {..}) = eventCreatorId

instance HasType Event where
    getType (Event {..}) = maybe "" id eventType
    getSuperType (Event {..}) = contentType eventContentKey 

instance ToSample Event Event where
    toSample _ = Just sampleEvent1

instance ToSample [Event] [Event] where
    toSample _ = Just [sampleEvent1, sampleEvent2]

defaultEvent = Event
    { eventId           = 1
    , eventCreatorId    = 1
    , eventTitle        = "Template Event"
    , eventFromDate     = UTCTime (fromGregorian 2015 1 1) 0
    , eventToDate       = UTCTime (fromGregorian 2015 1 1) 0
    , eventAllDay       = False
    , eventLocation     = ""
    , eventDescription  = ""
    , eventParticipants = []
    , eventType         = Just "PlainEvent"
    , eventContentKey   = ContentKey 1 "event"
    }

sampleEvent1 = defaultEvent
    { eventId           = 1
    , eventTitle        = "Xmas party"
    , eventFromDate     = UTCTime (fromGregorian 2015 12 23) (60*60*17)
    , eventToDate       = UTCTime (fromGregorian 2015 12 24) (60*60*6)
    , eventLocation     = "Main building"
    , eventDescription  = "Friends and family welcome"
    , eventParticipants = [2,3,6]
    }

sampleEvent2 = defaultEvent
    { eventId           = 2
    , eventTitle        = "Jour fixe"
    , eventFromDate     = UTCTime (fromGregorian 2015 12 12) (60*60*10)
    , eventToDate       = UTCTime (fromGregorian 2015 12 12) (60*60*11)
    , eventLocation     = "Meeting Room C"
    , eventDescription  = ""
    , eventParticipants = [1..7]
    }

