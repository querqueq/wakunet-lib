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
import Data.Text        (Text, pack, unpack, split)

import Waku.Models.Rating
import Waku.Models.General

type CaptureContentType = Capture "contentType" ContentType
type CaptureContentId   = Capture "contentId" ContentId
type ContentKeys = QueryParams "contents" ContentKey
type RatingAPI = "ratings" :> SenderId :>
    (    CaptureContentType :> CaptureContentId :> "like" :> Post '[JSON] ()
    :<|> CaptureContentType :> CaptureContentId :> "dislike" :> Post '[JSON] ()
    :<|> CaptureContentType :> CaptureContentId :> Delete '[JSON] ()
    :<|> CaptureContentType :> CaptureContentId :> Get '[JSON] Ratings
    :<|> ContentKeys :> Get '[JSON] [Ratings]
    )

ratingAPI :: Proxy RatingAPI
ratingAPI = Proxy

instance ToText ContentKey where
    toText (ContentKey cid ct) = pack $ show cid ++ ":" ++ ct

instance FromText ContentKey where
    fromText x = if length xs == 2
            then ContentKey <$> cid <*> Just ct
            else Nothing
        where xs = split (==':') x
              cid = readMaybe $ unpack $ head xs
              ct = unpack $ head $ tail xs
