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
import Control.Monad                (mapM,mapM_)
import Control.Monad.IO.Class       (MonadIO)
import Control.Monad.Reader         (ReaderT, runReaderT, lift, MonadReader
                                    , liftIO)
import Control.Monad.Trans.Either   (EitherT, left, right, runEitherT, hoistEither)
import Network.Wai                  (Application)
import Data.Time                    (getCurrentTime, fromGregorian, UTCTime(..))

import Config    (Config(..))
import Servant
import Servant.Common.Req           (ServantError(..))

import Models.Timeline
import Models.General               (Id)
import APIs.TimelineAPI
import Clients.DiscussionClient
import Servers.Util
import Servers.Errors

app :: Application
app = serve timelineAPI server

server = timelineServer
    where timelineServer sId = 
                 ioEitherToEitherT (getTimeline sId)
            :<|> getTimelineForGroup sId

getTimeline :: Maybe Id -> IO (Either ServantErr Timeline)
getTimeline Nothing = return $ Left errNoSenderId
getTimeline userId = do
    now <- getCurrentTime
    content <- runEitherT (getDiscussions userId) >>= return . (fmap (map ContentDiscussion))
    case content of
        Right x -> do
            return $ Right $ timeline now x
        Left x -> return $ Left $ errForward x
getTimelineForGroup userId groupId = return sampleTimeline2
