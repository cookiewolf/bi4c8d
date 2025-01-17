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
    [ Html.div [ Html.Attributes.id "spotlight" ] []
    , Html.button [ Html.Attributes.id "light-switch" ] [ Html.text (t SpotlightSwitchButtonText) ]
    , View.MainText.viewTop Data.Introduction model.content.mainText
    , Html.button
        [ Html.Events.onClick ToggleViewIntro
        ]
        [ Html.text (t ViewContentButtonText) ]
    ]
