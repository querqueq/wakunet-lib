{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Waku.APIs.MailAPI where

import Servant.Docs
import Servant
import Waku.Models.Mail
import Data.Text                        (Text)

type SmtpStatusCode = Int
type MailAPI =
        -- | Retrieves all templates names
        "templates" :> Get '[JSON] [TemplateName]
        -- | Returns template body
   :<|> "templates" :> Capture "name" String :> Get '[PlainText] Text
        -- | Sends email
   :<|> "mails" :> ReqBody '[JSON] Mail :> Post '[JSON] ()

mailAPI :: Proxy MailAPI
mailAPI = Proxy

instance ToCapture (Capture "name" String) where
    toCapture _ = DocCapture "name" "name of template"

instance ToSample Text Text where
    toSample _ = Just $ sampleTemplate

instance ToSample [TemplateName] [TemplateName] where
    toSample _ = Just $ ["invitation","reminder","notification"]

instance ToSample SmtpStatusCode SmtpStatusCode where
    toSamples _ = 
        [ ("Success", 200)
        , ("Service not available", 421)
        ]

sampleTemplate = "Hello $receiver,\n\nLorem ipsum dolor sit amet, consetetur sadipscing elitr\n\nRegards,\n$sender"

