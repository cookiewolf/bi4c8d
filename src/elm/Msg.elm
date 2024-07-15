module Msg exposing (Msg(..))

import Browser.Dom
import Chart.Item
import Data
import InView
import Pile
import Time


type Msg
    = NoOp
    | Tick Time.Posix
    | NewRandomIntList (List Int)
    | OnScroll { x : Float, y : Float }
    | InViewMsg InView.Msg
    | GotViewport Browser.Dom.Viewport
    | OnElementLoad String
    | OnChartHover (List (Chart.Item.One Data.LineChartDatum Chart.Item.Dot))
    | ChangeCommand String
    | SubmitCommand String
    | ScrollResult (Result Browser.Dom.Error ())
    | Pile1 Pile.Msg
    | Pile2 Pile.Msg
