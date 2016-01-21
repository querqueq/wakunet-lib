module Waku.Clients.ChatClient where

import Servant
import Servant.Client
import System.FilePath
import Waku.APIs.ChatAPI           (chatAPI)

getChatDescriptor = client chatAPI (BaseUrl Http "wakunet-chat-service.herokuapp.com" 80)
