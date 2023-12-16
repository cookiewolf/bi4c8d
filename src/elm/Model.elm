module Model exposing (Model)

import Chart.Item
import Data
import InView
import Time


type alias Model =
    { time : Time.Posix
    , content : Data.Content
    , tickerState : List Data.TickerState
    , randomIntList : List Int
    , inView : InView.State
    , viewportHeightWidth : ( Float, Float )
    , chartHovering : List (Chart.Item.One Data.LineChartDatum Chart.Item.Dot)
    }
