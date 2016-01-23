{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Waku.APIs.GroupAPI where

import Servant
import Waku.Models
import Waku.APIs.Util

type GroupAPI = 
    "groups" :> SenderId :> "user" :> UserId :> Get '[JSON] [Group]

groupAPI :: Proxy GroupAPI
groupAPI = Proxy
