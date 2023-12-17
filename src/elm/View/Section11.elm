module View.Section11 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.Messages


view : Model -> List (Html.Html Msg)
view model =
    [ View.Messages.view Data.Section11 model.content.messages
    ]
