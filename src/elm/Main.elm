port module Main exposing (main)

import AssocList
import Browser
import Browser.Dom
import Browser.Events
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


port onGrow : (Float -> msg) -> Sub msg


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
        initialTickerState : List Data.TickerState
        initialTickerState =
            Data.initialTickerState flags

        trackableImages : List String
        trackableImages =
            [ "fade-image-1"
            , "fade-image-2"
            , "fade-image-3"
            , "fade-image-4"
            , "fade-image-5"
            ]

        trackableSections : List String
        trackableSections =
            [ "introduction"
            , "social-media-posts"
            , "public-trust"
            , "telegram"
            , "ulterior-motives"
            , "section-six"
            , "section-seven"
            , "section-eight"
            , "section-nine"
            , "section-ten"
            , "section-eleven"
            , "section-twelve"
            , "section-thirteen"
            , "section-fourteen"
            , "section-fifteen"
            , "section-sixteen"
            , "section-seventeen"
            ]

        ( inViewModel, inViewCmds ) =
            InView.init InViewMsg (trackableSections ++ trackableImages)

        content : Data.Content
        content =
            Data.decodedContent flags

        socialMediaPostsDraggableContent : ( ( Data.SectionId, Int ), List Pile.Data )
        socialMediaPostsDraggableContent =
            ( ( Data.SocialMediaPosts, 1 ), content.posts |> Data.filterBySection Data.SocialMediaPosts |> List.map Pile.Post )

        ulteriorMotivesDraggablePosts : ( ( Data.SectionId, Int ), List Pile.Data )
        ulteriorMotivesDraggablePosts =
            ( ( Data.UlteriorMotives, 1 ), content.posts |> Data.filterBySection Data.UlteriorMotives |> List.map Pile.Post )

        ulteriorMotivesDraggableImages : ( ( Data.SectionId, Int ), List Pile.Data )
        ulteriorMotivesDraggableImages =
            ( ( Data.UlteriorMotives, 2 ), content.images |> Data.filterBySection Data.UlteriorMotives |> List.map Pile.Image )

        section8draggableContent : ( ( Data.SectionId, Int ), List Pile.Data )
        section8draggableContent =
            ( ( Data.Section8, 1 ), content.images |> Data.filterBySection Data.Section8 |> List.map Pile.Image )

        section10draggableContent : ( ( Data.SectionId, Int ), List Pile.Data )
        section10draggableContent =
            ( ( Data.Section10, 1 ), content.posts |> Data.filterBySection Data.Section10 |> List.map Pile.Post )

        section16draggableContent : ( ( Data.SectionId, Int ), List Pile.Data )
        section16draggableContent =
            ( ( Data.Section16, 1 ), content.posts |> Data.filterBySection Data.Section16 |> List.map Pile.Post )
    in
    ( { time = Time.millisToPosix 0
      , content = content
      , tickerState = initialTickerState
      , breachCount = 0
      , domHeight = 0.0
      , randomIntList = []
      , inView = inViewModel
      , viewportHeightWidth = ( 800, 800 )
      , chartHovering = []
      , terminalState = AssocList.fromList [ ( Data.Section13, { input = "", history = [] } ), ( Data.Section9, { input = "", history = [] } ) ]
      , piles =
            Pile.init
                [ socialMediaPostsDraggableContent
                , ulteriorMotivesDraggablePosts
                , ulteriorMotivesDraggableImages
                , section8draggableContent
                , section10draggableContent
                , section16draggableContent
                ]
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
        , onGrow OnGrow
        , Pile.subscriptions model.piles |> Sub.map Piles
        , Browser.Events.onResize (\newWidth newHeight -> OnResize ( toFloat newHeight, toFloat newWidth ))
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
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

        OnGrow height ->
            if model.domHeight == height then
                ( model
                , Cmd.none
                )

            else
                let
                    ( inView, inViewCmds ) =
                        InView.addElements InViewMsg [] model.inView
                in
                ( { model | domHeight = height, inView = inView }
                , inViewCmds
                )

        OnResize viewportHeightWidth ->
            ( { model | viewportHeightWidth = viewportHeightWidth }
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

        ChangeCommand id command ->
            ( { model
                | terminalState =
                    AssocList.update id
                        (Maybe.map
                            (\state ->
                                { input = command
                                , history = state.history
                                }
                            )
                        )
                        model.terminalState
              }
            , Cmd.none
            )

        SubmitCommand id command ->
            ( { model
                | terminalState =
                    AssocList.update id
                        (Maybe.map
                            (\state ->
                                let
                                    history =
                                        if command == "clear" then
                                            -- Improved but wrong positioning if terminal container is scrolled past and then typed into.
                                            []

                                        else
                                            state.history ++ [ command ]
                                in
                                { input = ""
                                , history = history
                                }
                            )
                        )
                        model.terminalState
              }
              --       -- maybe playing with this will help
            , scrollToElement "terminal-output"
            )

        ScrollResult _ ->
            ( model, Cmd.none )

        Piles pileMsg ->
            let
                ( piles, cmd ) =
                    Pile.update pileMsg model.piles
            in
            ( { model | piles = piles }, cmd |> Cmd.map Piles )


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
