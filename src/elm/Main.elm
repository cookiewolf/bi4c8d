port module Main exposing (main)

import Browser
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import InView
import Model exposing (Model)
import Msg exposing (Msg(..))
import Random
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
        trackableImages =
            Data.trackableIdListFromFlags flags

        trackableSections =
            [ "section-8" ]

        ( inViewModel, inViewCmds ) =
            InView.init InViewMsg (trackableImages ++ trackableSections)
    in
    ( { content = Data.decodedContent flags
      , randomIntList = []
      , inView = inViewModel
      , chartHovering = []
      }
    , Cmd.batch
        [ Random.generate NewRandomIntList generateRandomIntList
        , inViewCmds
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ InView.subscriptions InViewMsg model.inView
        , onScroll OnScroll
        ]


update msg model =
    case msg of
        NewRandomIntList newRandomIntList ->
            ( { model | randomIntList = newRandomIntList }
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
            (View.viewSections model)
        ]
    }


generateRandomIntList : Random.Generator (List Int)
generateRandomIntList =
    Random.list 865 (Random.int 0 100)
