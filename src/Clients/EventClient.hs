module Clients.EventClient where

import Servant
import Servant.Client
import System.FilePath
import APIs.EventAPI           (eventAPI)

getEvent
    :<|> createEvent
    :<|> deleteEvent
    :<|> getEventsByUser
    :<|> getUpcomingEventsByUser
    :<|> addUserToEvent
    :<|> removeUserFromEvent
    :<|> addGroupToEvent
    :<|> removeGroupFromEvent
    :<|> addUserToGroup'sEvents
    = client eventAPI (BaseUrl Http "wakunet-event-service.herokuapp.com" 80)
