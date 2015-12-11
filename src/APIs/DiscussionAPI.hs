{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module APIs.DiscussionAPI where

import Servant
import Models 
import APIs.Util

type DiscussionAPI = 
         "posts" :> SenderId :> Get '[JSON] [Discussion]
    :<|> "posts" :> SenderId :> Capture "postid" Int :> Get '[JSON] Discussion
    :<|> "posts" :> SenderId :> "group" :> Capture "groupid" Int :> Get '[JSON] [Discussion]
discussionAPI :: Proxy DiscussionAPI
discussionAPI = Proxy
