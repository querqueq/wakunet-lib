module Waku.Clients.ProfileClient where

import Servant
import Servant.Client
import System.FilePath
import Waku.APIs.ProfileAPI           (profileAPI)

getPartialProfiles
    :<|> updateProfile
    = client profileAPI (BaseUrl Http "wakunet-profile-service.herokuapp.com" 80)
