{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
module APIs.TimelineAPI where

import Servant
import Models 
import Servant.Docs
import APIs.Util
import Data.Time        (UTCTime(..))
import Models.General   (Id)
import Data.Text        (Text, pack, unpack)
import Data.Time.Format

import Debug.Trace

type FromParam   = QueryParam "from" UTCTime 
type TillParam   = QueryParam "till" UTCTime
type GroupParam  = QueryParam "group" Id
type TimelineAPI = "timeline" :> SenderId  :> FromParam :> TillParam :> GroupParam :> Get '[JSON] Timeline

timelineAPI :: Proxy TimelineAPI
timelineAPI = Proxy

instance FromText UTCTime where
    fromText t = parseTimeM True defaultTimeLocale "%F" (unpack t)

instance ToText UTCTime where
    toText t = pack $ formatTime defaultTimeLocale "%F" t

instance ToParam FromParam where
    toParam _ = DocQueryParam 
        "from" 
        ["2015-12-12","2013-01-08","..."]
        "Return a timeline starting from :from. If not set timeline will contain all past content"
        Normal

instance ToParam TillParam where
    toParam _ = DocQueryParam
        "till"
        ["2015-12-12","2013-01-08","..."]
        "Return a timeline starting till :till. If not set current time is used"
        Normal

instance ToParam GroupParam where
    toParam _ = DocQueryParam
        "group"
        ["1","4","12","..."]
        "Return a timeline for given group. If not set all available content for sender will be in timeline"
        Normal
