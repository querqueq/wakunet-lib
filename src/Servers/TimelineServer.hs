{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies, FlexibleContexts #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module Servers.TimelineServer where

import Control.Monad.IO.Class       (MonadIO)
import Control.Monad.Reader         (ReaderT, runReaderT, lift, MonadReader
                                    , liftIO)
import Control.Monad.Trans.Either   (EitherT, left)
import Network.Wai                  (Application)
import Data.Time                    (getCurrentTime, fromGregorian, UTCTime(..))
--import Data.Text.Lazy          (pack)
--import Data.Text.Lazy.Encoding (encodeUtf8)
--import Data.ByteString.Lazy (ByteString)

import Config    (Config(..))
import Servant

import Models.Timeline
import APIs.TimelineAPI

type AppM = ReaderT Config (EitherT ServantErr IO)

app :: Config -> Application
app cfg = serve timelineAPI (readerServer cfg)

readerServer :: Config -> Server TimelineAPI
readerServer cfg = enter (readerToEither cfg) server

readerToEither :: Config -> AppM :~> EitherT ServantErr IO
readerToEither cfg = Nat $ \x -> runReaderT x cfg

server :: ServerT TimelineAPI AppM
server = getTimeline
    :<|> getTimelineForGroup

getTimeline userId = return sampleTimeline1
getTimelineForGroup userId groupId = return sampleTimeline2
