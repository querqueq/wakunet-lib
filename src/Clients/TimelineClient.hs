module Clients.TimelineClient where

import Servant
import Servant.Client
import System.FilePath
import APIs.TimelineAPI           (timelineAPI)

--getTimeline = client timelineAPI (BaseUrl Http "wakunet-timeline-service.herokuapp.com" 80)
getTimeline = client timelineAPI (BaseUrl Http "localhost" 8082)
