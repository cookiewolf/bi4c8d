module View.MainText exposing (view)

import Data
import Html
import Html.Attributes
import Markdown
import Msg exposing (Msg)


view : Data.SectionId -> List Data.MainText -> Html.Html Msg
view sectionId mainTextList =
    if List.length mainTextList > 0 then
        Html.div [ Html.Attributes.class "main-texts" ]
            (List.map
                (\mainText -> viewMainText mainText)
                (Data.filterBySection sectionId mainTextList)
            )

    else
        Html.text ""


viewMainText : Data.MainText -> Html.Html Msg
viewMainText mainText =
    Html.div [ Html.Attributes.class "main-text" ]
        [ Html.h3 [ Html.Attributes.class "main-text-title" ] [ Html.text mainText.title ]
        , Html.div [ Html.Attributes.class "main-text-body" ] (Markdown.markdownToHtml mainText.body)
        ]
