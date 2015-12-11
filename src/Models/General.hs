{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE FlexibleContexts       #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
module Models.General ( module GHC.Generics
                      , ToJSON(toJSON)
                      , FromJSON(parseJSON)
                      , HasId(..)
                      , HasCreator(..)
                      , HasHappend(..)
                      , HasType(..)
                      , Id
                      , toJSONPrefixed
                      , parseJSONPrefixed
                      ) where

import Data.Aeson
import Data.Aeson.Types
import Data.Aeson.Casing
import GHC.Generics
import Data.Time            (UTCTime)
import Servant.Docs

type Id = Integer

toJSONPrefixed :: (Generic a, GToJSON (Rep a)) => a -> Value
toJSONPrefixed = genericToJSON $ aesonPrefix camelCase

parseJSONPrefixed :: (Generic a, GFromJSON (Rep a)) => Value -> Parser a
parseJSONPrefixed = genericParseJSON $ aesonPrefix camelCase

class HasId a where
    identifier :: a -> Id

class HasCreator a where
    creator :: a -> Id

class HasHappend a where
    happend :: a -> UTCTime

class HasType a where
    getType :: a -> String
    getSuperType :: a -> String

instance ToSample Id Id where
    toSample _ = Just 1
