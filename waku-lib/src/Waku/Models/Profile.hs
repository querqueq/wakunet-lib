{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Waku.Models.Profile where

import Waku.Models.General
import Data.Time        (UTCTime(..),fromGregorian)
import Data.Maybe       (fromMaybe)
import Servant.Docs     (ToSample(..))

data ProfileRequest = ProfileRequest
    { prUserIds     :: [Id] 
    } deriving (Show, Eq, Generic)

instance ToJSON ProfileRequest where 
    toJSON = toJSONPrefixed

instance FromJSON ProfileRequest where 
    parseJSON = parseJSONPrefixed

data Profile = Profile
    { profileUserId              :: Id
    , profileFirstName           :: Maybe String
    , profileSurname             :: Maybe String
    , profilePicture             :: Maybe String
    , profileProfilePicture      :: Maybe String
    , profileState               :: Maybe String
    , profileGender              :: Maybe String
    , profileEmail               :: Maybe String
    , profileEmployedSince       :: Maybe String
    , profileAbout               :: Maybe String
    } deriving (Eq, Generic, Show)

instance ToJSON Profile where 
    toJSON = toJSONPrefixed

instance FromJSON Profile where 
    parseJSON = parseJSONPrefixed

instance HasId Profile where
    identifier (Profile {..}) = profileUserId

instance ToSample ProfileRequest ProfileRequest where
    toSample _ = Just $ sampleProfileRequest 1

instance ToSample Profile Profile where
    toSample _ = Just $ sampleProfile 1

instance ToSample [Profile] [Profile] where
    toSample _ = Just [sampleProfile 1]

defaultProfile = Profile
    { profileUserId = 1
    , profileFirstName = Just "John"
    , profileSurname = Just "Doe"
    , profilePicture = Nothing
    , profileProfilePicture = Nothing
    , profileState = Nothing
    , profileGender = Nothing
    , profileEmail = Nothing
    , profileEmployedSince = Nothing
    , profileAbout = Nothing
    }

sampleProfile 1 = defaultProfile
sampleProfileRequest 1 = ProfileRequest [1,5,13]
