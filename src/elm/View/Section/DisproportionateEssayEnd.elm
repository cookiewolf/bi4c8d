module View.Section.DisproportionateEssayEnd exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewBottom Data.DisproportionateEssayEnd model.content.mainText
    ]
