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
import Pile
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
            [ "section-eleven"
            , "section-fifteen"
            , "section-sixteen"
            , "fade-image-1"
            , "fade-image-2"
            , "fade-image-3"
            , "fade-image-4"
            , "fade-image-5"
            ]

        ( inViewModel, inViewCmds ) =
            InView.init InViewMsg trackableSections

        content =
            Data.decodedContent flags

        section1draggableContent =
            ( Data.Section1, content.posts |> Data.filterBySection Data.Section1 |> List.map Pile.Post )

        section4draggableContent =
            ( Data.Section4, content.images |> Data.filterBySection Data.Section4 |> List.map Pile.Image )

        section10draggableContent =
            ( Data.Section10, content.posts |> Data.filterBySection Data.Section10 |> List.map Pile.Post )
    in
    ( { time = Time.millisToPosix 0
      , content = content
      , tickerState = initialTickerState
      , breachCount = 0
      , randomIntList = []
      , inView = inViewModel
      , viewportHeightWidth = ( 800, 800 )
      , chartHovering = []
      , terminalState = { input = "", history = [] }
      , piles = Pile.init [ section1draggableContent, section4draggableContent, section10draggableContent ]
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
        , Pile.subscriptions Piles model.piles
        ]


update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Tick newTime ->
            ( { model
                | time = newTime
                , tickerState =
                    let
                        section8InView =
                            InView.isInOrAboveView "section-eleven" model.inView |> Maybe.withDefault False
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

        ChangeCommand command ->
            ( { model
                | terminalState =
                    { input = command
                    , history = model.terminalState.history
                    }
              }
            , Cmd.none
            )

        SubmitCommand command ->
            -- Improved but wrong positioning if terminal container is scrolled past and then typed into.
            if command == "clear" then
                ( { model
                    | terminalState =
                        { input = "", history = [] }
                  }
                  -- maybe playing with this will help
                , scrollToElement "terminal-output"
                )

            else
                ( { model
                    | terminalState =
                        { input = ""
                        , history = model.terminalState.history ++ [ command ]
                        }
                  }
                , scrollToElement "terminal-output"
                )

        ScrollResult _ ->
            ( model, Cmd.none )

        Piles pileMsg ->
            let
                ( piles, cmd ) =
                    Pile.update Piles pileMsg model.piles
            in
            ( { model | piles = piles }, cmd )


scrollToElement : String -> Cmd Msg
scrollToElement id =
    Browser.Dom.getViewportOf id
        |> Task.andThen
            (\info ->
                Browser.Dom.setViewportOf id
                    0
                    -- or maybe playing with this will help
                    info.scene.height
            )
        |> Task.attempt ScrollResult


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
