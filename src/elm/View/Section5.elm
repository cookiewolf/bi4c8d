module View.Section5 exposing (view)

import Html
import Model exposing (Model)
import Msg exposing (Msg)


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 [] [ Html.text "Section 5 - white squares coming into focus" ]
    ]
