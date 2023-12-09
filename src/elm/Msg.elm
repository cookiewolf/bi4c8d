module Msg exposing (Msg(..))

import Chart.Item
import Data
import InView
import Time


type Msg
    = Tick Time.Posix
    | NewRandomIntList (List Int)
    | OnScroll { x : Float, y : Float }
    | InViewMsg InView.Msg
    | OnElementLoad String
    | OnChartHover (List (Chart.Item.One Data.LineChartDatum Chart.Item.Dot))
