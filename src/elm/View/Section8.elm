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
        (slideIn viewportHeightWidth tickerState.label)
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


slideIn : ( Float, Float ) -> String -> Simple.Animation.Animation
slideIn ( height, width ) id =
    let
        ( ( startX, startY ), ( endX, endY ) ) =
            case id of
                "Data emailed to incorrect recipient" ->
                    ( ( 0, 20 ), ( 200, 20 ) )

                _ ->
                    ( ( width, 0 ), ( 0, height / 3 ) )
    in
    Simple.Animation.fromTo
        { duration = 8000
        , options = []
        }
        [ Simple.Animation.Property.xy startX startY ]
        [ Simple.Animation.Property.xy endX endY ]
