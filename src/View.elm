module View exposing (viewSections)

import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.Section1


viewSections : Model -> List (Html.Html Msg)
viewSections model =
    [ View.Section1.view model ]
