module Model exposing (MenuItem(..), Model, TerminalState)

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
    = Intro
    | Content
    | ProjectInfo


type alias TerminalState =
    { input : String, history : List String }
