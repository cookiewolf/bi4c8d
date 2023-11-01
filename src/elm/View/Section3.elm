module View.Section3 exposing (view)

import Chart
import Chart.Attributes
import Chart.Events
import Chart.Item
import Data
import Html
import Html.Attributes
import Html.Events
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 [] [ Html.text "Section 3" ]
    , View.MainText.view Data.Section3 model.content.mainText
    , viewChart model
    ]


viewChart : Model -> Html.Html Msg
viewChart model =
    Chart.chart
        [ Chart.Attributes.height 300
        , Chart.Attributes.width 300
        , Chart.Events.onMouseMove Msg.OnChartHover (Chart.Events.getNearest Chart.Item.dots)
        , Chart.Events.onMouseLeave (Msg.OnChartHover [])
        ]
        [ Chart.xLabels []
        , Chart.yLabels [ Chart.Attributes.withGrid ]
        , Chart.series .x
            [ Chart.interpolated .y [] [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
            , Chart.interpolated .z [] [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
            ]
            chartData
        , Chart.each model.chartHovering <|
            \p item ->
                [ Chart.tooltip item [] [] [] ]
        ]


chartData : List Data.ChartDatum
chartData =
    []
