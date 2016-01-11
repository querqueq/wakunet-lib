{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Waku.Clients.Util where

import Control.Monad.IO.Class
import Control.Monad.Trans.Either   (runEitherT, EitherT)
import Data.Aeson
import Data.Proxy
import GHC.Generics
import Network.Wai.Handler.Warp (run)
import Servant.API.Alternative
import Servant.JQuery
import Servant.Client
import System.FilePath

type ClientResponse a = EitherT ServantError IO a

call :: (Show a) => EitherT ServantError IO a -> IO (Either ServantError ())
call f = runEitherT $ do
            result <- f
            liftIO . putStrLn $ show result

-- distributive client from https://github.com/GetShopTV/smsaero/blob/master/src/SMSAero/Utils.hs

class DistributiveClient client client' where
  distributeClient :: client -> client'

instance DistributiveClient (a -> b) (a -> b) where
    distributeClient = id

instance (DistributiveClient (a -> b) b', DistributiveClient (a -> c) c') => DistributiveClient (a -> (b :<|> c)) (b' :<|> c') where
    distributeClient client = distributeClient (fmap left client) :<|> distributeClient (fmap right client)
      where left  (l :<|> _) = l
            right (_ :<|> r) = r
