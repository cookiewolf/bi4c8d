module View.Section2 exposing (view)

import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.Graph
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section2 model.content.mainText
    , Html.div
        [ Html.Attributes.class "graph-container"
        , Html.Attributes.style "min-height" (String.fromFloat (Tuple.first model.viewportHeightWidth) ++ "px")
        ]
        [ View.Graph.view model Data.Section2
        ]
    , View.MainText.viewBottom Data.Section2 model.content.mainText
    ]
