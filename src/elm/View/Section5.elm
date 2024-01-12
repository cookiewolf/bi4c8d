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
    , src : String
    , opacity : String
    , scale : String
    }


view : Model -> List (Html.Html Msg)
view model =
    [ Html.div [ Html.Attributes.class "faces-with-info" ]
        (List.indexedMap
            (\index imageSrc ->
                let
                    itemId =
                        "fade-image-" ++ String.fromInt (index + 1)

                    ( itemOpacity, itemScale ) =
                        case InView.isInViewWithMargin itemId (InView.Margin 100 0 100 0) model.inView of
                            Just True ->
                                ( "1", "1" )

                            _ ->
                                ( "0", "0.5" )
                in
                viewImage model.inView
                    { id = itemId
                    , src = imageSrc
                    , opacity = itemOpacity
                    , scale = itemScale
                    }
            )
            imageSrcList
        )
    ]


viewImage : InView.State -> FadeImage -> Html.Html Msg
viewImage state fadeImage =
    Html.img
        [ Html.Attributes.id fadeImage.id
        , Html.Attributes.src fadeImage.src
        , Html.Events.on "load" (Json.Decode.succeed (OnElementLoad fadeImage.id))
        , Html.Attributes.style "opacity" fadeImage.opacity
        , Html.Attributes.style "max-width" "100%"

        -- , style "height" "100%"
        , Html.Attributes.style "transition" "opacity 15s , transform 10s"
        , Html.Attributes.style "transform" ("scale(" ++ fadeImage.scale ++ ")")
        ]
        []


imageSrcList =
    [ "/images/portraits/001.jpg"
    , "/images/portraits/043.jpg"
    , "/images/portraits/060.jpg"
    , "/images/portraits/200.jpg"
    , "/images/portraits/156.jpg"
    ]
