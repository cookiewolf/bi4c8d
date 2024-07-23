module View.StackingImage exposing (viewImageList, viewImageListDraggable, viewImageListStatic)

import Data
import Html
import Html.Attributes
import Html.Events
import InView
import Json.Decode
import Model exposing (Model)
import Msg exposing (Msg)


viewImageList : Data.SectionId -> Model -> Html.Html msg
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


viewImage : Float -> InView.State -> Data.Image -> Html.Html msg
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


viewImageListDraggable : Data.SectionId -> List Data.Image -> List (Html.Html msg)
viewImageListDraggable section images =
    if List.length images > 0 then
        List.map
            (\image -> viewImageDraggable image)
            (Data.filterBySection section images)

    else
        []


viewImageDraggable : Data.Image -> Html.Html msg
viewImageDraggable image =
    Html.div
        [ Html.Attributes.class "image-constraint" ]
        [ Html.img
            [ Html.Attributes.src image.source
            , Html.Attributes.alt image.alt
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
