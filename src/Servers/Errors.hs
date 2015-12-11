{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Servers.Errors where

import Servant
import Servant.Common.Req
import Network.HTTP.Types.Status    (Status(..))

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
err408 = errDefault 
    { errHTTPCode = 408
    , errReasonPhrase = "Remote host timed out"
    , errBody = "Remote host timed out"
    }        
errNoSenderId = err409 { errReasonPhrase = "No sender id", errBody = "No sender id" }
