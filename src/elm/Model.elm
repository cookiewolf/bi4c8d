module Model exposing (MenuItem(..), Model, TerminalState, menuItemToString, pageOrderList)

import AssocList
import Chart.Item
import Data
import InView
import Pile
import Time


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
            "2"

        Page2 ->
            "3"

        Page3 ->
            "4"

        Page4 ->
            "5"

        Page5 ->
            "6"

        Page6 ->
            "7"

        Page7 ->
            "8"


type alias TerminalState =
    { input : String, history : List String }
