module View.Section.PublicTrust exposing (view)

import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.Graph


view : Model -> List (Html.Html Msg)
view model =
    [ Html.div
        [ Html.Attributes.class "graph-container"
        , Html.Attributes.style "min-height" (String.fromFloat (Tuple.first model.viewportHeightWidth) ++ "px")
        ]
        [ View.Graph.view model Data.PublicTrust
        ]
    ]
