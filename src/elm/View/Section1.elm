module View.Section1 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText
import View.Messages


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section1 model.content.mainText
    , View.Messages.view Data.Section1 model.content.messages
    ]
