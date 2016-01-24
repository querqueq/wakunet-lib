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
import Waku.Models.Chat
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
    , timelineContents  :: [Meta]
    , timelineStickies  :: [Meta]
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
    , metaSticky        :: Bool
    } deriving (Generic, Show)

instance ToJSON Meta where
    toJSON = toJSONPrefixed

instance FromJSON Meta where
    parseJSON = parseJSONPrefixed

data NewContent = NewContentDiscussion NewDiscussion deriving Show

instance ToJSON NewContent where
    toJSON (NewContentDiscussion x) = toJSON x

instance FromJSON NewContent where
    parseJSON x = NewContentDiscussion <$> parseJSON x

data Content = ContentDiscussion Discussion
             | ContentEvent Event
             | ContentChatDescriptor ChatDescriptor
             deriving Show


instance HasId Content where
    identifier (ContentDiscussion x) = identifier x
    identifier (ContentEvent x) = identifier x
    identifier (ContentChatDescriptor x) = identifier x

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
    toJSON (ContentChatDescriptor x)     = toJSON x

instance HasContentKey Content where
    contentKey (ContentDiscussion x) = contentKey x
    contentKey (ContentEvent x) = contentKey x

participatingUsers :: Content -> [Id]
participatingUsers x = let
    f (ContentDiscussion (Discussion {..})) = discussionCreatorId : concat (map (f.ContentDiscussion) $ maybe [] id discussionSubPosts)
    f (ContentEvent (Event {..})) = eventParticipants
    f (ContentChatDescriptor (ChatDescriptor {..})) = cdParticipants
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

instance ToSample NewContent NewContent where
    toSamples _ = [ ("A new discussion", NewContentDiscussion $ sampleNewDiscussion 1)]

-- TODO Move this to timeline-service
-- 1. Write full timeline sample
-- 2. move code to timeline-service
-- 3. add quicktests to timeline-service which compare samle with result of timeline

timeline :: Maybe UTCTime -> UTCTime -> [Content] -> [Ratings] -> [Notification] -> Timeline
timeline (Just from) till content ratings subs = timeline Nothing till (filter (\x -> happened x > from) content) ratings subs
timeline _ till content ratings subs = Timeline till 
    (filter (\(Meta {..}) -> not metaSticky) list) 
    (filter (\(Meta {..}) -> metaSticky) list)
    where ratingsMap = toMap ratings
          subsMap = toMap subs
          toMap ls = foldr (\x m -> M.insert (contentKey x) x m) M.empty ls
          list = map (\x -> attachMeta (M.lookup (contentKey x) ratingsMap) (M.lookup (contentKey x) subsMap) x)
            $ sortBy (\x y -> compare (happened y) (happened x))
            $ filter (\x -> happened x < till) content


attachMeta :: Maybe Ratings -> Maybe Notification -> Content -> Meta
attachMeta r s c = Meta (happened c) c r (isSubscribed s) (isStickied c)

isStickied (ContentDiscussion (Discussion {..})) = discussionSticky
isStickied _ = False

--isSubscribed = maybe False (notificationPersistence == "persistent")
isSubscribed = maybe False (\x -> maybe True (=="persistent") $ notificationPersistence x)

sampleTimeline1 = sampleTimeline (UTCTime (fromGregorian 2015 12 20) (60*60*2))
sampleTimeline2 = sampleTimeline (UTCTime (fromGregorian 2015 12 25) (60*60*12))
sampleTimeline till = timeline Nothing till 
    [ContentDiscussion $ sampleDiscussionParent { discussionSticky = True } 
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
