module View.Section9 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 [] [ Html.text "Section 9 - data compromise count" ]
    , View.MainText.viewTop Data.Section9 model.content.mainText
    ]