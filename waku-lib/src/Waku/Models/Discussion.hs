{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE DeriveGeneric          #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE TemplateHaskell        #-}
{-# LANGUAGE TypeSynonymInstances   #-}
{-# LANGUAGE RecordWildCards        #-}
{-# LANGUAGE OverloadedStrings      #-}
module Waku.Models.Discussion where

import Waku.Models.General
import Data.Time        (UTCTime(..),fromGregorian)
import Data.Maybe       (fromMaybe)
import Servant.Docs     (ToSample(..))

data Discussion = Discussion
    { discussionId            :: Id
    , discussionCreatorId     :: Id
    , discussionGroupId       :: Maybe Id
    , discussionParentPostId  :: Maybe Id
    , discussionSubPostCount  :: Int
    , discussionText          :: String
    , discussionCreated       :: UTCTime 
    , discussionUpdated       :: Maybe UTCTime
    , discussionSubPosts      :: [Discussion]
    , discussionType          :: Maybe String
    --, discussionSuperType     :: String
    , discussionContentKey    :: ContentKey
    } deriving (Eq, Generic)

instance ToJSON Discussion where 
    toJSON = toJSONPrefixed

instance FromJSON Discussion where 
    parseJSON = parseJSONPrefixed

instance HasHappened Discussion where
    happened (Discussion {..}) = discussionCreated

instance HasId Discussion where
    identifier (Discussion {..}) = discussionId

instance HasCreator Discussion where
    creator (Discussion {..}) = discussionCreatorId

instance HasType Discussion where
    getType (Discussion {discussionType = Just x}) = x
    getType (Discussion {discussionType = Nothing}) = ""
    getSuperType (Discussion {..}) = contentType discussionContentKey

instance Show Discussion where
    show d = showIndented 0 d
        where showIndented n (Discussion {..}) = "\n" ++ unlines ( 
                zipWith (++) (repeat $ indent n) $
                [ "Post " ++ show discussionId 
                  ++ " by User " ++ show discussionCreatorId 
                  ++ fromMaybe "" (discussionGroupId >>= return . \x -> " in Group " ++ show x)
                , show discussionCreated
                , discussionText
                , replicate 30 '-'
                ]
                )
                ++ (foldl (++) "" $ map (showIndented (n+1)) discussionSubPosts)
              indent n = replicate n '\t'

instance ToSample Discussion Discussion where
    toSample _ = Just sampleDiscussionParent

instance ToSample [Discussion] [Discussion] where
    toSample _ = Just [sampleDiscussionParent]

defaultDiscussion = Discussion
    { discussionId = 0
    , discussionCreatorId = 0
    , discussionGroupId = Nothing
    , discussionParentPostId = Nothing
    , discussionSubPostCount = 0
    , discussionText = ""
    , discussionCreated = UTCTime (fromGregorian 2015 12 08) (fromIntegral 60*60*19)
    , discussionUpdated = Nothing
    , discussionSubPosts = []
    , discussionType = Just "fullPost"
    , discussionContentKey = ContentKey 0 "post"
    }


sampleDiscussionParent = defaultDiscussion
    { discussionId = 1
    , discussionCreatorId = 1
    , discussionGroupId = Just 1
    , discussionParentPostId = Nothing
    , discussionSubPostCount = 2
    , discussionText = "Hi there!"
    , discussionCreated = UTCTime (fromGregorian 2015 12 08) (fromIntegral 60*60*19)
    , discussionUpdated = Nothing
    , discussionSubPosts = [sampleDiscussionComment1, sampleDiscussionComment2]
    }

sampleDiscussionComment1 = defaultDiscussion
    { discussionId = 2
    , discussionCreatorId = 2
    , discussionGroupId = Just 1
    , discussionParentPostId = Just 1
    , discussionSubPostCount = 0
    , discussionText = "Welcome to this group."
    , discussionCreated = UTCTime (fromGregorian 2015 12 08) (fromIntegral 60*60*19+120)
    , discussionUpdated = Nothing
    , discussionSubPosts = []
    }

sampleDiscussionComment2 = defaultDiscussion
    { discussionId = 3
    , discussionCreatorId = 1
    , discussionGroupId = Just 1
    , discussionParentPostId = Just 1
    , discussionSubPostCount = 0
    , discussionText = "Thanks!"
    , discussionCreated = UTCTime (fromGregorian 2015 12 08) (fromIntegral 60*60*19+232)
    , discussionUpdated = Nothing
    , discussionSubPosts = []
    }
