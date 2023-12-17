module View.Section10 exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.Messages


view : Model -> List (Html.Html Msg)
view model =
    [ View.Messages.view Data.Section10 model.content.messages (t Section10MessageHeading)
    ]
