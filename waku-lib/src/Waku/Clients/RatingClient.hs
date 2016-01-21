module Waku.Clients.RatingClient where

import Control.Monad.Trans.Either
import Servant.API.Alternative
import Servant.Client
import System.FilePath

import Waku.APIs.RatingAPI           (ratingAPI)
import Waku.Models.Rating
import Waku.Models.General
import Waku.Clients.Util

type SenderId = Id

like        :: Maybe SenderId -> ContentType -> ContentId -> ClientResponse ()
dislike     :: Maybe SenderId -> ContentType -> ContentId -> ClientResponse ()
unlike      :: Maybe SenderId -> ContentType -> ContentId -> ClientResponse ()
getRatings  :: Maybe SenderId -> ContentType -> ContentId -> ClientResponse Ratings
bulkRatings :: Maybe SenderId -> [ContentKey]             -> ClientResponse [Ratings]
like
    :<|> dislike
    :<|> unlike
    :<|> getRatings
    :<|> bulkRatings
    = distributeClient $ client ratingAPI (BaseUrl Http "wakunet-rating-service.herokuapp.com" 80)
