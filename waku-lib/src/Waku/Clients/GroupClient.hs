module Waku.Clients.GroupClient where

import Control.Monad.Trans.Either
import Servant.API.Alternative
import Servant.Client
import System.FilePath

import Waku.APIs.GroupAPI           (groupAPI)
import Waku.Clients.Util

getGroupsByUser = client groupAPI (BaseUrl Http "wakunet-user-service.herokuapp.com" 80)
