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
    , Id
    , ContentType
    , ContentId
    , ContentKey(..)
    , toJSONPrefixed
    , parseJSONPrefixed
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

instance ToJSON ContentKey
instance FromJSON ContentKey

toJSONPrefixed :: (Generic a, GToJSON (Rep a)) => a -> Value
toJSONPrefixed = genericToJSON $ aesonPrefix camelCase

parseJSONPrefixed :: (Generic a, GFromJSON (Rep a)) => Value -> Parser a
parseJSONPrefixed = genericParseJSON $ aesonPrefix camelCase

class HasId a where
    identifier :: a -> Id

class HasCreator a where
    creator :: a -> Id

class HasHappened a where
    happened :: a -> UTCTime

class HasType a where
    getType :: a -> String
    getSuperType :: a -> String

instance ToSample Id Id where
    toSample _ = Just 1
