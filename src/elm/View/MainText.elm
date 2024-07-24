module View.MainText exposing (viewBottom, viewTop)

import Data exposing (SectionId(..))
import Html
import Html.Attributes
import Markdown
import Msg exposing (Msg)


viewTop : Data.SectionId -> List Data.MainText -> Html.Html Msg
viewTop sectionId mainTextList =
    let
        maybeMainTextList =
            List.map
                (\mainText -> viewMainText mainText True)
                (Data.filterBySection sectionId mainTextList)
                |> List.reverse
                |> List.head
    in
    case maybeMainTextList of
        Just mainTextHead ->
            case sectionId of
                Section1 ->
                    Html.div [ Html.Attributes.class "introduction" ]
                        [ Html.div [ Html.Attributes.class "main-texts" ]
                            [ mainTextHead ]
                        ]

                _ ->
                    Html.div [ Html.Attributes.class "main-texts" ]
                        [ mainTextHead ]

        Nothing ->
            Html.text ""


viewBottom : Data.SectionId -> List Data.MainText -> Html.Html Msg
viewBottom sectionId mainTextList =
    let
        maybeMainTextList =
            List.map
                (\mainText -> viewMainText mainText False)
                (Data.filterBySection sectionId mainTextList)
                |> List.reverse
                |> List.tail
    in
    case maybeMainTextList of
        Just mainTextTail ->
            Html.div [ Html.Attributes.class "main-texts" ]
                mainTextTail

        Nothing ->
            Html.text ""


viewMainText : Data.MainText -> Bool -> Html.Html Msg
viewMainText mainText showTitle =
    Html.div [ Html.Attributes.class "main-text" ]
        [ if showTitle then
            Html.h3 [ Html.Attributes.class "main-text-title" ] [ Html.text mainText.title ]

          else
            Html.text ""
        , Html.div [ Html.Attributes.class "main-text-body" ] (Markdown.markdownToHtml mainText.body)
        ]
