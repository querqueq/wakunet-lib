{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Waku.APIs.ExternalAccessAPI where

import Servant
import Servant.Docs
import Waku.Models
import Waku.APIs.Util
import Waku.APIs.RatingAPI
import qualified Data.UUID as U

type CaptureExternalAccessId = Capture "externalid" ExternalAccessId
type ExternalAccessAPI =
         -- Creates a new external access
         "externals" :> SenderId :> ReqBody '[JSON] ExternalAccess :> Post '[JSON] ExternalAccessId
         -- Returns an external access
    :<|> "externals" :> ReqBody '[JSON] :> Get '[JSON] ExternalAccess
         -- Returns content for external access
    :<|> "externals" :> CaptureExternalAccessId :> "content" :> Get '[JSON] Content
         -- Post content for external accessible content
    :<|> "externals" :> CaptureExternalAccessId :> "content" :> Post '[JSON] Content
         -- Revokes external access
    :<|> "externals" :> CaptureExternalAccessId :> Delete '[JSON] ()
         -- Returns all external resources for a content
    :<|> "externals" :> CaptureContentType :> CaptureContentId :> Get '[JSON] [ExternalAccess]

externalAccessAPI :: Proxy ExternalAccessAPI
externalAccessAPI = Proxy

instance ToText ExternalAccessId where
    toText = U.toText 

instance FromText ExternalAccessId where
    fromText = U.fromText

instance ToCapture CaptureExternalAccessId where
    toCapture _ = DocCapture "externalid" "(uuid) uuid v4 of external access"
    
