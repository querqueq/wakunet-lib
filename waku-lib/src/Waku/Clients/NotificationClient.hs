module Waku.Clients.NotificationClient where

import Servant
import Servant.Client
import System.FilePath
import Waku.APIs.NotificationAPI           (notificationAPI)

getSubscriptionsByUserId = client notificationAPI (BaseUrl Http "wakunet-notification-service.herokuapp.com" 80)
