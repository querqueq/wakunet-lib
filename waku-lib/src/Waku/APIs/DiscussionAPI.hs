{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Waku.APIs.DiscussionAPI where

import Servant
import Waku.Models
import Waku.APIs.Util

type DiscussionAPI =
         "posts" :> SenderId :> Get '[JSON] [Discussion]
    :<|> "posts" :> SenderId :> PostId :> Get '[JSON] Discussion
    :<|> "posts" :> SenderId :> "group" :> GroupId :> Get '[JSON] [Discussion]
    :<|> "posts" :> SenderId :> ReqBody '[JSON] Discussion :> Post '[JSON] Discussion

discussionAPI :: Proxy DiscussionAPI
discussionAPI = Proxy
