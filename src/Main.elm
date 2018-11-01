port module Main exposing (init, main, subscriptions)

import Browser
import Json.Encode
import Material
import Model exposing (Model, initialModel)
import Ports exposing (newImageLoaded, render, renderDone, previewSelected)
import Types exposing (Msg(..))
import Update exposing (update)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel
    , Cmd.batch [ Material.init Mdc ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Mdc model
        , renderDone RenderFinished
        , newImageLoaded NewImageLoaded
        , previewSelected UserClickedPreview
        ]
