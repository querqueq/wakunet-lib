{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE DeriveGeneric              #-}

module Waku.Models.Rating where

import Data.Aeson                  (ToJSON, FromJSON)
import GHC.Generics                (Generic)
import Data.Time
import Data.Text
import Data.Int                    (Int64,Int)

import Servant.Docs

import Waku.Models.General

data Ratings = Ratings
    { ratingsLikes         :: Int
    , ratingsDislikes      :: Int
    , ratingsContentKey    :: ContentKey
    , ratingsUserId        :: Id
    , ratingsUserRating    :: Maybe String
    } deriving (Show,Eq,Generic)

instance ToJSON Ratings where toJSON = toJSONPrefixed
instance FromJSON Ratings where parseJSON = parseJSONPrefixed

instance HasContentKey Ratings where
    contentKey = ratingsContentKey

instance ToSample Ratings Ratings where
    toSample _ = Just $ sampleRatings

instance ToSample [Ratings] [Ratings] where
    toSample _ = Just $ [sampleRatings, sampleRatingsNoLikes 3 "event", sampleRatingsNoLikes 5 "post"]

instance ToSample ContentKey ContentKey where
    toSample _ = Just $ ContentKey 13 "post"

instance ToSample [ContentKey] [ContentKey] where
    toSample _ = Just [ContentKey 13 "post",ContentKey 4 "event",ContentKey 1 "post"]

sampleRatings = Ratings 2 1 (ContentKey 13 "post") 2 $ Just "Dislike"
sampleRatingsNoLikes id ctype = Ratings 0 0 (ContentKey id ctype) 2 Nothing
