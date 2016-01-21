module Waku.Clients.MailClient where

import Servant
import Servant.Client
import System.FilePath
import Waku.APIs.MailAPI           (mailAPI)

getTemplates
    :<|> getTemplate
    :<|> sendMail
    = client mailAPI (BaseUrl Http "wakunet-mail-service.herokuapp.com" 80)
