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

server :: Server TimelineAPI
server = timelineServer where timelineServer senderId from till group = ioEitherToEitherT (getTimeline senderId from till group)

getTimeline :: Maybe Id -> Maybe UTCTime -> Maybe UTCTime -> Maybe Id -> IO (Either ServantErr Timeline)
getTimeline Nothing _ _ _ = return $ Left errNoSenderId
getTimeline x y Nothing z = getCurrentTime >>= \now -> getTimeline x y (Just now) z
getTimeline userId from (Just till) group = do
    let apiCall = case group of
                    (Just x) -> getDiscussionsForGroup userId x
                    Nothing -> getDiscussions userId
    content <- runEitherT apiCall >>= return . (fmap (map ContentDiscussion))
    case content of
        Right x -> do
            return $ Right $ timeline from till x
        Left x -> return $ Left $ errForward x
