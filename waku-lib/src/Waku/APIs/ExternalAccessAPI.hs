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
import qualified Data.ByteString.Lazy.Char8 as BL

type CaptureExternalAccessId = Capture "externalid" ExternalAccessId
type ExternalAccessAPI =
         -- Creates a new external access
         "externals" :> SenderId :> ReqBody '[JSON] ExternalAccessRequest :> Post '[JSON] AString
         -- Update a external access
    :<|> "externals" :> SenderId :> CaptureExternalAccessId :> ReqBody '[JSON] ExternalAccessRequest :> Post '[JSON] ExternalAccess
         -- Returns an external access
    :<|> "externals" :> CaptureExternalAccessId :> Get '[JSON] ExternalAccess
         -- Returns content for external access
    :<|> "externals" :> CaptureExternalAccessId :> "content" :> Get '[JSON] ExternalContent
         -- Post content for external accessible content
    :<|> "externals" :> CaptureExternalAccessId :> "content" :> ReqBody '[JSON] Content :> Post '[JSON] ()
         -- Sets an alias for the external user 
    :<|> "externals" :> CaptureExternalAccessId :> "alias" :> ReqBody '[JSON] AString  :> Post '[JSON] ()
         -- Revokes external access
    :<|> "externals" :> SenderId :> CaptureExternalAccessId :> Delete '[JSON] ()
         -- Returns all external accesses for a content
    :<|> "externals" :> SenderId :> CaptureContentType :> CaptureContentId :> Get '[JSON] [ExternalAccess]
         -- Notifies the external user of the external access 
    :<|> "externals" :> SenderId :> CaptureExternalAccessId :> "notify" :> ReqBody '[JSON] Url :> Post '[JSON] ()

externalAccessAPI :: Proxy ExternalAccessAPI
externalAccessAPI = Proxy

instance ToCapture (Capture "name" String) where
    toCapture _ = DocCapture "name" "(string) alias for external user"

instance ToText ExternalAccessId where
    toText = U.toText 

instance FromText ExternalAccessId where
    fromText = U.fromText

instance ToCapture CaptureExternalAccessId where
    toCapture _ = DocCapture "externalid" "(uuid) uuid v4 of external access"

instance MimeRender PlainText ExternalAccessId where
    mimeRender Proxy x = BL.pack $ U.toString x

externalAccessDocs :: API
externalAccessDocs = docs externalAccessAPI
updateExternalAccessDocs = writeFile "external-access-service.md" $ markdown externalAccessDocs
