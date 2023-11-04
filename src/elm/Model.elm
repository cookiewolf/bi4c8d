module Model exposing (Model)

import Chart.Item
import Data
import InView


type alias Model =
    { content : Data.Content
    , inView : InView.State
    , chartHovering : List (Chart.Item.One Data.LineChartDatum Chart.Item.Dot)
    }
