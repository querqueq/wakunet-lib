{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Waku.APIs.ChatAPI where

import Servant
import Waku.Models
import Waku.APIs.Util

type ChatAPI = "chats" :> SenderId :> Capture "chatid" Id :> Get '[JSON] ChatDescriptor

chatAPI :: Proxy ChatAPI
chatAPI = Proxy
