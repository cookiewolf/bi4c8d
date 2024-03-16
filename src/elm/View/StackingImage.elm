module View.StackingImage exposing (viewImageList)

import Data
import Html
import Html.Attributes
import Html.Events
import InView
import Json.Decode
import Model exposing (Model)
import Msg exposing (Msg)


viewImageList : Data.SectionId -> Model -> Html.Html Msg
viewImageList section model =
    if List.length model.content.images > 0 then
        Html.div
            [ Html.Attributes.class "images"
            ]
            (List.map
                (\image -> viewImage (Tuple.first model.viewportHeightWidth) model.inView image)
                (Data.filterBySection section model.content.images)
            )

    else
        Html.text ""


viewImage : Float -> InView.State -> Data.Image -> Html.Html Msg
viewImage viewportHeight inViewState image =
    Html.div
        [ Html.Attributes.class "image" ]
        [ Html.img
            [ Html.Attributes.src image.source
            , Html.Attributes.alt image.alt
            , Html.Attributes.style "z-index" (String.fromInt image.displayPosition)
            , Html.Attributes.style "max-height" (imageHeightFromViewport viewportHeight)
            ]
            []
        ]


imageHeightFromViewport : Float -> String
imageHeightFromViewport viewportHeight =
    String.fromFloat (viewportHeight * 0.8) ++ "px"
