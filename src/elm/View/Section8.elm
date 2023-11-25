module View.Section8 exposing (view)

import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import Simple.Animation
import Simple.Animation.Animated
import Simple.Animation.Property


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 []
        [ Html.text "Section 8 - 2000 images with tickers"
        , viewPortraitList
        ]
    ]


viewPortraitList : Html.Html Msg
viewPortraitList =
    Html.div [ Html.Attributes.class "portraits" ]
        (List.map
            (\count ->
                animatedImg (fadeIn (count * 100))
                    [ Html.Attributes.src (jpgSrcFromInt count)
                    , Html.Attributes.class "portrait"
                    ]
                    []
            )
            (List.range 0 865)
        )


jpgSrcFromInt : Int -> String
jpgSrcFromInt count =
    "/images/portraits/" ++ String.fromInt count ++ ".jpg"


animatedImg : Simple.Animation.Animation -> List (Html.Attribute Msg) -> List (Html.Html Msg) -> Html.Html Msg
animatedImg =
    Simple.Animation.Animated.html Html.img


fadeIn : Int -> Simple.Animation.Animation
fadeIn delay =
    Simple.Animation.fromTo
        { duration = 6000
        , options =
            [ Simple.Animation.delay delay
            , Simple.Animation.loop
            , Simple.Animation.yoyo
            ]
        }
        [ Simple.Animation.Property.opacity 0 ]
        [ Simple.Animation.Property.opacity 1 ]
