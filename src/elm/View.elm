module View exposing (viewSections)

import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.Section1
import View.Section2
import View.Section3
import View.Section4
import View.Section5
import View.Section6


viewSections : Model -> List (Html.Html Msg)
viewSections model =
    [ Html.div
        [ Html.Attributes.id "section-1"
        , Html.Attributes.class "section"
        ]
        (View.Section1.view model)
    , Html.div
        [ Html.Attributes.id "section-2"
        , Html.Attributes.class "section"
        ]
        (View.Section2.view model)
    , Html.div
        [ Html.Attributes.id "section-3"
        , Html.Attributes.class "section"
        ]
        (View.Section3.view model)
    , Html.div
        [ Html.Attributes.id "section-4"
        , Html.Attributes.class "section"
        ]
        (View.Section4.view model)
    , Html.div
        [ Html.Attributes.id "section-5"
        , Html.Attributes.class "section"
        ]
        (View.Section5.view model)
    , Html.div
        [ Html.Attributes.id "section-6"
        , Html.Attributes.class "section"
        ]
        (View.Section6.view model)
    ]
