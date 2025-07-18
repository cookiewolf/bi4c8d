module View.Section.Introduction exposing (view)

import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ Html.div [ Html.Attributes.id "spotlight" ] []
    , View.MainText.viewTop Data.Introduction model.content.mainText
    ]
