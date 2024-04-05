module View.Section6 exposing (view)

import Data
import Html
import Html.Attributes
import Html.Events
import Json.Encode
import Model exposing (Model)
import Msg exposing (Msg(..))
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section6 model.content.mainText
    , Html.div
        [ Html.Attributes.class "terminal-container"
        , Html.Attributes.style "height" (String.fromFloat (Tuple.first model.viewportHeightWidth - 200) ++ "px")
        ]
        [ viewTerminal model ]
    ]


viewTerminal : Model -> Html.Html Msg
viewTerminal model =
    let
        { terminalId, welcomeMessage, prompt, commandList } =
            case List.head model.content.terminals of
                Just aTerminal ->
                    aTerminal

                Nothing ->
                    { terminalId = "default-terminal"
                    , welcomeMessage = "Welcome!"
                    , prompt = "$"
                    , commandList = []
                    }
    in
    Html.div [ Html.Attributes.class "terminal" ]
        [ Html.h3 [] [ Html.text welcomeMessage ]
        , Html.span []
            [ Html.text prompt
            , Html.input [ Html.Attributes.value model.terminalState.input, Html.Events.onInput SubmitCommand ] []
            ]
        , Html.div [] [ Html.text model.terminalState.input ]
        ]
