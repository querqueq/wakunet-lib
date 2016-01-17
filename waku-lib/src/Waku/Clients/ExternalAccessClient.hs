module Waku.Clients.ExternalAccessClient where

import Servant
import Servant.Client
import System.FilePath
import Waku.APIs.ExternalAccessAPI           (externalAccessAPI)

{--
createExternalAccess
    :<|> getContentForExternalAccess
    :<|> revokeExternalAccess
    = client externalAccessAPI (BaseUrl Http "localhost" 8084)
--}
