module View.Section6 exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import Html.Events
import Html.Events.Extra
import Json.Encode
import Markdown
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
        , viewOutput prompt model.terminalState.history commandList
        , Html.span []
            [ Html.text prompt
            , Html.input
                [ Html.Attributes.value model.terminalState.input
                , Html.Events.onInput ChangeCommand
                , Html.Events.Extra.onEnter (SubmitCommand model.terminalState.input)
                ]
                []
            ]
        ]


viewOutput : String -> List String -> List Data.Command -> Html.Html Msg
viewOutput prompt commandHistory commandList =
    Html.div [ Html.Attributes.class "output-container" ]
        (List.map
            (\command ->
                Html.div [ Html.Attributes.class "output" ]
                    [ Html.span [] [ Html.text prompt, Html.span [ Html.Attributes.class "command" ] [ Html.text command ] ]
                    , viewResponse command commandList
                    ]
            )
            commandHistory
        )


viewResponse : String -> List Data.Command -> Html.Html Msg
viewResponse command commandList =
    if command == "help" then
        Html.div [ Html.Attributes.class "help" ]
            [ Html.div []
                [ Html.text (t HelpText)
                , viewCommandList commandList
                ]
            ]

    else if not (List.member command (terminalCommandNames commandList)) then
        Html.div [ Html.Attributes.class "error" ] [ Html.text (t (ErrorText command)) ]

    else
        Html.div [] (Markdown.markdownToHtml (outputFromCommand command commandList))


outputFromCommand : String -> List Data.Command -> String
outputFromCommand command commandList =
    (List.head
        (List.filter
            (\aCommand -> command == aCommand.name)
            commandList
        )
        |> Maybe.withDefault { helpText = "", name = "", output = "" }
    ).output


terminalCommandNames : List Data.Command -> List String
terminalCommandNames commands =
    List.map .name commands


viewCommandList : List Data.Command -> Html.Html Msg
viewCommandList commandList =
    Html.ul []
        (List.map
            (\command ->
                Html.li [] [ Html.text (command.name ++ ": " ++ command.helpText) ]
            )
            commandList
        )
