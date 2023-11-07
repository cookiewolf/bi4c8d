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
    , View.MainText.viewTop Data.Section2 model.content.mainText
    , viewImageList model.inView model.content.images
    ]


viewImageList : InView.State -> List Data.Image -> Html.Html Msg
viewImageList inViewState imageList =
    if List.length imageList > 0 then
        Html.div
            [ Html.Attributes.class "images"
            ]
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

        maybePositionData : Maybe ( Bool, { height : Int, xPosition : Int, yPosition : Int } )
        maybePositionData =
            isVerticallyCenter trackableId inViewState

        ( answer, { height, xPosition, yPosition } ) =
            Maybe.withDefault ( False, { height = 0, xPosition = 0, yPosition = 0 } )
                maybePositionData

        reachedLastInTrackableList =
            False
    in
    Html.div
        ([ Html.Attributes.class "image" ]
            ++ (if answer then
                    [ Html.Attributes.style "padding-bottom" (String.fromInt (height // 2) ++ "px") ]

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
                ++ (if answer && not reachedLastInTrackableList then
                        [ Html.Attributes.style "position" "absolute"
                        , Html.Attributes.style "margin-top" (String.fromInt (yPosition - 80) ++ "px")
                        , Html.Attributes.style "top"
                            (String.fromInt (-yPosition + 100) ++ "px")

                        --, Html.Attributes.style "top" "0"
                        --, Html.Attributes.style "left" (String.fromInt xPosition ++ "px")
                        ]

                    else
                        []
                   )
            )
            []
        ]


isVerticallyCenter : String -> InView.State -> Maybe ( Bool, { height : Int, xPosition : Int, yPosition : Int } )
isVerticallyCenter id state =
    let
        calc { viewport } element =
            ( viewport.y + viewport.height / 2 > element.y + element.height / 2, { height = truncate element.height, xPosition = truncate element.x, yPosition = truncate element.y - truncate viewport.y } )
    in
    InView.custom (\a b -> Maybe.map (calc a) b) id state



--Just ( False, { height = 0, xPosition = 0, yPosition = 0 } )
