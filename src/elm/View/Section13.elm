module View.Section13 exposing (view)

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
    [ View.MainText.viewTop Data.Section9 model.content.mainText
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
                    { section = Data.Section13
                    , terminalId = "default-terminal"
                    , welcomeMessage = "Welcome!"
                    , prompt = "$"
                    , commandList = []
                    }
    in
    Html.div
        [ Html.Attributes.id "terminal-output"
        , Html.Attributes.class "terminal"
        ]
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
    Html.span
        [ Html.Attributes.class "prompt"
        ]
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
        outputFromCommand (stripToSubCommand command) commandList


outputFromCommand : String -> List Data.Command -> Html.Html Msg
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
                |> Maybe.withDefault Data.defaultCommand
    in
    if List.member theCommand (hasSubCommands commandList) then
        Html.div [ Html.Attributes.class "help" ] [ Html.ul [] (viewSubCommandHelp theCommand commandList) ]

    else
        Html.div [] (Markdown.markdownToHtml theCommand.output)


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


isSubCommand : List Data.Command -> List Data.Command
isSubCommand commands =
    let
        subCommands =
            List.map (\command -> command.subCommands) commands
                |> List.concat
    in
    List.filter (\command -> List.member command.name subCommands) commands


stripToSubCommand : String -> String
stripToSubCommand commandName =
    List.head (List.reverse (String.split " " commandName))
        |> Maybe.withDefault commandName


viewCommandList : List Data.Command -> Html.Html Msg
viewCommandList commandList =
    Html.ul []
        (List.map
            (\command ->
                viewCommandHelp command commandList
            )
            (isNotSubCommand commandList)
        )


viewCommandHelp : Data.Command -> List Data.Command -> Html.Html Msg
viewCommandHelp command commandList =
    if List.length command.subCommands > 0 then
        Html.ul [ Html.Attributes.class "sub-command-list" ] (viewSubCommandHelp command commandList)

    else
        Html.li [] (viewCommandHelpText command)


viewCommandHelpText : Data.Command -> List (Html.Html Msg)
viewCommandHelpText command =
    [ Html.span [ Html.Attributes.class "command-name" ] [ Html.text command.name ]
    , Html.span [] [ Html.text command.helpText ]
    ]


viewSubCommandHelp : Data.Command -> List Data.Command -> List (Html.Html Msg)
viewSubCommandHelp command commandList =
    [ Html.li [ Html.Attributes.class "requires-sub-commands" ] (viewCommandHelpText command) ]
        ++ List.map
            (\commandName ->
                viewCommandHelp (commandFromName commandName commandList) commandList
            )
            command.subCommands


commandFromName : String -> List Data.Command -> Data.Command
commandFromName commandName commandList =
    List.filter (\command -> command.name == commandName) commandList
        |> List.head
        |> Maybe.withDefault Data.defaultCommand
