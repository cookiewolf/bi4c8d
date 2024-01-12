module View.StackingImage exposing (viewImageList)

import Data
import Html
import Html.Attributes
import Html.Events
import InView
import Json.Decode
import Msg exposing (Msg)


viewImageList : Data.SectionId -> InView.State -> List Data.Image -> Html.Html Msg
viewImageList section inViewState imageList =
    if List.length imageList > 0 then
        Html.div
            [ Html.Attributes.class "images"
            ]
            (List.map
                (\image -> viewImage inViewState image)
                (Data.filterBySection section imageList)
            )

    else
        Html.text ""


viewImage : InView.State -> Data.Image -> Html.Html Msg
viewImage inViewState image =
    Html.div
        [ Html.Attributes.class "image" ]
        [ Html.img
            [ Html.Attributes.src image.source
            , Html.Attributes.alt image.alt
            , Html.Attributes.style "z-index" (String.fromInt image.displayPosition)
            ]
            []
        ]
