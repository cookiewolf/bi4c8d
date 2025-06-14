module View.Section.FacialRecognition exposing (view)

import Copy.Keys exposing (InfoLabel(..), Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import Html.Events
import InView
import Json.Decode
import Model exposing (Model)
import Msg exposing (Msg(..))
import View.MainText
import View.StackingImage


type alias FadeImage =
    { id : String
    , srcId : Int
    , isBlank : Bool
    , scale : Float
    }


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.FacialRecognition model.content.mainText
    , View.StackingImage.viewImageList Data.FacialRecognition model
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


viewImage : Int -> FadeImage -> Html.Html Msg
viewImage delay fadeImage =
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
                (String.fromFloat
                    (if fadeImage.isBlank then
                        0

                     else
                        1
                    )
                )
            , Html.Attributes.style "transition" (infoTransition fadeImage.isBlank delay)
            ]
            ([ Html.p [] [ Html.text (t ProfileInfoHeading) ]
             ]
                ++ viewProfileInfoList (profileInfoFromSrcId fadeImage.srcId)
            )
        ]


profile1InfoList : List InfoLabel
profile1InfoList =
    -- Type of info (Name, Job, City, Work, Email)
    -- (int, int) character count first and second word
    -- Email needs additional top level domain string
    [ Name ( 4, 9 )
    , Work ( 7, 10 )
    , Email ( 5, 14, "com" )
    ]


profile2InfoList : List InfoLabel
profile2InfoList =
    [ Name ( 8, 5 )
    , Job ( 12, 0 )
    , City ( 8, 0 )
    ]


profile3InfoList : List InfoLabel
profile3InfoList =
    [ Name ( 3, 8 )
    , Email ( 8, 10, "co.uk" )
    ]


profileInfoFromSrcId : Int -> List InfoLabel
profileInfoFromSrcId imageId =
    if imageId == 1 then
        profile1InfoList

    else if imageId == 2 then
        profile2InfoList

    else if imageId == 3 then
        profile3InfoList

    else
        profile1InfoList


viewProfileInfoList : List InfoLabel -> List (Html.Html Msg)
viewProfileInfoList infoList =
    List.map
        (\labelData ->
            viewProfileInfoListItem labelData
        )
        infoList


viewProfileInfoListItem : InfoLabel -> Html.Html Msg
viewProfileInfoListItem labelData =
    Html.p [] [ Html.text (t (ProfileInfoLabel labelData)) ]


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
