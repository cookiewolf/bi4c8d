module View.Section1 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg(..))


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.h2 [] [ Html.text "Section 1" ]
        , viewMainTextList model.content.mainText
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
        , Html.p [] [ Html.text mainText.body ]
        ]
