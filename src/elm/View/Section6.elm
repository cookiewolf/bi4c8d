module View.Section6 exposing (view)

import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section6 model.content.mainText
    , Html.div
        [ Html.Attributes.class "ttty-terminal-container"
        , Html.Attributes.style "height" (String.fromFloat (Tuple.first model.viewportHeightWidth - 200) ++ "px")
        ]
        [ viewTerminal model.content.terminals ]
    ]


viewTerminal : List Data.Terminal -> Html.Html Msg
viewTerminal terminals =
    let
        { terminalId, welcomeMessage, prompt } =
            case List.head terminals of
                Just aTerminal ->
                    aTerminal

                Nothing ->
                    { terminalId = "ttty-terminal"
                    , welcomeMessage = "Welcome!"
                    , prompt = "$"
                    }
    in
    Html.node "ttty-terminal"
        [ Html.Attributes.id terminalId
        , Html.Attributes.attribute "host-id" terminalId
        , Html.Attributes.attribute "welcome-message" welcomeMessage
        , Html.Attributes.attribute "prompt" prompt
        ]
        []
