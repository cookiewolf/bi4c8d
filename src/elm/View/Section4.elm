module View.Section4 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.StackingImage


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 [] [ Html.text "Section 4" ]
    , View.StackingImage.viewImageList Data.Section4 model.inView model.content.images
    ]
