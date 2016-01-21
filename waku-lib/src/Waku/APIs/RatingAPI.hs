{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
module Waku.APIs.RatingAPI where

import Text.Read        (readMaybe)
import Servant
import Servant.Docs
import Waku.APIs.Util
import Waku.Models.Rating
import Waku.Models.General

type RatingAPI = "ratings" :> SenderId :>
    (    CaptureContentType :> CaptureContentId :> "like"    :> NullPost
    :<|> CaptureContentType :> CaptureContentId :> "dislike" :> NullPost
    :<|> CaptureContentType :> CaptureContentId :> Delete '[JSON] ()
    :<|> CaptureContentType :> CaptureContentId :> Get '[JSON] Ratings
    :<|> ContentKeys :> Get '[JSON] [Ratings]
    )

ratingAPI :: Proxy RatingAPI
ratingAPI = Proxy
