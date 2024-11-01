module View.Section.DataLoss exposing (view)

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
import View.Terminal


view : Model -> List (Html.Html Msg)
view model =
    let
        sectionInView =
            InView.isInOrAboveView "data-loss" model.inView
                |> Maybe.withDefault False
    in
    [ Html.div []
        [ Html.h2 [ Html.Attributes.class "heading" ]
            [ Html.text (t DataLossHeading) ]
        , Html.h2
            [ Html.Attributes.class "final-ticker"
            , Html.Attributes.style "font-size" (fontSizeStringFromViewport model.viewportHeightWidth)
            , Html.Attributes.style "height" (sectionHeightStringFromViewport model.viewportHeightWidth)
            ]
            [ Html.text (t (Copy.Keys.TotalBreachesSinceView model.breachCount)) ]
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
    , View.Terminal.view model Data.DataLoss
    ]


viewTickers : Model -> Html.Html Msg
viewTickers model =
    if Tuple.second model.viewportHeightWidth < 800 then
        Html.ul [ Html.Attributes.class "tickers", Html.Attributes.attribute "role" "list" ]
            (List.map
                (\ticker -> viewTicker model.viewportHeightWidth model.time ticker)
                model.tickerState
            )

    else
        Html.div [ Html.Attributes.class "tickers" ]
            (List.map
                (\ticker -> viewTicker model.viewportHeightWidth model.time ticker)
                model.tickerState
            )


viewTicker : ( Float, Float ) -> Time.Posix -> Data.TickerState -> Html.Html Msg
viewTicker viewportHeightWidth now tickerState =
    if Tuple.second viewportHeightWidth < 800 then
        Html.li
            [ Html.Attributes.class "ticker" ]
            [ Html.div [] [ Html.text (tickerState.label ++ ": " ++ viewTickerCount now tickerState) ] ]

    else
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
                Html.div
                    [ if modBy 14 randomInt == 0 then
                        Html.Attributes.style "background" "#33FF00"

                      else
                        Html.Attributes.style "background" "white"
                    , Html.Attributes.style "margin" "2px"
                    , Html.Attributes.style "overflow" "hidden"
                    ]
                    [ animatedImg (fadeIn ((randomInt * 100) + count * 10))
                        [ Html.Attributes.src (jpgSrcFromInt count)
                        , Html.Attributes.class "portrait"
                        , Html.Attributes.style "object-fit" "cover"
                        ]
                        []
                    ]
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
        [ Simple.Animation.Property.opacity 0.8 ]


slideInTicker : ( Float, Float ) -> Int -> Simple.Animation.Animation
slideInTicker ( height, width ) id =
    let
        idFloat =
            toFloat (id + 1)

        imagesPerRow =
            -- width of image + padding
            floor (width / (80 + 4))

        heightOfAllRows =
            floor (620 / toFloat imagesPerRow) * 80

        endY =
            idFloat * (toFloat heightOfAllRows / 15)

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
                    ( ( 0, 120 ), 100 )

                6 ->
                    ( ( width, 140 ), width / 2 )

                7 ->
                    ( ( 0, 160 ), width - 600 )

                8 ->
                    ( ( width, 180 ), 400 )

                9 ->
                    ( ( width, 200 ), width - 400 )

                10 ->
                    ( ( width, 220 ), width - 600 )

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


sectionHeightStringFromViewport : ( Float, Float ) -> String
sectionHeightStringFromViewport ( height, _ ) =
    String.fromFloat height ++ "px"


fontSizeStringFromViewport : ( Float, Float ) -> String
fontSizeStringFromViewport ( height, width ) =
    if width < 800 then
        String.fromFloat (height / 24) ++ "px"

    else
        String.fromFloat (width / 18) ++ "px"
