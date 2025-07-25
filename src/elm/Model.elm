module Model exposing (MenuItem(..), Model, TerminalState, menuItemFromUrl, menuItemToString, menuItemToUrlString, pageOrderList)

import AssocList
import Chart.Item
import Data
import InView
import Pile
import Time
import Url
import Url.Builder


type alias Model =
    { time : Time.Posix
    , content : Data.Content
    , currentView : MenuItem
    , tickerState : List Data.TickerState
    , breachCount : Int
    , randomIntList : List Int
    , inView : InView.State
    , viewportHeightWidth : ( Float, Float )
    , chartHovering : List (Chart.Item.One Data.LineChartDatum Chart.Item.Dot)
    , terminalState : AssocList.Dict Data.SectionId TerminalState
    , piles : Pile.Model
    , domHeight : Float
    }


type MenuItem
    = ProjectInfo
    | Page1
    | Page2
    | Page3
    | Page4
    | Page5
    | Page6
    | Page7


pageOrderList : List MenuItem
pageOrderList =
    [ Page1, Page2, Page3, Page4, Page5, Page6, Page7 ]


menuItemToString : MenuItem -> String
menuItemToString menuItem =
    case menuItem of
        ProjectInfo ->
            "Project Information"

        Page1 ->
            "1"

        Page2 ->
            "2"

        Page3 ->
            "3"

        Page4 ->
            "4"

        Page5 ->
            "5"

        Page6 ->
            "6"

        Page7 ->
            "7"


menuItemToUrlString : MenuItem -> String
menuItemToUrlString menuItem =
    Url.Builder.absolute []
        [ Url.Builder.string "page"
            (menuItemToString menuItem
                |> String.toLower
                |> String.replace " " "-"
            )
        ]


menuItemFromUrl : Maybe Url.Url -> MenuItem
menuItemFromUrl maybeUrl =
    case maybeUrl of
        Just url ->
            case url.query of
                Just queryString ->
                    menuItemFromQueryString queryString

                Nothing ->
                    Page1

        Nothing ->
            Page1


menuItemFromQueryString : String -> MenuItem
menuItemFromQueryString queryString =
    let
        pageString : String
        pageString =
            String.replace "page=" "" queryString
    in
    case pageString of
        "project-info" ->
            ProjectInfo

        "project-information" ->
            ProjectInfo

        "1" ->
            Page1

        "2" ->
            Page2

        "3" ->
            Page3

        "4" ->
            Page4

        "5" ->
            Page5

        "6" ->
            Page6

        "7" ->
            Page7

        _ ->
            Page1


type alias TerminalState =
    { input : String, history : List String }
