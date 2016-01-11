{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Waku.Models.ExternalAccess where

import Waku.Models.General
import Data.Time        (UTCTime(..),fromGregorian)
import Data.Maybe       (fromMaybe)
import Servant.Docs     (ToSample(..))

type ExternalAccessId = String
data ExternalAccess = ExternalAccess
    { externalAccessUuid              :: ExternalAccessId
    , externalAccessCreatorId         :: Id
    , externalAccessEmail             :: String
    , externalAccessAlias             :: Maybe String
    , externalAccessCreated           :: UTCTime 
    , externalAccessExpires           :: Maybe UTCTime
    , externalAccessAccessRevoked     :: Bool
    , externalAccessAccessibleContent :: ContentKey
    } deriving (Eq, Generic)

instance ToJSON ExternalAccess where 
    toJSON = toJSONPrefixed

instance FromJSON ExternalAccess where 
    parseJSON = parseJSONPrefixed

instance HasCreator ExternalAccess where
    creator (ExternalAccess {..}) = externalAccessCreatorId

instance ToSample ExternalAccess ExternalAccess where
    toSample _ = Just $ sampleExternalAccess 1

defaultExternalAccess = ExternalAccess
    { externalAccessUuid = ""
    , externalAccessCreatorId = 1
    , externalAccessEmail = "john@example.org"
    , externalAccessAlias = Just "John"
    , externalAccessCreated = UTCTime (fromGregorian 2015 12 08) (fromIntegral 60*60*19) -- TODO replace with call to sample time
    , externalAccessExpires = Nothing
    , externalAccessAccessRevoked = False
    , externalAccessAccessibleContent = ContentKey 13 "post"
    }

sampleExternalAccess 1 = defaultExternalAccess {externalAccessUuid = "1c012ed3-877d-44b8-87ac-eae9b1ef7b1b"}
 
