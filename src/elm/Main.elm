port module Main exposing (main)

import Browser
import Browser.Dom
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import InView
import Model exposing (Model)
import Msg exposing (Msg(..))
import Random
import Task
import Time
import View


port onScroll : ({ x : Float, y : Float } -> msg) -> Sub msg


main : Program Data.Flags Model Msg
main =
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = viewDocument
        }


init : Data.Flags -> ( Model, Cmd Msg )
init flags =
    let
        initialTickerState =
            Data.initialTickerState flags

        trackableSections =
            [ "section-8"
            , "fade-image-1"
            , "fade-image-2"
            , "fade-image-3"
            , "fade-image-4"
            , "fade-image-5"
            ]

        ( inViewModel, inViewCmds ) =
            InView.init InViewMsg trackableSections
    in
    ( { time = Time.millisToPosix 0
      , content = Data.decodedContent flags
      , tickerState = initialTickerState
      , breachCount = 0
      , randomIntList = []
      , inView = inViewModel
      , viewportHeightWidth = ( 800, 800 )
      , chartHovering = []
      }
    , Cmd.batch
        [ Random.generate NewRandomIntList generateRandomIntList
        , inViewCmds
        , Task.perform GotViewport Browser.Dom.getViewport
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every 100 Tick -- 10 times per second
        , InView.subscriptions InViewMsg model.inView
        , onScroll OnScroll
        ]


update msg model =
    case msg of
        Tick newTime ->
            ( { model
                | time = newTime
                , tickerState =
                    let
                        section8InView =
                            InView.isInOrAboveView "section-8" model.inView |> Maybe.withDefault False
                    in
                    if section8InView then
                        List.map (\tickerState -> Data.updateTickerState tickerState) model.tickerState

                    else
                        model.tickerState
                , breachCount =
                    if remainderBy 13 (Time.posixToMillis model.time) == 0 then
                        model.breachCount + 1

                    else
                        model.breachCount
              }
            , Cmd.none
            )

        NewRandomIntList newRandomIntList ->
            ( { model | randomIntList = newRandomIntList }
            , Cmd.none
            )

        GotViewport viewport ->
            ( { model | viewportHeightWidth = Maybe.withDefault model.viewportHeightWidth (Just ( viewport.viewport.height, viewport.viewport.width )) }
            , Cmd.none
            )

        OnScroll offset ->
            ( { model | inView = InView.updateViewportOffset offset model.inView }
            , Cmd.none
            )

        InViewMsg inViewMsg ->
            let
                ( inView, inViewCmds ) =
                    InView.update InViewMsg inViewMsg model.inView
            in
            ( { model | inView = inView }
            , inViewCmds
            )

        OnElementLoad id ->
            let
                ( inView, inViewCmds ) =
                    InView.addElements InViewMsg [ id ] model.inView
            in
            ( { model | inView = inView }
            , inViewCmds
            )

        OnChartHover hovering ->
            ( { model | chartHovering = hovering }, Cmd.none )


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = t SiteTitle
    , body =
        [ Html.div
            [ Html.Attributes.class "page-wrapper"
            ]
            [ Html.h1 [] [ Html.text (t SiteTitle) ]
            , Html.div [] (View.viewSections model)
            ]
        ]
    }


generateRandomIntList : Random.Generator (List Int)
generateRandomIntList =
    Random.list 619 (Random.int 0 100)
