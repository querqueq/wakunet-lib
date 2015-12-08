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

type SenderId = Header "UserId" Integer
type GroupId  = Capture "groupid" Integer
type TimelineAPI = "timeline" :> SenderId :> 
    (    Get '[JSON] Timeline
    :<|> "group" :> GroupId :> Get '[JSON] Timeline
    )

timelineAPI :: Proxy TimelineAPI
timelineAPI = Proxy

instance ToCapture GroupId where
    toCapture _ = DocCapture "groupid" "(integer) id of group; content of timeline will be limited to content of this group"
