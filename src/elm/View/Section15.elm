module View.Section15 exposing (view)

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
    [ View.Messages.view model.inView Data.Section10 model.content.messages (t Section15MessageHeading) (Just (t Section15MessageTranscriptLink))
    ]
