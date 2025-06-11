module View.Section.ProjectInfo exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Events
import Model exposing (MenuItem(..), Model)
import Msg exposing (Msg(..))
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.ProjectInfo model.content.mainText
    , Html.a
        [ Html.Events.onClick (ToggleView Page1)
        ]
        [ Html.text (t ContentMenuItemText) ]
    ]
