module View.Section8 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText
import View.StackingImage


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section4 model.content.mainText
    , View.StackingImage.viewImageList Data.Section4 model
    ]
