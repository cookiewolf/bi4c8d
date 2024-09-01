module View.Section.RoyalMailNegotiation exposing (view)

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
    [ View.Messages.view model.inView Data.RoyalMailNegotiation model.content.messages (t RoyalMailNegotiationMessageHeading) (Just (t RoyalMailNegotiationMessageTranscriptLink))
    ]
