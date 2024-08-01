module View.Section12 exposing (view)

import Copy.Keys
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2
        [ Html.Attributes.class "final-ticker"
        , Html.Attributes.style "font-size" (fontSizeStringFromViewport model.viewportHeightWidth)
        , Html.Attributes.style "height" (sectionHeightStringFromViewport model.viewportHeightWidth)
        ]
        [ Html.text (t (Copy.Keys.TotalBreachesSinceView model.breachCount)) ]
    ]


sectionHeightStringFromViewport : ( Float, Float ) -> String
sectionHeightStringFromViewport ( height, _ ) =
    String.fromFloat height ++ "px"


fontSizeStringFromViewport : ( Float, Float ) -> String
fontSizeStringFromViewport ( height, width ) =
    if width < 800 then
        String.fromFloat (height / 24) ++ "px"
    else
        String.fromFloat (width / 18) ++ "px"
