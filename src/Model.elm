module Model exposing (Model, initialModel, initialParams, withContrast, withLineHeight, withOpacity, withParams, withStretchX, withStretchY, withTheta, withWaviness)

import Json.Decode exposing (Decoder, Error, decodeValue, field, float, map8, succeed)
import Json.Decode.Pipeline exposing (required)
import Json.Encode exposing (Value)
import Material
import Types exposing (Msg, Params)


type alias Model =
    { advancedOptionsOpen : Bool
    , params : Params
    , mdc : Material.Model Msg
    }


initialParams : Params
initialParams =
    { theta = 30.0
    , waviness = 10.0
    , line_height = 20.0
    , sx = 10.0
    , sy = 10.0
    , tx = 0.0
    , ty = 0.0
    , opacity = 30.0
    , contrast = 0
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


paramsDecoder : Decoder Params
paramsDecoder =
    succeed Params
        |> required "waviness" float
        |> required "theta" float
        |> required "sx" float
        |> required "sy" float
        |> required "tx" float
        |> required "ty" float
        |> required "line_height" float
        |> required "opacity" float
        |> required "contrast" float


withParams : Value -> Model -> Model
withParams portParams model =
    let
        decodeResult =
            decodeValue paramsDecoder portParams
    in
    case decodeResult of
        Err _ ->
            model

        Ok params ->
            { model | params = params |> Debug.log ">>" }
