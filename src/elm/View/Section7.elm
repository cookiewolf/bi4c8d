module View.Section7 exposing (view)

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
    , scale : Float
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
                        case InView.isInOrAboveViewWithMargin itemId (InView.Margin 200 0 (toFloat imageSrcId * 150) 0) model.inView of
                            Just True ->
                                False

                            _ ->
                                True
                in
                viewImage model.inView
                    { id = itemId
                    , srcId = imageSrcId
                    , isBlank = isBlank
                    , scale =
                        if isBlank then
                            0.25

                        else
                            1
                    }
            )
            (List.range 1 3)
        )
    ]


viewImage : InView.State -> FadeImage -> Html.Html Msg
viewImage state fadeImage =
    Html.div
        [ Html.Attributes.id ("profile-" ++ fadeImage.id)
        , Html.Attributes.style "display" "flex"
        , Html.Attributes.style "flex-direction" "row"
        ]
        [ Html.img
            [ Html.Attributes.id fadeImage.id
            , Html.Attributes.src (imageSrcFromId fadeImage.isBlank fadeImage.srcId)
            , Html.Events.on "load" (Json.Decode.succeed (OnElementLoad fadeImage.id))
            , Html.Attributes.style "max-width" "100%"
            , Html.Attributes.style "opacity" "1"
            , Html.Attributes.style "transition" (imageTransformFromId fadeImage.isBlank fadeImage.srcId)
            , Html.Attributes.style "transform" ("scale(" ++ String.fromFloat fadeImage.scale ++ ")")
            ]
            []
        , Html.div
            [ Html.Attributes.class "profile-info"
            , Html.Attributes.style "opacity"
                (String.fromFloat (fadeImage.scale - 0.25))
            , Html.Attributes.style "transition" (imageOpacityFromId fadeImage.isBlank fadeImage.srcId)
            ]
            [ Html.p [] [ Html.text "_________ Name" ]
            , Html.p [] [ Html.text "_________ Age" ]
            , Html.p [] [ Html.text "_________ Location" ]
            , Html.p [] [ Html.text "_________ Place of work" ]
            ]
        ]


imageTransformFromId : Bool -> Int -> String
imageTransformFromId isBlank srcId =
    if isBlank then
        "transform 0s"

    else
        "transform " ++ String.fromInt (srcId * 8) ++ "s"


imageOpacityFromId : Bool -> Int -> String
imageOpacityFromId isBlank srcId =
    if isBlank then
        "opacity 0s"

    else
        "opacity " ++ String.fromInt (srcId * 10) ++ "s"


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
