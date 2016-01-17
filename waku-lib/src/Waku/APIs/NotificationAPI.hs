{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Waku.APIs.NotificationAPI where

import Servant
import Waku.Models
import Waku.APIs.Util

type NotificationAPI = "notifications" :> "user" :> UserId :> Get '[JSON] [Notification]

notificationAPI :: Proxy NotificationAPI
notificationAPI = Proxy
