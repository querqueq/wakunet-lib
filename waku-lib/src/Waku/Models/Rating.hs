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
    , ratingsStickied      :: Bool
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

sampleRatings = Ratings 2 1 False (ContentKey 13 "post") 2 $ Just "Dislike"
sampleRatingsNoLikes id ctype = Ratings 0 0 False (ContentKey id ctype) 2 Nothing
