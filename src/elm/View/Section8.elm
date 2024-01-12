module View.Section8 exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import InView
import Model exposing (Model)
import Msg exposing (Msg)
import Simple.Animation
import Simple.Animation.Animated
import Simple.Animation.Property
import Time


view : Model -> List (Html.Html Msg)
view model =
    let
        sectionInView =
            InView.isInOrAboveView "section-8" model.inView
                |> Maybe.withDefault False
    in
    [ Html.div []
        [ Html.h2 [ Html.Attributes.class "heading" ] [ Html.text (t Section8Heading) ]
        , if sectionInView then
            viewTickers
                model

          else
            Html.text ""
        , if sectionInView then
            viewPortraitList model.randomIntList

          else
            Html.text ""
        ]
    ]


viewTickers : Model -> Html.Html Msg
viewTickers model =
    Html.div [ Html.Attributes.class "tickers" ]
        (List.map
            (\ticker -> viewTicker model.viewportHeightWidth model.time ticker)
            model.tickerState
        )


viewTicker : ( Float, Float ) -> Time.Posix -> Data.TickerState -> Html.Html Msg
viewTicker viewportHeightWidth now tickerState =
    Simple.Animation.Animated.div
        (slideInTicker viewportHeightWidth tickerState.id)
        [ Html.Attributes.class "ticker" ]
        [ Html.h2 [] [ Html.text (tickerState.label ++ ": " ++ viewTickerCount now tickerState) ] ]


viewTickerCount : Time.Posix -> Data.TickerState -> String
viewTickerCount now tickerState =
    String.fromInt tickerState.count


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
            (List.range 1 619)
            randomIntList
        )


jpgSrcFromInt : Int -> String
jpgSrcFromInt count =
    "/images/portraits/" ++ String.padLeft 3 '0' (String.fromInt count) ++ ".jpg"


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


slideInTicker : ( Float, Float ) -> Int -> Simple.Animation.Animation
slideInTicker ( height, width ) id =
    let
        idFloat =
            toFloat (id + 1)

        endY =
            idFloat * (height / 8)

        ( ( startX, startY ), endX ) =
            case id of
                0 ->
                    ( ( 0, 20 ), 200 )

                1 ->
                    ( ( width, 40 ), 0 )

                2 ->
                    ( ( width, 60 ), 400 )

                3 ->
                    ( ( 0, 80 ), 60 )

                4 ->
                    ( ( 0, 100 ), 200 )

                5 ->
                    ( ( 0, 120 ), width / 2 )

                6 ->
                    ( ( width, 140 ), 600 )

                7 ->
                    ( ( 0, 160 ), 800 )

                8 ->
                    ( ( width, 180 ), 400 )

                9 ->
                    ( ( width, 200 ), 600 )

                10 ->
                    ( ( width, 220 ), 800 )

                11 ->
                    ( ( 0, 240 ), width / 2 )

                12 ->
                    ( ( width, 260 ), 400 )

                _ ->
                    ( ( width, 0 ), 0 )
    in
    Simple.Animation.fromTo
        { duration = (id + 1) * 2000
        , options = [ Simple.Animation.delay (id * 1000) ]
        }
        [ Simple.Animation.Property.opacity 0
        , Simple.Animation.Property.xy startX startY
        ]
        [ Simple.Animation.Property.xy endX endY ]
