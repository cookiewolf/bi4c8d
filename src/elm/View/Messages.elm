module View.Messages exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import Markdown
import Msg exposing (Msg)
import Time


view : Data.SectionId -> List Data.Message -> Html.Html Msg
view sectionId messageList =
    if List.length messageList > 0 then
        Html.div [ Html.Attributes.class "messages" ]
            (List.map
                (\message ->
                    viewMessage message
                        (isFirstOnDate message messageList)
                )
                (Data.filterBySection sectionId messageList)
                |> List.concat
            )

    else
        Html.text ""


isFirstOnDate : Data.Message -> List Data.Message -> Bool
isFirstOnDate message allMessages =
    let
        messagesSameDay =
            List.filter
                (\{ datetime } ->
                    viewMessageDate
                        datetime
                        == viewMessageDate message.datetime
                )
                allMessages
    in
    case List.head messagesSameDay of
        Just aMessage ->
            message == aMessage

        Nothing ->
            False


viewMessage : Data.Message -> Bool -> List (Html.Html Msg)
viewMessage message isFirst =
    [ Html.div [ Html.Attributes.class "message" ]
        [ if isFirst then
            Html.h3 [ Html.Attributes.class "message-date" ]
                [ viewMessageDate message.datetime
                ]

          else
            Html.text ""
        , Html.div [ Html.Attributes.class "message-inner" ]
            [ Html.h4 [ Html.Attributes.class "message-forwarded-from" ] [ Html.text (t ForwardedLabel ++ message.forwardedFrom) ]
            , Html.div [ Html.Attributes.class "message-body" ] (Markdown.markdownToHtml message.body)
            , Html.div [ Html.Attributes.class "message-meta-info" ]
                [ Html.span [ Html.Attributes.class "message-view-count" ] [ viewMessageViewCount message.viewCount ]
                , Html.span [ Html.Attributes.class "message-time" ] [ viewMessageTime message.datetime ]
                ]
            ]
        , Html.img
            [ Html.Attributes.class "message-avatar"
            , Html.Attributes.src message.avatarSrc
            ]
            []
        ]
    ]


viewMessageDate : Time.Posix -> Html.Html Msg
viewMessageDate posix =
    Html.text
        (String.join ""
            [ Copy.Text.monthToString (Time.toMonth Time.utc posix)
            , " "
            , String.fromInt (Time.toDay Time.utc posix)
            , ", "
            , String.fromInt (Time.toYear Time.utc posix)
            ]
        )


viewMessageTime : Time.Posix -> Html.Html Msg
viewMessageTime posix =
    Html.text
        ([ String.fromInt (Time.toHour Time.utc posix)
         , String.fromInt (Time.toMinute Time.utc posix)
         ]
            |> List.map (\timeDigit -> String.padLeft 2 '0' timeDigit)
            |> String.join ":"
        )


viewMessageViewCount : Int -> Html.Html Msg
viewMessageViewCount viewCount =
    Html.text
        (if toFloat viewCount / 1000 > 1 then
            String.fromInt (viewCount // 1000) ++ "k"

         else
            String.fromInt viewCount
        )
