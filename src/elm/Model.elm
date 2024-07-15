module Model exposing (Model, TerminalState)

import Chart.Item
import Data
import InView
import Pile
import Time


type alias Model =
    { time : Time.Posix
    , content : Data.Content
    , tickerState : List Data.TickerState
    , breachCount : Int
    , randomIntList : List Int
    , inView : InView.State
    , viewportHeightWidth : ( Float, Float )
    , chartHovering : List (Chart.Item.One Data.LineChartDatum Chart.Item.Dot)
    , terminalState : TerminalState
    , pile1 : Pile.Model
    , pile2 : Pile.Model
    , pile3 : Pile.Model
    }


type alias TerminalState =
    { input : String, history : List String }
