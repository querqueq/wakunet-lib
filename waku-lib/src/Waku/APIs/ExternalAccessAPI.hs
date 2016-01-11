{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Waku.APIs.ExternalAccessAPI where

import Servant
import Waku.Models
import Waku.APIs.Util

type CaptureExternalAccessId = Capture "externalid" ExternalAccessId
type ExternalAccessAPI =
         -- Creates a new external access
         "externals" :> SenderId :> ReqBody '[JSON] ExternalAccess :> Post '[JSON] ExternalAccessId
         -- Retrieves content for external access
    :<|> "externals" :> CaptureExternalAccessId :> Get '[JSON] Content
         -- Revokes external access
    :<|> "externals" :> CaptureExternalAccessId :> Delete '[JSON] ()

externalAccessAPI :: Proxy ExternalAccessAPI
externalAccessAPI = Proxy
