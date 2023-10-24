module View.Section1 exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import Markdown
import Model exposing (Model)
import Msg exposing (Msg(..))


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.h2 [] [ Html.text "Section 1" ]
        , viewMainTextList model.content.mainText
        , viewMessageList model.content.messages
        ]


viewMainTextList : List Data.MainText -> Html.Html Msg
viewMainTextList mainTextList =
    if List.length mainTextList > 0 then
        Html.div []
            (List.map
                (\mainText -> viewMainText mainText)
                (Data.filterBySection Data.Section1 mainTextList)
            )

    else
        Html.text ""


viewMainText : Data.MainText -> Html.Html Msg
viewMainText mainText =
    Html.div []
        [ Html.h3 [] [ Html.text mainText.title ]
        , Html.div [] (Markdown.markdownToHtml mainText.body)
        ]


viewMessageList : List Data.Message -> Html.Html Msg
viewMessageList messageList =
    if List.length messageList > 0 then
        Html.div []
            (List.map
                (\message -> viewMessage message)
                (Data.filterBySection Data.Section1 messageList)
            )

    else
        Html.text ""


viewMessage : Data.Message -> Html.Html Msg
viewMessage message =
    Html.div []
        [ Html.div []
            [ Html.img [ Html.Attributes.src message.avatarSrc ] []
            , Html.h3 [] [ Html.text message.datetime ]
            ]
        , Html.h4 [] [ Html.text (t ForwardedLabel ++ message.forwardedFrom) ]
        , Html.div [] (Markdown.markdownToHtml message.body)
        , Html.div [] [ Html.text (String.fromInt message.viewCount) ]
        ]
