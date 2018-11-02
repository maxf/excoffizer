module View exposing (view)

import Json.Decode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material
import Material.Button as Button exposing (..)
import Material.Options as Options exposing (..)
import Material.Slider as Slider
import Material.Snackbar as Snackbar
import Model exposing (Model)
import Types exposing (Msg(..))


view : Model -> Html Msg
view model =
    div []
        [ Snackbar.view Mdc "my-snackbar" model.mdc [] []
        , div []
            [ Button.view Mdc
                "advanced-button"
                model.mdc
                [ Button.ripple
                , Options.onClick AdvancedSettingsButtonClicked
                ]
                [ text "Advanced" ]
            , div []
                (if model.advancedOptionsOpen then
                    viewAdvancedOptions model

                 else
                    []
                )
            ]
        ]


viewAdvancedOptions : Model -> List (Html Msg)
viewAdvancedOptions model =
    [ span [] [ "Angle: " ++ String.fromFloat model.params.theta |> text ]
    , Slider.view Mdc
        "theta-slider"
        model.mdc
        [ Slider.value model.params.theta
        , Slider.min 0
        , Slider.max 180
        , Slider.discrete
        , Slider.step 1.0
        , Slider.onInput UserChangedTheta
        ]
        []
    , span [] [ "Waviness: " ++ String.fromFloat model.params.waviness |> text ]
    , Slider.view Mdc
        "waviness-slider"
        model.mdc
        [ Slider.value model.params.waviness
        , Slider.min 0
        , Slider.max 30
        , Slider.discrete
        , Slider.step 1.0
        , Slider.onInput UserChangedWaviness
        ]
        []
    , span [] [ "Line height: " ++ String.fromFloat model.params.line_height |> text ]
    , Slider.view Mdc
        "line-height-slider"
        model.mdc
        [ Slider.value model.params.line_height
        , Slider.min 5
        , Slider.max 100
        , Slider.discrete
        , Slider.step 1.0
        , Slider.onInput UserChangedLineHeight
        ]
        []
    , span [] [ "Stretch X: " ++ String.fromFloat model.params.sx |> text ]
    , Slider.view Mdc
        "stretch-x-slider"
        model.mdc
        [ Slider.value model.params.sx
        , Slider.min 0
        , Slider.max 20
        , Slider.discrete
        , Slider.step 1
        , Slider.onInput UserChangedStretchX
        ]
        []
    , span [] [ "Stretch Y: " ++ String.fromFloat model.params.sy |> text ]
    , Slider.view Mdc
        "stretch-y-slider"
        model.mdc
        [ Slider.value model.params.sy
        , Slider.min 0
        , Slider.max 20
        , Slider.discrete
        , Slider.step 1
        , Slider.onInput UserChangedStretchY
        ]
        []
    , span [] [ "Opacity: " ++ String.fromFloat model.params.opacity |> text ]
    , Slider.view Mdc
        "opacity-slider"
        model.mdc
        [ Slider.value model.params.opacity
        , Slider.min 0
        , Slider.max 255
        , Slider.discrete
        , Slider.step 1
        , Slider.onInput UserChangedOpacity
        ]
        []
    , span [] [ "Contrast: " ++ String.fromFloat model.params.contrast |> text ]
    , Slider.view Mdc
        "contrast-slider"
        model.mdc
        [ Slider.value model.params.contrast
        , Slider.min -25
        , Slider.max 25
        , Slider.discrete
        , Slider.step 1
        , Slider.onInput UserChangedContrast
        ]
        []
    ]
