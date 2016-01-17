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

data Profile = Profile
    { profileUserId              :: Id
    , profileFirstName           :: String
    , profileSurname             :: String
    , profilePicture             :: Maybe String
    , profileLargeProfilePicture :: Maybe String
    , profileSmallProfilePicture :: Maybe String
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

instance ToSample Profile Profile where
    toSample _ = Just $ sampleProfile 1

instance ToSample [Profile] [Profile] where
    toSample _ = Just [sampleProfile 1]

defaultProfile = Profile
    { profileUserId = 1
    , profileFirstName = "John"
    , profileSurname = "Doe"
    , profilePicture = Nothing
    , profileLargeProfilePicture = Nothing
    , profileSmallProfilePicture = Nothing
    , profileState = Nothing
    , profileGender = Nothing
    , profileEmail = Nothing
    , profileEmployedSince = Nothing
    , profileAbout = Nothing
    }

sampleProfile 1 = defaultProfile
