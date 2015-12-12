{-# LANGUAGE DataKinds,TypeSynonymInstances,FlexibleInstances #-}
module APIs.Util where

import Servant
import Servant.Docs
import Models.General   (Id)

type SenderId = Header "UserId" Id
type GroupId  = Capture "groupid" Id
type PostId = Capture "postid" Id
type UserId = Capture "userid" Id

instance ToCapture GroupId where
    toCapture _ = DocCapture "groupid" "(integer) id of group; content of timeline will be limited to content of this group"
