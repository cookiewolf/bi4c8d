module Model exposing (Model, TerminalState, TitleText)

import AssocList
import Chart.Item
import Data
import InView
import Pile
import Time


type alias Model =
    { time : Time.Posix
    , content : Data.Content
    , titleText : TitleText
    , viewingIntro : Bool
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


type alias TitleText =
    { text : String
    , animationRunningTime : Int
    , insertPosition : Int
    , insertCharacter : Char
    }


type alias TerminalState =
    { input : String, history : List String }
