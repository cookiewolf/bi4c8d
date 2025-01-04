module View.Section.FacialRecognition exposing (view)

import Data
import Html
import Html.Attributes
import Html.Events
import InView
import Json.Decode
import Model exposing (Model)
import Msg exposing (Msg(..))
import View.StackingImage


type alias FadeImage =
    { id : String
    , srcId : Int
    , isBlank : Bool
    , scale : Float
    }


view : Model -> List (Html.Html Msg)
view model =
    [ View.StackingImage.viewImageList Data.FacialRecognition model
    , Html.div [ Html.Attributes.class "faces-with-info" ]
        (List.range 1 3
            |> List.foldl
                (\imageSrcId ( offset, listElements ) ->
                    let
                        delay =
                            offset + 3

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
                    ( delay, listElements ++ [ element ] )
                )
                ( 0, [] )
            |> Tuple.second
        )
    ]


viewImage : Int -> InView.State -> FadeImage -> Html.Html Msg
viewImage delay state fadeImage =
    Html.div
        [ Html.Attributes.id ("profile-" ++ fadeImage.id)
        , Html.Attributes.class "profile"
        ]
        [ Html.div
            [ Html.Attributes.class "profile-image-container"
            , Html.Attributes.style "transform" ("scale(" ++ String.fromFloat fadeImage.scale ++ ")")
            , Html.Attributes.style "transition" (imageTransition fadeImage.isBlank delay)
            ]
            [ Html.img
                [ Html.Attributes.id fadeImage.id
                , Html.Attributes.class "profile-image"
                , Html.Attributes.src (imageSrcFromId fadeImage.isBlank fadeImage.srcId)
                , Html.Events.on "load" (Json.Decode.succeed (OnElementLoad fadeImage.id))
                , Html.Attributes.style "max-width" "100%"
                , Html.Attributes.style "opacity"
                    (String.fromInt (floor fadeImage.scale))
                , Html.Attributes.style "transition" (imageTransition fadeImage.isBlank delay)
                ]
                []
            ]
        , Html.div
            [ Html.Attributes.class "profile-info"
            , Html.Attributes.style "opacity"
                (String.fromFloat (fadeImage.scale - 0.25))
            , Html.Attributes.style "transition" (infoTransition fadeImage.isBlank delay)
            ]
            [ Html.p [] [ Html.text "Extracted Information" ]
            , Html.p [] [ Html.text "Name: █████ ███████" ]
            , Html.p [] [ Html.text "Job Title: █████ █████████" ]
            , Html.p [] [ Html.text "City of Residence: ██████" ]
            , Html.p [] [ Html.text "Place of Work: ██████" ]
            , Html.p [] [ Html.text "Email: ██████@██████.com" ]
            ]
        ]


imageTransition : Bool -> Int -> String
imageTransition isBlank delay =
    if isBlank then
        "transform 0s"

    else
        "transform "
            ++ -- duration
               (String.fromInt 2 ++ "s ")
            ++ -- delay
               (String.fromInt delay ++ "s")
            ++ ",opacity "
            ++ -- duration
               (String.fromInt 2 ++ "s ")
            ++ -- delay
               (String.fromInt delay ++ "s")


infoTransition : Bool -> Int -> String
infoTransition isBlank delay =
    if isBlank then
        "opacity 0s"

    else
        "opacity "
            ++ -- duration
               (String.fromInt 2 ++ "s ")
            ++ -- delay
               (String.fromFloat (toFloat delay + 1.5) ++ "s")


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
