{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Models.Timeline where

import Models.General
import Models.Discussion
import Models.Event
import Data.Time        (UTCTime(..),fromGregorian)
import Data.Maybe       (fromMaybe)
import Data.List        (sort,sortBy)
import Data.Dynamic
import Servant.Docs     (ToSample(..))

data Timeline = Timeline 
    { timelineTill      :: UTCTime
    , timelineContent   :: [Content] 
    } deriving (Generic, Show)

instance ToJSON Timeline where 
    toJSON = toJSONPrefixed

data Content = ContentDiscussion Discussion 
             | ContentEvent Event
             deriving Show

instance HasHappend Content where
    happend (ContentDiscussion x) = happend x
    happend (ContentEvent x) = happend x

instance ToJSON Content where
    toJSON (ContentDiscussion x) = toJSON x
    toJSON (ContentEvent x)     = toJSON x

instance ToSample Timeline Timeline where
    toSamples _ = [ ("Timeline for 20th Dec 2015", sampleTimeline1)
                  , ("Timeline for 25th Dec 2015", sampleTimeline2)
                  ]

timeline :: UTCTime -> [Content] -> Timeline
timeline till content = Timeline till $ sortBy (\x y -> compare (happend y) (happend x)) $ filter (\x -> happend x < till) content

sampleTimeline1 = sampleTimeline (UTCTime (fromGregorian 2015 12 20) (60*60*2))
sampleTimeline2 = sampleTimeline (UTCTime (fromGregorian 2015 12 25) (60*60*12))
sampleTimeline till = timeline till 
    [ ContentDiscussion sampleDiscussionParent
    , ContentEvent sampleEvent1
    , ContentEvent sampleEvent2
    ]
