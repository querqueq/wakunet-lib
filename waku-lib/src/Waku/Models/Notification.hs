{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Waku.Models.Notification where

import Waku.Models.General
import Data.Time        (UTCTime(..),fromGregorian)
import Data.Maybe       (fromMaybe)
import Servant.Docs     (ToSample(..))

data Notification = Notification
    { notificationSenderId              :: Maybe Id
    -- ^ UserId of notification creator
    , notificationRecipientId           :: Id
    -- ^ UserId of notification target
    , notificationContentId             :: Id
    , notificationContentType           :: String
    , notificationNotificationType      :: Maybe String
    -- ^ Custom set notification type (e.g. UI uses this to decide how to display notification)
    , notificationPersistence           :: Maybe String
    -- ^ Whether notification will be saved to db ("persistent") or memory ("volatile")
    } deriving (Eq, Generic, Show)

instance ToJSON Notification where 
    toJSON = toJSONPrefixed

instance FromJSON Notification where 
    parseJSON = parseJSONPrefixed

instance HasContentKey Notification where
    contentKey x = ContentKey (notificationContentId x) (notificationContentType x)

instance ToSample Notification Notification where
    toSample _ = Just $ sampleNotification 1

instance ToSample [Notification] [Notification] where
    toSample _ = Just $ [sampleNotification 1]

defaultNotification = Notification
    { notificationSenderId = Just 1
    , notificationRecipientId = 1
    , notificationContentId = 13
    , notificationContentType = "post"
    , notificationPersistence = Just "persistent"
    , notificationNotificationType = Just "custom"
    }

sampleNotification 1 = defaultNotification
sampleNotificationFor cid ct = defaultNotification 
    { notificationContentType = ct
    , notificationContentId = cid
    }
