module Waku.Servers.Util where

import Control.Monad.Trans.Either
import Control.Monad.IO.Class       (liftIO,MonadIO)
import Servant

maybeToEitherT :: MonadIO m => e -> Maybe t -> EitherT e m t
maybeToEitherT err x =
    case x of
        Just v -> return v
        Nothing -> left err

ioMaybeToEitherT :: MonadIO m => e -> IO (Maybe t) -> EitherT e m t
ioMaybeToEitherT err x = do
    m <- liftIO x
    maybeToEitherT err m

ioEitherToEitherT :: MonadIO m => IO (Either ServantErr a) -> EitherT ServantErr m a
ioEitherToEitherT x = liftIO x >>= hoistEither

require :: [(Bool,ServantErr)] -> EitherT ServantErr IO a -> EitherT ServantErr IO a
require checks f = case foldl (\errs (x,err) -> if x then err:errs else errs) [] checks of
    [] -> f
    x:_ -> left x
