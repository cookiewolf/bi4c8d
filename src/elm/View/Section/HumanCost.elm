module View.Section.HumanCost exposing (view)

import Copy.Keys
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.HumanCost model.content.mainText
    ]
