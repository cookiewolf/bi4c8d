module View.Section8 exposing (view)

import Html
import Html.Attributes
import InView
import Model exposing (Model)
import Msg exposing (Msg)
import Simple.Animation
import Simple.Animation.Animated
import Simple.Animation.Property


view : Model -> List (Html.Html Msg)
view model =
    let
        sectionInView =
            InView.isInOrAboveView "section-8" model.inView
                |> Maybe.withDefault False
    in
    [ Html.h2 []
        [ Html.text "Section 8 - 2000 images with tickers"
        , if sectionInView then
            viewPortraitList model.randomIntList

          else
            Html.text ""
        ]
    ]


viewPortraitList : List Int -> Html.Html Msg
viewPortraitList randomIntList =
    Html.div [ Html.Attributes.class "portraits" ]
        (List.map2
            (\count randomInt ->
                animatedImg (fadeIn ((randomInt * 100) + count * 10))
                    [ Html.Attributes.src (jpgSrcFromInt count)
                    , Html.Attributes.class "portrait"
                    ]
                    []
            )
            (List.range 0 865)
            randomIntList
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
            ]
        }
        [ Simple.Animation.Property.opacity 0 ]
        [ Simple.Animation.Property.opacity 1 ]
