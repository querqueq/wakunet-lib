{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Servers.TimelineServer where

import Control.Applicative          ((<$>))
import Control.Monad                (mapM,mapM_,(>=>))
import Control.Monad.IO.Class       (MonadIO)
import Control.Monad.Reader         (ReaderT, runReaderT, lift, MonadReader
                                    , liftIO)
import Control.Monad.Trans.Either   (EitherT, left, right, runEitherT, hoistEither)
import Network.Wai                  (Application)
import Data.Time                    (getCurrentTime, fromGregorian, UTCTime(..))
import Data.Either.Combinators      (rightToMaybe)
import Data.Maybe                   (fromJust, maybe)

import Config    (Config(..))
import Servant
import Servant.Common.Req           (ServantError(..))

import Models.Timeline
import Models.General               
import Models.Rating
import APIs.TimelineAPI
import Clients hiding (getTimeline)
import Servers.Util
import Servers.Errors

app :: Application
app = serve timelineAPI server

server :: Server TimelineAPI
server = timelineServer where timelineServer senderId from till group = ioEitherToEitherT (getTimeline senderId from till group)

-- | Returns an error or a timeline for an user
getTimeline :: Maybe Id -> Maybe UTCTime -> Maybe UTCTime -> Maybe Id -> IO (Either ServantErr Timeline)
-- | Error: no user id
getTimeline Nothing _ _ _ = return $ Left errNoSenderId
-- | No till date given. Calls getTimeline with current date as till date
getTimeline x y Nothing z = getCurrentTime >>= \now -> getTimeline x y (Just now) z
getTimeline userId from (Just till) group = do
    discs  <- runEitherT $ map ContentDiscussion <$> maybe (getDiscussions userId) (getDiscussionsForGroup userId) group
    events <- runEitherT $ map ContentEvent <$> getEventsByUser (fromJust userId)
    case (++) <$> discs <*> events of
        Right x -> do
            ratings <- runEitherT $ bulkRatings userId $ contentKeys x
            return $ Right $ timeline from till x $ rightToList ratings
        Left x -> return $ Left $ errForward x

rightToList :: Either a [b] -> [b]
rightToList (Right xs) = xs
rightToList (Left _) = []

contentKeys :: [Content] -> [ContentKey]
contentKeys = map (\c -> ContentKey (identifier c) (getSuperType c))
