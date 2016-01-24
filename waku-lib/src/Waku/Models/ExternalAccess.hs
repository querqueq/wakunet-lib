{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Waku.Models.ExternalAccess where

import Data.Time        (UTCTime(..),fromGregorian)
import Data.Maybe       (fromMaybe,fromJust)
import Servant.Docs     (ToSample(..))
import qualified Data.UUID as U
import Data.UUID.Aeson

import Waku.Models.General
import Waku.Models.Profile
import Waku.Models.Timeline
import Waku.Models.Discussion

data AccessLevel = Read | Write deriving (Show,Eq,Enum,Ord,Generic,Read)

instance ToJSON AccessLevel
instance FromJSON AccessLevel 

type ExternalAccessId = U.UUID
data ExternalAccess = ExternalAccess
    { externalaccessUuid              :: ExternalAccessId
    , externalaccessCreatorId         :: Id
    , externalaccessUserId            :: Id
    , externalaccessEmail             :: String
    , externalaccessAlias             :: Maybe String
    , externalaccessCreated           :: UTCTime 
    , externalaccessExpires           :: Maybe UTCTime
    , externalaccessAccessRevoked     :: Bool
    , externalaccessLevel             :: AccessLevel
    , externalaccessAccessibleContent :: ContentKey
    } deriving (Eq, Generic, Show)

instance ToJSON ExternalAccess where 
    toJSON = toJSONPrefixed
instance FromJSON ExternalAccess where 
    parseJSON = parseJSONPrefixed

data ExternalAccessRequest = ExternalAccessRequest
    { externalaccessrequestEmail             :: String
    , externalaccessrequestExpires           :: Maybe UTCTime
    , externalaccessrequestLevel             :: AccessLevel
    , externalaccessrequestAccessibleContent :: ContentKey
    } deriving (Eq, Generic, Show)

instance ToJSON ExternalAccessRequest where 
    toJSON = toJSONPrefixed

instance FromJSON ExternalAccessRequest where 
    parseJSON = parseJSONPrefixed

data ExternalContent = ExternalContent
    { ecContent           :: Content
    , ecExternalAccess   :: ExternalAccess
    , ecProfiles          :: [Profile]
    } deriving (Show, Generic)

instance ToJSON ExternalContent where
    toJSON = toJSONPrefixed
instance FromJSON ExternalContent where
    parseJSON = parseJSONPrefixed

instance HasCreator ExternalAccess where
    creator (ExternalAccess {..}) = externalaccessCreatorId

instance ToSample ExternalAccess ExternalAccess where
    toSample _ = Just $ sampleExternalAccess 1

instance ToSample [ExternalAccess] [ExternalAccess] where
    toSample _ = Just $ [sampleExternalAccess 1]

instance ToSample ExternalAccessId ExternalAccessId where
    toSample _ = U.fromString "a91a964b-6ace-454b-a5ac-5a37315d23f3"

instance ToSample ExternalAccessRequest ExternalAccessRequest where
    toSample _ = Just $ sampleExternalAccessRequest 1

instance ToSample AccessLevel AccessLevel where
    toSample _ = Just Write

instance ToSample ExternalContent ExternalContent where
    toSample _ = Just $ ExternalContent (ContentDiscussion sampleDiscussionParent) (sampleExternalAccess 1) [sampleProfile 1]

defaultExternalAccessRequest = ExternalAccessRequest
    { externalaccessrequestEmail = "john@example.org"
    , externalaccessrequestExpires = Just $ UTCTime (fromGregorian 2015 12 08) (fromIntegral 60*60*19)
    , externalaccessrequestLevel = Write
    , externalaccessrequestAccessibleContent = ContentKey 5 "post"
    }

defaultExternalAccess = ExternalAccess
    { externalaccessUuid = U.nil
    , externalaccessCreatorId = 1
    , externalaccessUserId = 22
    , externalaccessEmail = "john@example.org"
    , externalaccessAlias = Just "John"
    , externalaccessCreated = UTCTime (fromGregorian 2015 12 08) (fromIntegral 60*60*19) -- TODO replace with call to sample time
    , externalaccessExpires = Nothing
    , externalaccessAccessRevoked = False
    , externalaccessAccessibleContent = ContentKey 1 "post"
    , externalaccessLevel = Read
    }

sampleExternalAccess 1 = defaultExternalAccess {externalaccessUuid = fromJust $ U.fromString "1c012ed3-877d-44b8-87ac-eae9b1ef7b1b"}
sampleExternalAccessRequest 1 = defaultExternalAccessRequest
