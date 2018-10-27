module Update exposing (update)

import Material
import Material.Snackbar as Snackbar
import Model exposing (Model, withTheta, withWaviness, withLineHeight, withStretchX, withStretchY, withOpacity, withContrast)
import Ports exposing (render)
import Types exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AdvancedSettingsButtonClicked ->
            ( { model | advancedOptionsOpen = not model.advancedOptionsOpen }, Cmd.none )

        RenderButtonClicked ->
            ( model, render model.params )

        RenderFinished success ->
            if success then
                ( model, Cmd.none )
            else
                let
                    contents =
                        Snackbar.toast Nothing "Rendering error"

                    ( mdc, effects ) =
                        Snackbar.add Mdc "my-snackbar" contents model.mdc
                in
                ( { model | mdc = mdc }, effects )

        UserChangedTheta newTheta ->
            let
                newModel =
                    model |> withTheta newTheta
            in
            ( newModel, render newModel.params )

        UserChangedWaviness newWaviness ->
            let
                newModel =
                    model |> withWaviness newWaviness
            in
            ( newModel, render newModel.params )

        UserChangedLineHeight newLineHeight ->
            let
                newModel =
                    model |> withLineHeight newLineHeight
            in
            ( newModel, render newModel.params )

        UserChangedStretchX newStretchX ->
            let
                newModel =
                    model |> withStretchX newStretchX
            in
            ( newModel, render newModel.params )

        UserChangedStretchY newStretchY ->
            let
                newModel =
                    model |> withStretchY newStretchY
            in
            ( newModel, render newModel.params )

        UserChangedOpacity newOpacity ->
            let
                newModel =
                    model |> withOpacity newOpacity
            in
            ( newModel, render newModel.params )

        UserChangedContrast newContrast ->
            let
                newModel =
                    model |> withContrast newContrast
            in
            ( newModel, render newModel.params )

        NewImageLoaded success ->
            ( model, render model.params )

        Mdc msg_ ->
            Material.update Mdc msg_ model
