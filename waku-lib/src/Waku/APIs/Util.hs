{-# LANGUAGE DataKinds, TypeSynonymInstances, FlexibleInstances, MultiParamTypeClasses #-}

module Waku.APIs.Util where

import Servant
import Servant.Docs
import Waku.Models.General
import Data.Text            (Text, pack, unpack, split)
import Text.Read            (readMaybe)

type SenderId = Header "UserId" Id
type GroupId  = Capture "groupid" Id
type PostId = Capture "postid" Id
type UserId = Capture "userid" Id
type CaptureContentType = Capture "contentType" ContentType
type CaptureContentId   = Capture "contentId" ContentId
type ContentKeys = QueryParams "contents" ContentKey
type NullPost = Post '[JSON] ()

instance ToCapture GroupId where
    toCapture _ = DocCapture "groupid" "(integer) id of group; content of timeline will be limited to content of this group"

instance ToText ContentKey where
    toText (ContentKey cid ct) = pack $ show cid ++ ":" ++ ct

instance FromText ContentKey where
    fromText x = if length xs == 2
            then ContentKey <$> cid <*> Just ct
            else Nothing
        where xs = split (==':') x
              cid = readMaybe $ unpack $ head xs
              ct = unpack $ head $ tail xs

instance ToParam ContentKeys where
    toParam _ = DocQueryParam
                    "contents"
                    (map (unpack . toText) sampleContentKeys)
                    "List of content keys, e.g. ratings?contents[]=1:post&contents[]=3:event&contents[]=5:post"
                    List
                where sampleContentKeys =
                        [ContentKey 1 "post"
                        ,ContentKey 3 "event"
                        ,ContentKey 5 "post"
                        ]

instance ToCapture CaptureContentType where
    toCapture _ = DocCapture "contentType" "(string) super type of rated content"

instance ToCapture CaptureContentId where
    toCapture _ = DocCapture "contentId" "(long) id if rated content"

instance ToSample () () where
    toSample _ = Nothing
