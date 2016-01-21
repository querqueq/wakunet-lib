{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE FlexibleContexts       #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE DeriveGeneric          #-}
module Waku.Models.General
    ( module GHC.Generics
    , ToJSON(toJSON)
    , FromJSON(parseJSON)
    , HasId(..)
    , HasCreator(..)
    , HasHappened(..)
    , HasType(..)
    , HasContentKey(..)
    , Id
    , ContentType
    , ContentId
    , ContentKey(..)
    , toJSONPrefixed
    , parseJSONPrefixed
    , AString(..)
    ) where

import Data.Aeson
import Data.Aeson.Types
import Data.Aeson.Casing
import GHC.Generics
import Data.Time            (UTCTime)
import Data.Int             (Int64)
import Servant.Docs

type Id = Int64

type ContentType = String
type ContentId = Id

data ContentKey = ContentKey
    { contentId     :: ContentId
    , contentType   :: ContentType
    } deriving (Show, Generic, Eq, Ord)

instance ToJSON ContentKey where
instance FromJSON ContentKey where

data AString = AString
    { astringValue :: String
    } deriving (Show, Generic, Eq)

instance ToJSON AString where
    toJSON = toJSONPrefixed

instance FromJSON AString where
    parseJSON = parseJSONPrefixed 

toJSONPrefixed :: (Generic a, GToJSON (Rep a)) => a -> Value
toJSONPrefixed = genericToJSON $ aesonPrefix camelCase

parseJSONPrefixed :: (Generic a, GFromJSON (Rep a)) => Value -> Parser a
parseJSONPrefixed = genericParseJSON $ aesonPrefix camelCase

instance ToSample ContentKey ContentKey where
    toSample _ = Just $ ContentKey 13 "post"

instance ToSample [ContentKey] [ContentKey] where
    toSample _ = Just [ContentKey 13 "post",ContentKey 4 "event",ContentKey 1 "post"]

class HasId a where
    identifier :: a -> Id

class HasCreator a where
    creator :: a -> Id

class HasHappened a where
    happened :: a -> UTCTime

class HasType a where
    getType :: a -> String
    getSuperType :: a -> String

class Transformable a b where
    transform :: Maybe b -> a -> b

class HasContentKey a where
    contentKey :: a -> ContentKey

instance ToSample Id Id where
    toSample _ = Just 1

instance ToSample AString AString where
    toSample _ = Just $ AString "Lorem Ipsum"

instance HasContentKey ContentKey where
    contentKey = id
