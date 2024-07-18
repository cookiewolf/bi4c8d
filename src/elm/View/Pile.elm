module View.Pile exposing (..)

import Data
import Html
import Html.Attributes
import Pile
import View.Posts


view : Pile.Data -> Html.Html msg
view data =
    case data of
        Pile.Post post ->
            Html.div [] (View.Posts.viewPost post False)

        Pile.Image image ->
            viewImage image


viewImage : Data.Image -> Html.Html msg
viewImage image =
    Html.div
        [ Html.Attributes.class "image-constraint" ]
        [ Html.img
            [ Html.Attributes.src image.source
            , Html.Attributes.alt image.alt
            ]
            []
        ]
