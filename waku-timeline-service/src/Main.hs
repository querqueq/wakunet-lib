module Main where

import Network.Wai.Handler.Warp    (run)
import System.Environment          (lookupEnv)

import Config                      (defaultConfig, Config(..), Environment(..), setLogger)
import Waku.Timeline.Server

main :: IO ()
main = do
    env  <- lookupSetting "ENV" Development
    port <- lookupSetting "PORT" 8082
    let cfg = defaultConfig { getEnv = env }
        logger = setLogger env
    run port $ logger app

lookupSetting :: Read a => String -> a -> IO a
lookupSetting env def = do
    p <- lookupEnv env
    return $ case p of Nothing -> def
                       Just a  -> read a
