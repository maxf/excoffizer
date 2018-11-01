port module Ports exposing (..)

import Json.Encode
import Types exposing (Params)

-- outgoing

port render : Params -> Cmd msg


-- incoming

port renderDone : (Bool -> msg) -> Sub msg
port newImageLoaded : (Bool -> msg) -> Sub msg
port previewSelected : (Json.Encode.Value -> msg) -> Sub msg
