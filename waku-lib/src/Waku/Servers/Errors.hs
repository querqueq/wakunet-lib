{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Waku.Servers.Errors where

import Servant
import Servant.Common.Req
import Network.HTTP.Types.Status    (Status(..))
import Data.ByteString.Lazy.Char8   (pack)

errDefault = err500 { errReasonPhrase = "Default error" }
errForward (FailureResponse {..}) = errDefault
    { errHTTPCode = statusCode responseStatus
    , errReasonPhrase = "Remote returned error"
    , errBody = responseBody
    }
errForward (DecodeFailure {..}) = err500 { errReasonPhrase = "Decoding error: " ++ decodeError }
errForward (UnsupportedContentType {..}) = err500 { errReasonPhrase = "Unsupported ContentType" }
errForward (ConnectionError {..}) = err408
errForward _ = err500
err408 = newErr 408 "Remote host timed out"
errNoSenderId = err409 { errReasonPhrase = "No sender id", errBody = "No sender id" }
newErr code phrase = errDefault 
    { errHTTPCode = code
    , errReasonPhrase = phrase
    , errBody = pack phrase
    }
