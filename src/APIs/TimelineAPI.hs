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

type TimelineAPI = "timeline" :> SenderId :> (
         Get '[JSON] Timeline
    :<|> "group" :> GroupId :> Get '[JSON] Timeline
    )

timelineAPI :: Proxy TimelineAPI
timelineAPI = Proxy
