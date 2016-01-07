module Clients.TimelineClient where

import Servant
import Servant.Client
import System.FilePath
import APIs.TimelineAPI           (timelineAPI)

-- TODO FromJSON for Timeline
-- getTimeline = client timelineAPI (BaseUrl Http "wakunet-timeline-service.herokuapp.com" 80)
