module View.Section3 exposing (view)

import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.Graph
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section3 model.content.mainText
    , Html.div
        [ Html.Attributes.class "graph-container"
        , Html.Attributes.style "min-height" (String.fromFloat (Tuple.first model.viewportHeightWidth) ++ "px")
        ]
        [ Html.div [ Html.Attributes.class "chart" ] [ View.Graph.view model Data.Section3 ]
        ]
    , View.MainText.viewBottom Data.Section3 model.content.mainText
    ]
