module View exposing (viewSections)

import Data
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


sectionViews : Model -> List ( Data.SectionId, List (Html.Html Msg) )
sectionViews model =
    [ ( Data.Section1, View.Section1.view model )
    , ( Data.Section2, View.Section2.view model )
    , ( Data.Section3, View.Section3.view model )
    , ( Data.Section4, View.Section4.view model )
    , ( Data.Section5, View.Section5.view model )
    , ( Data.Section6, View.Section6.view model )
    , ( Data.Section7, View.Section7.view model )
    , ( Data.Section8, View.Section8.view model )
    , ( Data.Section9, View.Section9.view model )
    , ( Data.Section10, View.Section10.view model )
    , ( Data.Section11, View.Section11.view model )
    ]


viewSections : Model -> List (Html.Html Msg)
viewSections model =
    List.map
        (\( sectionId, sectionView ) ->
            Html.div
                [ Html.Attributes.id (Data.sectionIdToString sectionId)
                , Html.Attributes.class "section"
                , Html.Attributes.style "min-height" (sectionHeightFromViewport model.viewportHeightWidth)
                ]
                sectionView
        )
        (sectionViews model)


sectionHeightFromViewport : ( Float, Float ) -> String
sectionHeightFromViewport viewportHeighWidth =
    String.fromFloat (Tuple.first viewportHeighWidth) ++ "px"
