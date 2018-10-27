module Internal.Fab.Implementation
    exposing
        ( Property
        , exited
        , mini
        , react
        , ripple
        , view
        )

import Html exposing (Html, text)
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Fab.Model exposing (Model, Msg(..), defaultModel)
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Internal.Ripple.Implementation as Ripple


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RippleMsg msg_ ->
            let
                ( rippleState, rippleCmd ) =
                    Ripple.update msg_ model.ripple
            in
            ( { model | ripple = rippleState }, Cmd.map RippleMsg rippleCmd )

        NoOp ->
            ( model, Cmd.none )


type alias Config =
    { ripple : Bool
    }


defaultConfig : Config
defaultConfig =
    { ripple = False
    }


type alias Property m =
    Options.Property Config m


mini : Property m
mini =
    cs "mdc-fab--mini"


exited : Property m
exited =
    cs "mdc-fab--exited"


ripple : Property m
ripple =
    Options.option (\config -> { config | ripple = True })


fab : Index -> (Msg -> m) -> Model -> List (Property m) -> String -> Html m
fab domId lift model options icon =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        rippleInterface =
            Ripple.view False domId (lift << RippleMsg) model.ripple []
    in
    Options.apply summary
        Html.button
        [ cs "mdc-fab"
        , cs "material-icons"
        , when config.ripple
            << Options.many
          <|
            [ rippleInterface.interactionHandler
            , rippleInterface.properties
            ]
        ]
        []
        (List.concat
            [ [ styled Html.span
                    [ cs "mdc-fab__icon"
                    ]
                    [ text icon
                    ]
              ]
            , if config.ripple then
                [ rippleInterface.style ]
              else
                []
            ]
        )


type alias Store s =
    { s | fab : Indexed Model }


getSet =
    Component.indexed .fab (\x y -> { y | fab = x }) defaultModel


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> String
    -> Html m
view =
  \lift domId ->
    Component.render getSet.get (fab domId) Internal.Msg.FabMsg lift domId


react :
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.FabMsg (Component.generalise update)
