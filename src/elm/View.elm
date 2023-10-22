module View exposing (viewSections)

import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.Section1


viewSections : Model -> List (Html.Html Msg)
viewSections model =
    [ Html.div [ Html.Attributes.class "section-container" ] [ View.Section1.view model ] ]