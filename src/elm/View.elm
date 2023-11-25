module View exposing (viewSections)

import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.Section1
import View.Section10
import View.Section11
import View.Section2
import View.Section3
import View.Section4
import View.Section5
import View.Section6
import View.Section7
import View.Section8
import View.Section9


sectionViews : Model -> List (List (Html.Html Msg))
sectionViews model =
    [ View.Section1.view model
    , View.Section2.view model
    , View.Section3.view model
    , View.Section4.view model
    , View.Section5.view model
    , View.Section6.view model
    , View.Section7.view model
    , View.Section8.view model
    , View.Section9.view model
    , View.Section10.view model
    , View.Section11.view model
    ]


viewSections : Model -> List (Html.Html Msg)
viewSections model =
    List.indexedMap
        (\index sectionView ->
            Html.div
                [ Html.Attributes.id ("section-" ++ String.fromInt index)
                , Html.Attributes.class "section"
                ]
                sectionView
        )
        (sectionViews model)
