module View exposing (viewSections)

import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.Section1


viewSections : Model -> List (Html.Html Msg)
viewSections model =
    [ Html.div
        [ Html.Attributes.id "section-1"
        , Html.Attributes.class "section"
        ]
        (View.Section1.view model)
    ]
