module Msg exposing (Msg(..))

import Browser.Dom
import Chart.Item
import Data
import InView
import Time


type Msg
    = Tick Time.Posix
    | NewRandomIntList (List Int)
    | OnScroll { x : Float, y : Float }
    | InViewMsg InView.Msg
    | GotViewport Browser.Dom.Viewport
    | OnElementLoad String
    | OnChartHover (List (Chart.Item.One Data.LineChartDatum Chart.Item.Dot))
    | SubmitCommand String
