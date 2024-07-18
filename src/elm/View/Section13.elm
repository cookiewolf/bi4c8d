module View.Section13 exposing (view)

import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg(..))
import View.MainText
import View.Terminal


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section13 model.content.mainText
    , View.Terminal.view model Data.Section13
    ]
