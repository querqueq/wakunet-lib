{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Waku.Models.Timeline where

import Control.Applicative
import Waku.Models.General
import Waku.Models.Discussion
import Waku.Models.Event
import Waku.Models.Rating
import Waku.Models.Notification
import Data.Time        (UTCTime(..),fromGregorian)
import Data.Maybe       (fromMaybe, isJust)
import Data.List        (sort,sortBy, nub)
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
    , metaSubscribed    :: Bool
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

instance HasContentKey Content where
    contentKey (ContentDiscussion x) = contentKey x
    contentKey (ContentEvent x) = contentKey x

participatingUsers :: Content -> [Id]
participatingUsers x = let
    f (ContentDiscussion (Discussion {..})) = discussionCreatorId : concat (map (f.ContentDiscussion) discussionSubPosts)
    f (ContentEvent (Event {..})) = nub eventParticipants
    in nub $ f x

instance FromJSON Content where
    parseJSON x = ContentDiscussion <$> parseJSON x
              <|> ContentEvent <$> parseJSON x

instance ToSample Timeline Timeline where
    toSamples _ = [ ("Timeline for 20th Dec 2015", sampleTimeline1)
                  , ("Timeline for 25th Dec 2015", sampleTimeline2)
                  ]

instance ToSample Content Content where
    toSamples _ = 
        [ ("A discussion",ContentDiscussion sampleDiscussionParent)
        , ("An event",ContentEvent sampleEvent1)
        ]

-- TODO Move this to timeline-service but keep samples somehow here

timeline :: Maybe UTCTime -> UTCTime -> [Content] -> [Ratings] -> [Notification] -> Timeline
timeline (Just from) till content ratings subs = timeline Nothing till (filter (\x -> happened x > from) content) ratings subs
timeline _ till content ratings subs = Timeline till
    $ map (\x -> attachMeta 
        (M.lookup (contentKey x) ratingsMap) 
        (M.lookup (contentKey x) subsMap)
         x)
    $ sortBy (\x y -> compare (happened y) (happened x))
    $ filter (\x -> happened x < till) content
    where ratingsMap = toMap ratings
          subsMap = toMap subs
          toMap ls = foldr (\x m -> M.insert (contentKey x) x m) M.empty ls

attachMeta :: Maybe Ratings -> Maybe Notification -> Content -> Meta
attachMeta r s c = Meta (happened c) c r (isSubscribed s)

--isSubscribed = maybe False (notificationPersistence == "persistent")
isSubscribed = maybe False (\x -> maybe True (=="persistent") $ notificationPersistence x)

sampleTimeline1 = sampleTimeline (UTCTime (fromGregorian 2015 12 20) (60*60*2))
sampleTimeline2 = sampleTimeline (UTCTime (fromGregorian 2015 12 25) (60*60*12))
sampleTimeline till = timeline Nothing till 
    [ContentDiscussion sampleDiscussionParent
    ,ContentEvent sampleEvent1
    ,ContentEvent sampleEvent2
    ]
    [sampleRatingsNoLikes (discussionId sampleDiscussionParent) "post"
    ,sampleRatingsNoLikes (eventId sampleEvent1) "event"
    ,sampleRatingsNoLikes (eventId sampleEvent2) "event"
    ]
    [sampleNotificationFor (discussionId sampleDiscussionParent) "post"
    ,sampleNotificationFor (eventId sampleEvent1) "event"
    ,sampleNotificationFor (eventId sampleEvent2) "event"
    ]
