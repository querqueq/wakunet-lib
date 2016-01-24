{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Waku.APIs.ProfileAPI where

import Servant
import Waku.Models
import Waku.APIs.Util

type ProfileAPI = 
         "profiles" :> "partials" :> ReqBody '[JSON] ProfileRequest :> Post '[JSON] [Profile]
    :<|> "profiles" :> UserId :> ReqBody '[JSON] Profile :> Post '[JSON] Profile

profileAPI :: Proxy ProfileAPI
profileAPI = Proxy
