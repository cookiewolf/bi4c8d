module View.Section1 exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import Markdown
import Model exposing (Model)
import Msg exposing (Msg(..))


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 [] [ Html.text "Section 1" ]
    , viewMainTextList model.content.mainText
    , viewMessageList model.content.messages
    ]


viewMainTextList : List Data.MainText -> Html.Html Msg
viewMainTextList mainTextList =
    if List.length mainTextList > 0 then
        Html.div [ Html.Attributes.class "main-texts" ]
            (List.map
                (\mainText -> viewMainText mainText)
                (Data.filterBySection Data.Section1 mainTextList)
            )

    else
        Html.text ""


viewMainText : Data.MainText -> Html.Html Msg
viewMainText mainText =
    Html.div [ Html.Attributes.class "main-text" ]
        [ Html.h3 [ Html.Attributes.class "main-text-title" ] [ Html.text mainText.title ]
        , Html.div [ Html.Attributes.class "main-text-body" ] (Markdown.markdownToHtml mainText.body)
        ]


viewMessageList : List Data.Message -> Html.Html Msg
viewMessageList messageList =
    if List.length messageList > 0 then
        Html.div [ Html.Attributes.class "messages" ]
            (List.map
                (\message -> viewMessage message)
                (Data.filterBySection Data.Section1 messageList)
            )

    else
        Html.text ""


viewMessage : Data.Message -> Html.Html Msg
viewMessage message =
    Html.div []
        [ Html.div [ Html.Attributes.class "message" ]
            [ Html.img
                [ Html.Attributes.class "message-avatar"
                , Html.Attributes.src message.avatarSrc
                ]
                []
            , Html.h3 [ Html.Attributes.class "message-date" ] [ Html.text message.datetime ]
            ]
        , Html.h4 [ Html.Attributes.class "message-forwarded-from" ] [ Html.text (t ForwardedLabel ++ message.forwardedFrom) ]
        , Html.div [ Html.Attributes.class "message-body" ] (Markdown.markdownToHtml message.body)
        , Html.div []
            [ Html.span [ Html.Attributes.class "message-view-count" ] [ Html.text (String.fromInt message.viewCount) ]
            , Html.span [ Html.Attributes.class "message-time" ] [ Html.text message.datetime ]
            ]
        ]
