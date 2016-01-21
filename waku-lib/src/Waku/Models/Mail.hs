{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Waku.Models.Mail where

import GHC.Generics
import Data.Aeson
import Data.Aeson.Casing
import Data.Maybe           (fromMaybe)
import Servant.Docs         (ToSample(..))
import Data.Text            (Text)
import qualified Data.Map as M
import Waku.Models.General

type Email = String
type TemplateName = String
data Mail = Mail
    { mailTo                :: [Email]
    , mailSubject           :: String
    , mailTemplate          :: TemplateName
    , mailTransactionalData :: M.Map Text Text
    } deriving (Eq, Generic, Show)

instance ToJSON Mail where
    toJSON = toJSONPrefixed

instance FromJSON Mail where
    parseJSON = parseJSONPrefixed

instance ToSample Mail Mail where
    toSample _ = Just $ sampleMail 1

defaultMail = Mail
    { mailTo = ["john@example.org", "jane@example.org"]
    , mailSubject = "Invitation to event"
    , mailTemplate = "InvitationFormal"
    , mailTransactionalData = M.fromList [("salutation","Dear Family Doe,")]
    }

sampleMail 1 = defaultMail
