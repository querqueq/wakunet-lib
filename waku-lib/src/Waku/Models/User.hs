{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Waku.Models.User where

import Waku.Models.General
import Data.Time        (UTCTime(..),fromGregorian)
import Data.Maybe       (fromMaybe)
import Servant.Docs     (ToSample(..))

data User = User
    { userId            :: Id
    , userFirstname     :: Maybe String
    , userLastname      :: Maybe String
    , userEmail         :: String
    , userContentKey    :: ContentKey
    } deriving (Eq, Generic, Show)

instance ToJSON User where 
    toJSON = toJSONPrefixed

instance FromJSON User where 
    parseJSON = parseJSONPrefixed

instance HasId User where
    identifier (User {..}) = userId

instance HasType User where
    getSuperType (User {..}) = contentType userContentKey

instance ToSample User User where
    toSample _ = Just $ sampleUser 1

instance ToSample [User] [User] where
    toSample _ = Just [sampleUser 1]

defaultUser = User
    { userId = 1
    , userFirstname = Just $ "John"
    , userLastname = Just $ "Doe"
    , userEmail = "johndoe@waku.at"
    , userContentKey = ContentKey 1 "user"
    }

sampleUser 1 = defaultUser
