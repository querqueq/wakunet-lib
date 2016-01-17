module Waku.Clients.UserClient where

import Control.Monad.Trans.Either
import Servant.API.Alternative
import Servant.Client
import System.FilePath

import Waku.APIs.UserAPI           (userAPI)
import Waku.Models.General
import Waku.Models.User
import Waku.Models.Profile
import Waku.Clients.Util

getUser      :: Maybe Id -> Id -> ClientResponse User
registerUser :: Maybe Id -> Profile -> ClientResponse User
getUser
    :<|> registerUser
    = distributeClient $ client userAPI (BaseUrl Http "wakunet-user-service.herokuapp.com" 80)
