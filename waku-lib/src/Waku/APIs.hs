module Waku.APIs
    ( module Waku.APIs.DiscussionAPI
    , module Waku.APIs.EventAPI
    , module Waku.APIs.TimelineAPI
    , module Waku.APIs.RatingAPI
    , module Waku.APIs.Util
    , module Waku.APIs.NotificationAPI
    , module Waku.APIs.StickyAPI
    , module Waku.APIs.MailAPI
    ) where

import Waku.APIs.DiscussionAPI
import Waku.APIs.EventAPI
import Waku.APIs.TimelineAPI
import Waku.APIs.RatingAPI
import Waku.APIs.NotificationAPI
import Waku.APIs.StickyAPI
import Waku.APIs.MailAPI
import Waku.APIs.Util
import Servant.Docs
import Servant

updateDocs name api = writeFile name $ markdown $ docs api
