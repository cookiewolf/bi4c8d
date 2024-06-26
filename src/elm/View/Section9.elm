module View.Section9 exposing (view)

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
    , View.MainText.viewTop Data.Section9 model.content.mainText
    ]


sectionHeightStringFromViewport : ( Float, Float ) -> String
sectionHeightStringFromViewport ( height, _ ) =
    String.fromFloat height ++ "px"


fontSizeStringFromViewport : ( Float, Float ) -> String
fontSizeStringFromViewport ( _, width ) =
    String.fromFloat (width / 18) ++ "px"
