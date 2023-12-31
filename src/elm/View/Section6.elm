module View.Section6 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 [] [ Html.text "Section 6 - terminal" ]
    , View.MainText.viewTop Data.Section6 model.content.mainText
    ]
