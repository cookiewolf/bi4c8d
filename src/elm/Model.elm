module Model exposing (Model, TerminalState, TitleText)

import AssocList
import Chart.Item
import Data
import Html
import InView
import Msg
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
    { text : List (Html.Html Msg.Msg)
    , animationRunningTime : Int
    , insertPosition : Int
    , insertCharacter : Char
    , changeBool : Bool
    }


type alias TerminalState =
    { input : String, history : List String }
