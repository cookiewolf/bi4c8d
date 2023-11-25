module View.Section2 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText
import View.StackingImage


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 [] [ Html.text "Section 2" ]
    , View.MainText.viewTop Data.Section2 model.content.mainText
    , View.StackingImage.viewImageList Data.Section2 model.inView model.content.images
    ]
