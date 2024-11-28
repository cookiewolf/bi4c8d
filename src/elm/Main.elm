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
import Html.Events
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
            List.map (\id -> Data.sectionIdToString id)
                [ Data.SectionInvalid
                , Data.Introduction
                , Data.SocialMediaPosts
                , Data.PublicTrust
                , Data.Telegram
                , Data.UlteriorMotives
                , Data.PanicLit
                , Data.PublicOrderSafety
                , Data.DisproportionateEssayEnd
                , Data.FacialRecognition
                , Data.IncompetenceIntro
                , Data.IncompetencePostsAndPapers
                , Data.HmrcTerminal
                , Data.DataLoss
                , Data.RansomwareTerminal
                , Data.HumanCost
                , Data.RoyalMailNegotiation
                , Data.HackneySocial
                , Data.Outro
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

        panicLitdraggableContent : ( ( Data.SectionId, Int ), List Pile.Data )
        panicLitdraggableContent =
            ( ( Data.PanicLit, 1 ), content.images |> Data.filterBySection Data.PanicLit |> List.map Pile.Image )

        incompentencedraggablePosts : ( ( Data.SectionId, Int ), List Pile.Data )
        incompentencedraggablePosts =
            ( ( Data.IncompetencePostsAndPapers, 1 ), content.posts |> Data.filterBySection Data.IncompetencePostsAndPapers |> List.map Pile.Post )

        incompentencedraggableImages : ( ( Data.SectionId, Int ), List Pile.Data )
        incompentencedraggableImages =
            ( ( Data.IncompetencePostsAndPapers, 2 ), content.images |> Data.filterBySection Data.IncompetencePostsAndPapers |> List.map Pile.Image )

        section16draggableContent : ( ( Data.SectionId, Int ), List Pile.Data )
        section16draggableContent =
            ( ( Data.HackneySocial, 1 ), content.posts |> Data.filterBySection Data.HackneySocial |> List.map Pile.Post )
    in
    ( { time = Time.millisToPosix 0
      , content = content
      , titleText = titleTextInit
      , viewingIntro = True
      , tickerState = initialTickerState
      , breachCount = 0
      , domHeight = 0.0
      , randomIntList = []
      , inView = inViewModel
      , viewportHeightWidth = ( 800, 800 )
      , chartHovering = []
      , terminalState = AssocList.fromList [ ( Data.HmrcTerminal, { input = "", history = [] } ), ( Data.RansomwareTerminal, { input = "", history = [] } ) ]
      , piles =
            Pile.init
                [ socialMediaPostsDraggableContent
                , ulteriorMotivesDraggablePosts
                , ulteriorMotivesDraggableImages
                , panicLitdraggableContent
                , incompentencedraggablePosts
                , incompentencedraggableImages
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


titleTextInit : Model.TitleText
titleTextInit =
    { text = "Bi4c8d"
    , animationRunningTime = 0
    , insertPosition = 3
    , insertCharacter = '*'
    }


titleTextEnd : Model.TitleText
titleTextEnd =
    { text = t SiteTitle
    , animationRunningTime = 2001
    , insertPosition = 0
    , insertCharacter = 'B'
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Tick newTime ->
            let
                titleAnimationIsRunning : Bool
                titleAnimationIsRunning =
                    model.titleText.animationRunningTime <= 2000
            in
            ( { model
                | time = newTime
                , titleText =
                    if titleAnimationIsRunning then
                        viewTitleAnimation model.titleText
                            |> incrementRunningTime

                    else
                        titleTextEnd
                , tickerState =
                    let
                        tickerSectionInView =
                            InView.isInOrAboveView "data-loss" model.inView |> Maybe.withDefault False
                    in
                    if tickerSectionInView then
                        List.map (\tickerState -> Data.updateTickerState tickerState) model.tickerState

                    else
                        model.tickerState
                , breachCount =
                    if remainderBy 13 (Time.posixToMillis model.time) == 0 then
                        model.breachCount + 1

                    else
                        model.breachCount
              }
            , if titleAnimationIsRunning then
                Cmd.batch
                    [ Random.generate NewRandomInsertChar generateRandomChar
                    , Random.generate NewRandomInsertPosition (generateRandomInt (String.length model.titleText.text))
                    ]

              else
                Cmd.none
            )

        NewRandomIntList newRandomIntList ->
            ( { model | randomIntList = newRandomIntList }
            , Cmd.none
            )

        NewRandomInsertChar randomCharacter ->
            ( { model | titleText = setInsertChar randomCharacter model.titleText }, Cmd.none )

        NewRandomInsertPosition randomInt ->
            ( { model | titleText = setInsertPosition randomInt model.titleText }, Cmd.none )

        GotViewport viewport ->
            ( { model | viewportHeightWidth = Maybe.withDefault model.viewportHeightWidth (Just ( viewport.viewport.height, viewport.viewport.width )) }
            , Cmd.none
            )

        MousedOverTitle ->
            ( { model | titleText = titleTextInit }
            , Cmd.none
            )

        MousedOffTitle ->
            ( { model | titleText = titleTextEnd }
            , Cmd.none
            )

        ToggleViewIntro ->
            ( { model
                | viewingIntro = not model.viewingIntro
              }
            , Task.perform (always NoOp) (Browser.Dom.setViewport 0 0)
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
              -- maybe playing with this will help
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


randomChars : List Char
randomChars =
    "&^%$/<'|*()!@:;~#"
        |> String.toList


generateRandomChar : Random.Generator Char
generateRandomChar =
    Random.int 0 (List.length randomChars)
        |> Random.map randomIntToChar


randomIntToChar : Int -> Char
randomIntToChar randomInt =
    List.drop randomInt randomChars
        |> List.head
        |> Maybe.withDefault '*'


setInsertChar : Char -> Model.TitleText -> Model.TitleText
setInsertChar randomChar titleText =
    { titleText | insertCharacter = randomChar }


generateRandomInt : Int -> Random.Generator Int
generateRandomInt max =
    Random.int 0 max


setInsertPosition : Int -> Model.TitleText -> Model.TitleText
setInsertPosition randomInt titleText =
    { titleText | insertPosition = randomInt }


incrementRunningTime : Model.TitleText -> Model.TitleText
incrementRunningTime initialTitleText =
    { initialTitleText | animationRunningTime = initialTitleText.animationRunningTime + 20 }


viewTitleAnimation : Model.TitleText -> Model.TitleText
viewTitleAnimation initialTitleText =
    let
        newTitleText =
            { initialTitleText
                | text = insertCharacter initialTitleText
            }
    in
    newTitleText


insertCharacter : Model.TitleText -> String
insertCharacter titleText =
    (titleText.text
        |> String.toList
        |> List.take titleText.insertPosition
    )
        ++ [ titleText.insertCharacter ]
        ++ (titleText.text
                |> String.toList
                |> List.drop (titleText.insertPosition + 1)
           )
        |> String.fromList


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = t SiteTitle
    , body =
        [ Html.div
            [ Html.Attributes.class "page-wrapper"
            ]
            [ Html.h1 []
                [ Html.span
                    [ Html.Events.onMouseOver MousedOverTitle
                    , Html.Events.onMouseLeave MousedOffTitle
                    ]
                    [ Html.text model.titleText.text ]
                ]
            , Html.div [] (View.viewSections model)
            ]
        ]
    }


generateRandomIntList : Random.Generator (List Int)
generateRandomIntList =
    Random.list 619 (Random.int 0 100)
