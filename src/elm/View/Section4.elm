module View.Section4 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.StackingImage


view : Model -> List (Html.Html Msg)
view model =
    [ View.StackingImage.viewImageList Data.Section4 model
    ]
