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
        , Html.Attributes.style "height" (String.fromFloat (Tuple.first model.viewportHeightWidth) ++ "px")
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
        [ Html.h3 [] [ Html.text (String.replace "-" " " terminalId) ]
        , Html.p [] [ Html.text welcomeMessage ]
        , viewOutput prompt model.terminalState.history commandList
        , Html.span [ Html.Attributes.class "input-span" ]
            [ viewPrompt prompt
            , Html.input
                [ Html.Attributes.value model.terminalState.input
                , Html.Events.onInput ChangeCommand
                , Html.Events.Extra.onEnter (SubmitCommand model.terminalState.input)
                ]
                []
            ]
        ]


viewPrompt : String -> Html.Html Msg
viewPrompt prompt =
    let
        promptParts =
            String.split "@" prompt

        userName =
            Maybe.withDefault "" (List.head promptParts)

        machineName =
            Maybe.withDefault "bi4c8d" (List.head (List.reverse promptParts)) |> String.replace "$" ""
    in
    Html.span [ Html.Attributes.class "prompt" ]
        [ Html.span [ Html.Attributes.class "user-name" ] [ Html.text userName ]
        , Html.text "@"
        , Html.span [ Html.Attributes.class "machine-name" ] [ Html.text machineName ]
        , Html.text "$"
        ]


viewOutput : String -> List String -> List Data.Command -> Html.Html Msg
viewOutput prompt commandHistory commandList =
    Html.div [ Html.Attributes.class "output-container" ]
        (List.map
            (\command ->
                Html.div [ Html.Attributes.class "output" ]
                    [ Html.span []
                        [ viewPrompt prompt
                        , Html.span [ Html.Attributes.class "command" ] [ Html.text command ]
                        ]
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

    else if not (List.member (stripToSubCommand command) (terminalCommandNames commandList)) then
        Html.div [ Html.Attributes.class "error" ] [ Html.text (t (ErrorText command)) ]

    else
        Html.div [] (Markdown.markdownToHtml (outputFromCommand (stripToSubCommand command) commandList))


outputFromCommand : String -> List Data.Command -> String
outputFromCommand command commandList =
    let
        theCommand =
            List.head
                (List.filter
                    (\aCommand ->
                        command
                            == stripToSubCommand aCommand.name
                    )
                    commandList
                )
                |> Maybe.withDefault { helpText = "", name = "", output = "", subCommands = [] }
    in
    if List.member theCommand (hasSubCommands commandList) then
        theCommand.helpText

    else
        theCommand.output


terminalCommandNames : List Data.Command -> List String
terminalCommandNames commands =
    List.map .name commands


hasSubCommands : List Data.Command -> List Data.Command
hasSubCommands commands =
    List.filter (\command -> List.length command.subCommands > 0) commands


isNotSubCommand : List Data.Command -> List Data.Command
isNotSubCommand commands =
    let
        subCommands =
            List.map (\command -> command.subCommands) commands
                |> List.concat
    in
    List.filter (\command -> not (List.member command.name subCommands)) commands


stripToSubCommand : String -> String
stripToSubCommand commandName =
    List.head (List.reverse (String.split " " commandName))
        |> Maybe.withDefault commandName


viewCommandList : List Data.Command -> Html.Html Msg
viewCommandList commandList =
    Html.ul []
        (List.map
            (\command ->
                Html.li [] [ Html.text (command.name ++ ": " ++ command.helpText) ]
            )
            (isNotSubCommand commandList)
        )
