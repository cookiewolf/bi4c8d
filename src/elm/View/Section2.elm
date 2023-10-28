module View.Section2 exposing (view)

import Data
import Html
import Html.Attributes
import Html.Events
import InView
import Json.Decode
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 [] [ Html.text "Section 2" ]
    , View.MainText.view Data.Section2 model.content.mainText
    , viewImageList model.inView model.content.images
    ]


viewImageList : InView.State -> List Data.Image -> Html.Html Msg
viewImageList inViewState imageList =
    if List.length imageList > 0 then
        Html.div [ Html.Attributes.class "images" ]
            (List.map
                (\image -> viewImage inViewState image)
                (Data.filterBySection Data.Section2 imageList)
            )

    else
        Html.text ""


viewImage : InView.State -> Data.Image -> Html.Html Msg
viewImage inViewState image =
    let
        trackableId : String
        trackableId =
            Data.trackableIdFromItem image

        positionData =
            []

        maybePositionData : Maybe ( Bool, ( Int, Int, Int ) )
        maybePositionData =
            isVerticallyCenter trackableId inViewState

        ( answer, ( height, x, y ) ) =
            Maybe.withDefault ( False, ( 0, 0, 0 ) )
                maybePositionData
    in
    Html.div []
        [ Html.div
            ([ Html.Attributes.class "image" ]
                ++ (if answer then
                        [ Html.Attributes.style "padding-bottom" (String.fromInt height ++ "px") ]

                    else
                        []
                   )
            )
            [ Html.img
                ([ Html.Attributes.src image.source
                 , Html.Attributes.alt image.alt
                 , Html.Attributes.id trackableId
                 , Html.Attributes.style "z-index" (String.fromInt image.displayPosition)
                 , Html.Events.on "load" (Json.Decode.succeed (Msg.OnElementLoad trackableId))
                 ]
                    ++ (if answer then
                            [ Html.Attributes.style "position" "fixed"
                            , Html.Attributes.style "margin-top" (String.fromInt (y + 100) ++ "px")
                            , Html.Attributes.style "top" (String.fromInt -y ++ "px")
                            , Html.Attributes.style "left" (String.fromInt x ++ "px")
                            ]

                        else
                            []
                       )
                )
                []
            ]
        ]


isVerticallyCenter : String -> InView.State -> Maybe ( Bool, ( Int, Int, Int ) )
isVerticallyCenter id state =
    let
        calc { viewport } element =
            ( viewport.y + viewport.height / 2 > element.y + element.height / 2, ( truncate element.height, truncate element.x, truncate element.y - truncate viewport.y ) )
    in
    InView.custom (\a b -> Maybe.map (calc a) b) id state
