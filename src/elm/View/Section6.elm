module View.Section6 exposing (view)

import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section6 model.content.mainText
    , Html.div
        [ Html.Attributes.class "ttty-terminal-container"
        , Html.Attributes.style "height" (String.fromFloat (Tuple.first model.viewportHeightWidth - 200) ++ "px")
        ]
        [ Html.node "ttty-terminal"
            [ Html.Attributes.id "ttty-terminal"
            , Html.Attributes.attribute "command" "TODO-get commands from CMS"
            ]
            []
        ]
    ]
