module View.Section.Outro exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Outro model.content.mainText
    , View.MainText.viewBottom Data.Outro model.content.mainText
    ]
