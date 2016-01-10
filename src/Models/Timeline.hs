{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Models.Timeline where

import Control.Applicative
import Models.General
import Models.Discussion
import Models.Event
import Models.Rating
import Data.Time        (UTCTime(..),fromGregorian)
import Data.Maybe       (fromMaybe)
import Data.List        (sort,sortBy)
import Data.Dynamic
import qualified Data.Map as M
import Servant.Docs     (ToSample(..))

data Timeline = Timeline 
    { timelineTill      :: UTCTime
    , timelineContents   :: [Meta] 
    } deriving (Generic, Show)

instance ToJSON Timeline where 
    toJSON = toJSONPrefixed
instance FromJSON Timeline where
    parseJSON = parseJSONPrefixed

data Meta = Meta 
    { metaHappened      :: UTCTime
    , metaContent       :: Content
    , metaRatings       :: Maybe Ratings
    } deriving (Generic, Show)

instance ToJSON Meta where 
    toJSON = toJSONPrefixed

instance FromJSON Meta where 
    parseJSON = parseJSONPrefixed

data Content = ContentDiscussion Discussion 
             | ContentEvent Event
             deriving Show

instance HasId Content where
    identifier (ContentDiscussion x) = identifier x
    identifier (ContentEvent x) = identifier x

instance HasHappened Content where
    happened (ContentDiscussion x) = happened x
    happened (ContentEvent x) = happened x

instance HasType Content where
    getType (ContentDiscussion x) = getType x
    getType (ContentEvent x) = getType x
    getSuperType (ContentDiscussion x) = getSuperType x
    getSuperType (ContentEvent x) = getSuperType x

instance ToJSON Content where
    toJSON (ContentDiscussion x) = toJSON x
    toJSON (ContentEvent x)     = toJSON x

instance FromJSON Content where
    parseJSON x = ContentDiscussion <$> parseJSON x
              <|> ContentEvent <$> parseJSON x

instance ToSample Timeline Timeline where
    toSamples _ = [ ("Timeline for 20th Dec 2015", sampleTimeline1)
                  , ("Timeline for 25th Dec 2015", sampleTimeline2)
                  ]

timeline :: Maybe UTCTime -> UTCTime -> [Content] -> [Ratings] -> Timeline
timeline (Just from) till content ratings = timeline Nothing till (filter (\x -> happened x > from) content) ratings
timeline _ till content ratings = Timeline till 
    $ map    (\x -> attachMeta (M.lookup (ContentKey (identifier x) (getSuperType x)) ratingsMap) x)
    $ sortBy (\x y -> compare (happened y) (happened x)) 
    $ filter (\x -> happened x < till) content
    where ratingsMap = foldr (\r m -> M.insert (contentKey r) r m) M.empty ratings


attachMeta :: Maybe Ratings -> Content -> Meta
attachMeta r c = Meta (happened c) c r

sampleTimeline1 = sampleTimeline (UTCTime (fromGregorian 2015 12 20) (60*60*2))
sampleTimeline2 = sampleTimeline (UTCTime (fromGregorian 2015 12 25) (60*60*12))
sampleTimeline till = timeline Nothing till 
    [ ContentDiscussion sampleDiscussionParent
    , ContentEvent sampleEvent1
    , ContentEvent sampleEvent2
    ]
    [sampleRatings]
