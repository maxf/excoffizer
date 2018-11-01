module Types exposing (Msg(..), Params)

import Json.Encode
import Material


type Msg
    = AdvancedSettingsButtonClicked
    | RenderButtonClicked
    | RenderFinished Bool
    | Mdc (Material.Msg Msg)
    | UserChangedTheta Float
    | UserChangedWaviness Float
    | UserChangedLineHeight Float
    | UserChangedStretchX Float
    | UserChangedStretchY Float
    | UserChangedOpacity Float
    | UserChangedContrast Float
    | NewImageLoaded Bool
    | UserClickedPreview Json.Encode.Value


type alias Params =
    { waviness : Float
    , theta : Float
    , sx : Float
    , sy : Float
    , tx : Float
    , ty : Float
    , line_height : Float
    , opacity : Float
    , contrast: Float
    }
