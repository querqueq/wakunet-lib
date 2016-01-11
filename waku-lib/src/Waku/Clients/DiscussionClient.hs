module Waku.Clients.DiscussionClient where

import Servant
import Servant.Client
import System.FilePath
import Waku.APIs.DiscussionAPI           (discussionAPI)

getDiscussions
    :<|> getDiscussion
    :<|> getDiscussionsForGroup
    = client discussionAPI (BaseUrl Http "wakunet-discussion-service.herokuapp.com" 80)
