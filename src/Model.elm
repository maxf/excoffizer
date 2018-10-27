module Model exposing (..)

import Material
import Types exposing (Msg, Params)


type alias Model =
    { advancedOptionsOpen : Bool
    , params : Params
    , mdc : Material.Model Msg
    }


initialParams : Params
initialParams =
    { waviness = 10.0
    , theta = 30.0
    , sx = 10.0
    , sy = 10.0
    , tx = 0.0
    , ty = 0.0
    , line_height = 5.0
    , opacity = 30.0
    , contrast = 0
    , output_height = 400
    }


initialModel : Model
initialModel =
    { advancedOptionsOpen = True
    , params = initialParams
    , mdc = Material.defaultModel
    }


withTheta : Float -> Model -> Model
withTheta newTheta model =
    let
        params =
            model.params
    in
        { model | params = { params | theta = newTheta } }

withWaviness : Float -> Model -> Model
withWaviness newWaviness model =
    let
        params =
            model.params
    in
        { model | params = { params | waviness = newWaviness } }

withLineHeight : Float -> Model -> Model
withLineHeight newHeight model =
    let
        params =
            model.params
    in
        { model | params = { params | line_height = newHeight } }

withStretchX : Float -> Model -> Model
withStretchX newStretchX model =
    let
        params =
            model.params
    in
        { model | params = { params | sx = newStretchX } }

withStretchY : Float -> Model -> Model
withStretchY newStretchY model =
    let
        params =
            model.params
    in
        { model | params = { params | sy = newStretchY } }

withOpacity : Float -> Model -> Model
withOpacity newOpacity model =
    let
        params =
            model.params
    in
        { model | params = { params | opacity = newOpacity } }

withContrast : Float -> Model -> Model
withContrast newContrast model =
    let
        params =
            model.params
    in
        { model | params = { params | contrast = newContrast } }
