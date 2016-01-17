{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Waku.APIs.UserAPI where

import Servant
import Waku.Models
import Waku.APIs.Util

type UserAPI = "users" :> SenderId :> ( 
         UserId :> Get '[JSON] User
    :<|> "register" :> ReqBody '[JSON] Profile :> Post '[JSON] User
    )

userAPI :: Proxy UserAPI
userAPI = Proxy
