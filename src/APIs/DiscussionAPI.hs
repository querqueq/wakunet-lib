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

type DiscussionAPI = 
         "posts" :> Get '[JSON] [Discussion]
    :<|> "posts" :> Capture "postid" Int :> Get '[JSON] Discussion
    :<|> "posts" :> "group" :> Capture "groupid" Int :> Get '[JSON] [Discussion]
{--
"v1" :> (
         "users" :> Capture "user-id" Integer :> Get '[JSON] User
    :<|> "users" :> ReqBody '[JSON] User :> Post '[JSON] Integer
    :<|> "posts" :> Get '[JSON] [Entity Content]
    :<|> "posts" :> Capture "post-id" Integer :> Get '[JSON] Content
--    :<|> "post" :> Capture "post-id" Integer :> "full" :> Get '[JSON] PostWithComments
    :<|> "posts" :> Capture "post-id" Integer :> "comments" :> Get '[JSON] [Entity Content]
    :<|> "posts" :> ReqBody '[JSON] Content :> Post '[JSON] Integer
    :<|> "groups" :> Get '[JSON] [Entity Group]
    :<|> "groups" :> ReqBody '[JSON] Group :> Post '[JSON] Integer
    :<|> "groups" :> Capture "group-id" Integer :> Get '[JSON] Group
    :<|> "groups" :> Capture "group-id" Integer :> "members" :> Get '[JSON] [Entity User]
    :<|> "groups" :> Capture "group-id" Integer :> "join" :> Capture "user-id" Integer :> Put '[JSON] Integer
    )--}

discussionAPI :: Proxy DiscussionAPI
discussionAPI = Proxy
