module View.Section.HmrcTerminal exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.Terminal


view : Model -> List (Html.Html Msg)
view model =
    [ View.Terminal.view model Data.HmrcTerminal
    ]
