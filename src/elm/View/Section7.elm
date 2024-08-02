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
        (List.range 1 3
            |> List.foldr
                (\imageSrcId ( offset, listElements ) ->
                    let
                        itemId =
                            "fade-image-" ++ String.fromInt imageSrcId

                        isBlank =
                            case InView.isInOrAboveView itemId model.inView of
                                Just True ->
                                    False

                                _ ->
                                    True

                        element =
                            viewImage offset
                                model.inView
                                { id = itemId
                                , srcId = imageSrcId
                                , isBlank = isBlank
                                , scale =
                                    if isBlank then
                                        0.25

                                    else
                                        1
                                }
                    in
                    ( offset + imageSrcId, element :: listElements )
                )
                ( 0, [] )
            |> Tuple.second
        )
    ]


viewImage : Int -> InView.State -> FadeImage -> Html.Html Msg
viewImage delayOffset state fadeImage =
    Html.div
        [ Html.Attributes.id ("profile-" ++ fadeImage.id)
        , Html.Attributes.class "profile"
        ]
        [ Html.img
            [ Html.Attributes.id fadeImage.id
            , Html.Attributes.src (imageSrcFromId fadeImage.isBlank fadeImage.srcId)
            , Html.Events.on "load" (Json.Decode.succeed (OnElementLoad fadeImage.id))
            , Html.Attributes.style "max-width" "100%"
            , Html.Attributes.style "opacity" "1"
            , Html.Attributes.style "transition" (imageTransformFromId delayOffset fadeImage.isBlank fadeImage.srcId)
            , Html.Attributes.style "transform" ("scale(" ++ String.fromFloat fadeImage.scale ++ ")")
            ]
            []
        , Html.div
            [ Html.Attributes.class "profile-info"
            , Html.Attributes.style "opacity"
                (String.fromFloat (fadeImage.scale - 0.25))
            , Html.Attributes.style "transition" (imageOpacityFromId delayOffset fadeImage.isBlank fadeImage.srcId)
            ]
            [ Html.p [] [ Html.text "_________ Name" ]
            , Html.p [] [ Html.text "_________ Age" ]
            , Html.p [] [ Html.text "_________ Location" ]
            , Html.p [] [ Html.text "_________ Place of work" ]
            ]
        ]


imageTransformFromId : Int -> Bool -> Int -> String
imageTransformFromId delayOffset isBlank srcId =
    let
        delay =
            delayOffset + (srcId * 8)
    in
    if isBlank then
        "transform 0s"

    else
        "transform " ++ String.fromInt delay ++ "s"


imageOpacityFromId : Int -> Bool -> Int -> String
imageOpacityFromId delayOffset isBlank srcId =
    let
        delay =
            delayOffset + (srcId * 10)
    in
    if isBlank then
        "opacity 0s"

    else
        "opacity " ++ String.fromInt delay ++ "s"


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
