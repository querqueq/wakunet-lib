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

type ExternalAccessId = U.UUID
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

instance ToSample ExternalAccessId ExternalAccessId where
    toSample _ = U.fromString "a91a964b-6ace-454b-a5ac-5a37315d23f3"

defaultExternalAccess = ExternalAccess
    { externalAccessUuid = U.nil
    , externalAccessCreatorId = 1
    , externalAccessEmail = "john@example.org"
    , externalAccessAlias = Just "John"
    , externalAccessCreated = UTCTime (fromGregorian 2015 12 08) (fromIntegral 60*60*19) -- TODO replace with call to sample time
    , externalAccessExpires = Nothing
    , externalAccessAccessRevoked = False
    , externalAccessAccessibleContent = ContentKey 13 "post"
    }

sampleExternalAccess 1 = defaultExternalAccess {externalAccessUuid = fromJust $ U.fromString "1c012ed3-877d-44b8-87ac-eae9b1ef7b1b"}
