module View.Messages exposing (view)

import Data
import Html
import Html.Attributes
import Markdown
import Msg exposing (Msg)
import Time


view : Data.SectionId -> List Data.Message -> String -> Html.Html Msg
view sectionId messageList title =
    if List.length messageList > 0 then
        Html.div [ Html.Attributes.class "messages" ]
            [ Html.h3 [] [ Html.text title ]
            , Html.div [ Html.Attributes.class "messages-inner" ]
                (List.map
                    (\message ->
                        viewMessage message
                            (isLastAtTime message messageList)
                    )
                    (Data.filterBySection sectionId messageList)
                    |> List.concat
                )
            ]

    else
        Html.text ""


isLastAtTime : Data.Message -> List Data.Message -> Bool
isLastAtTime message allMessages =
    let
        messagesSameTime =
            List.filter
                (\{ datetime } ->
                    viewMessageTime
                        datetime
                        == viewMessageTime message.datetime
                )
                allMessages
    in
    case List.head (List.reverse messagesSameTime) of
        Just aMessage ->
            message == aMessage

        Nothing ->
            False


viewMessage : Data.Message -> Bool -> List (Html.Html Msg)
viewMessage message isLast =
    [ Html.div
        [ Html.Attributes.class "message"
        , Html.Attributes.class (Data.sideToString message.side)
        ]
        [ Html.div
            [ Html.Attributes.class "message-body"
            ]
            (Markdown.markdownToHtml message.body)
        , if isLast then
            Html.div [ Html.Attributes.class "message-time" ] [ viewMessageTime message.datetime ]

          else
            Html.text ""
        ]
    ]


viewMessageTime : Time.Posix -> Html.Html Msg
viewMessageTime posix =
    Html.text
        ([ String.fromInt (Time.toHour Time.utc posix)
         , String.fromInt (Time.toMinute Time.utc posix)
         ]
            |> List.map (\timeDigit -> String.padLeft 2 '0' timeDigit)
            |> String.join ":"
        )
