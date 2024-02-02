module View.Section5 exposing (view)

import Html
import Html.Attributes
import Html.Events
import InView
import Json.Decode
import Model exposing (Model)
import Msg exposing (Msg(..))


type alias FadeImage =
    { id : String
    , srcId : Int
    , isBlank : Bool
    , opacity : String
    , scale : String
    }


view : Model -> List (Html.Html Msg)
view model =
    [ Html.div [ Html.Attributes.class "faces-with-info" ]
        (List.map
            (\imageSrcId ->
                let
                    itemId =
                        "fade-image-" ++ String.fromInt imageSrcId

                    isBlank =
                        case InView.isInOrAboveViewWithMargin itemId (InView.Margin 200 0 400 0) model.inView of
                            Just True ->
                                False

                            _ ->
                                True

                    isJustInView =
                        case InView.isInViewWithMargin itemId (InView.Margin 200 0 400 0) model.inView of
                            Just True ->
                                False

                            _ ->
                                True
                in
                viewImage model.inView
                    { id = itemId
                    , srcId = imageSrcId
                    , isBlank = isBlank
                    , opacity =
                        if isBlank then
                            "1"

                        else
                            "1"
                    , scale =
                        if isBlank then
                            "0.5"

                        else
                            "1"
                    }
            )
            (List.range 1 5)
        )
    ]


viewImage : InView.State -> FadeImage -> Html.Html Msg
viewImage state fadeImage =
    Html.div
        [ Html.Attributes.style "display" "flex"
        , Html.Attributes.style "flex-direction" "row"
        ]
        [ Html.div [ Html.Attributes.class "image-wrapper" ]
            [ Html.img
                [ Html.Attributes.id fadeImage.id
                , Html.Attributes.src (imageSrcFromId fadeImage.isBlank fadeImage.srcId)
                , Html.Events.on "load" (Json.Decode.succeed (OnElementLoad fadeImage.id))
                , Html.Attributes.style "max-width" "100%"
                , Html.Attributes.style "opacity" fadeImage.opacity
                , Html.Attributes.style "transition" (imageTransitionFromId fadeImage.isBlank fadeImage.srcId)
                , Html.Attributes.style "transform" ("scale(" ++ fadeImage.scale ++ ")")
                ]
                []
            ]
        , Html.div [ Html.Attributes.class "profile-info" ] [ Html.text "profile info" ]
        ]


imageTransitionFromId : Bool -> Int -> String
imageTransitionFromId isBlank srcId =
    if isBlank then
        "opacity 0s, transform 0s"

    else
        "opacity 10s, transform 20s"


imageSrcFromId : Bool -> Int -> String
imageSrcFromId isBlank srcId =
    "/images/info-faces/00"
        ++ String.fromInt srcId
        ++ (if isBlank then
                "-white.jpg"

            else
                ""
                    ++ ".jpg"
           )
