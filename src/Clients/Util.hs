{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Clients.Util where

import Control.Monad.IO.Class
import Control.Monad.Trans.Either   (runEitherT, EitherT)
import Data.Aeson
import Data.Proxy
import GHC.Generics
import Network.Wai.Handler.Warp (run)
import Servant
import Servant.JQuery
import Servant.Client
import System.FilePath

call :: (Show a) => EitherT ServantError IO a -> IO (Either ServantError ())
call f = runEitherT $ do
            result <- f
            liftIO . putStrLn $ show result
