module View.Section10 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.Messages


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 [] [ Html.text "Lock Bit" ]
    , View.Messages.view Data.Section10 model.content.messages
    ]
