module View.Section.Introduction exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import Html.Events
import Model exposing (Model)
import Msg exposing (Msg(..))
import Pile
import View.MainText
import View.Pile
import View.Posts


view : Model -> List (Html.Html Msg)
view model =
    [ if mightBeMobileTablet model.viewportHeightWidth then
        Html.text ""

      else
        Html.div [ Html.Attributes.id "spotlight" ] []
    , View.MainText.viewTop Data.Introduction model.content.mainText
    , Html.a
        [ Html.Events.onClick ToggleViewIntro
        ]
        [ Html.text (t ViewContentLinkText) ]
    ]


mightBeMobileTablet : ( Float, Float ) -> Bool
mightBeMobileTablet ( _, width ) =
    if width > 1024 then
        False

    else
        True
