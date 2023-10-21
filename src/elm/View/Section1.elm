module View.Section1 exposing (view)

import Html
import Model exposing (Model)
import Msg exposing (Msg(..))


view : Model -> Html.Html Msg
view model =
    Html.div [] [ Html.h2 [] [ Html.text "Section 1" ] ]
