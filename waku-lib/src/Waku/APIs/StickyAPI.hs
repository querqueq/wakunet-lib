{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
module Waku.APIs.StickyAPI where

import Text.Read        (readMaybe)
import Servant
import Servant.Docs
import Waku.APIs.Util
import Waku.Models.General

type StickyAPI = "stickies" :> SenderId :>
    (    CaptureContentType :> CaptureContentId :> NullPost
    :<|> CaptureContentType :> CaptureContentId :> Delete '[JSON] ()
    :<|> ContentKeys :> Get '[JSON] [ContentKey]
    )

stickyAPI :: Proxy StickyAPI
stickyAPI = Proxy
