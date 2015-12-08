module Clients.DiscussionClient where

import Servant
import Servant.Client
import System.FilePath
import APIs.DiscussionAPI           (discussionAPI)

getDiscussions 
    :<|> getDiscussion 
    :<|> getDiscussionForGroup
    = client discussionAPI (BaseUrl Http "wakunet-discussion-service.herokuapp.com" 80)
