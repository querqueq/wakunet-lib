{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module APIs.EventAPI where

import Servant
import Models.General
import Models.Event
import APIs.Util

type EventId = Capture "eventId" Id
type EventAPI = 
         "events" :> EventId :> Get '[JSON] Event
    :<|> "events" :> ReqBody '[JSON] Event :> Post '[JSON] Event
    :<|> "events" :> EventId :> "delete" :> SenderId :> Post '[JSON] ()
    :<|> "events" :> "user" :> UserId :> Get '[JSON] [Event]
    :<|> "events" :> "user" :> UserId :> "next" :> Get '[JSON] [Event]
    :<|> "events" :> EventId :> "add" :> UserId :> Post '[JSON] ()
    :<|> "events" :> EventId :> "remove" :> UserId :> Post '[JSON] ()
    :<|> "events" :> EventId :> "addGroup" :> GroupId :> Post '[JSON] ()
    :<|> "events" :> EventId :> "removeGroup" :> GroupId :> Post '[JSON] ()
    :<|> "events" :> "user" :> UserId :> "addGroup" :> GroupId :> Post '[JSON] ()

eventAPI :: Proxy EventAPI
eventAPI = Proxy
