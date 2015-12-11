{-# LANGUAGE DataKinds,TypeSynonymInstances,FlexibleInstances #-}
module APIs.Util where

import Servant
import Servant.Docs

type SenderId = Header "UserId" Integer
type GroupId  = Capture "groupid" Integer

instance ToCapture GroupId where
    toCapture _ = DocCapture "groupid" "(integer) id of group; content of timeline will be limited to content of this group"
