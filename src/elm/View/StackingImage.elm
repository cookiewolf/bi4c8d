module View.StackingImage exposing (viewImageList, viewImageListStatic)

import Data
import Html
import Html.Attributes
import Model exposing (Model)


viewImageList : Data.SectionId -> Model -> Html.Html msg
viewImageList section model =
    if List.length model.content.images > 0 then
        Html.div
            [ Html.Attributes.class "images"
            ]
            (List.map
                (\image -> viewImage (Tuple.first model.viewportHeightWidth) image)
                (Data.filterBySection section model.content.images)
            )

    else
        Html.text ""


viewImage : Float -> Data.Image -> Html.Html msg
viewImage viewportHeight image =
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


viewImageListStatic : Data.SectionId -> List Data.Image -> Html.Html msg
viewImageListStatic section images =
    if List.length images > 0 then
        Html.div
            [ Html.Attributes.class "images-mobile"
            ]
            (List.map
                (\image -> viewImageStatic image)
                (Data.filterBySection section images)
            )

    else
        Html.text ""


viewImageStatic : Data.Image -> Html.Html msg
viewImageStatic image =
    Html.div
        []
        [ Html.img
            [ Html.Attributes.src image.source
            , Html.Attributes.alt image.alt
            ]
            []
        ]


imageHeightFromViewport : Float -> String
imageHeightFromViewport viewportHeight =
    String.fromFloat (viewportHeight * 0.8) ++ "px"
