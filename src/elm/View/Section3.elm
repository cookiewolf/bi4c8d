module View.Section3 exposing (view)

import Chart
import Chart.Attributes
import Chart.Events
import Chart.Item
import Chart.Svg
import Copy.Text
import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import Svg
import Time
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 [] [ Html.text "Section 3" ]
    , View.MainText.view Data.Section3 model.content.mainText
    , Html.div [] [ viewChart model ]
    ]


viewChart : Model -> Html.Html Msg
viewChart model =
    let
        dateRangeStart =
            toFloat 1612137600000

        dateRangeEnd =
            toFloat 1627776000000
    in
    Chart.chart
        [ Chart.Attributes.height 300
        , Chart.Attributes.width 600
        , Chart.Attributes.range
            [ Chart.Attributes.lowest dateRangeStart Chart.Attributes.exactly
            , Chart.Attributes.highest dateRangeEnd Chart.Attributes.exactly
            ]
        , Chart.Events.onMouseMove Msg.OnChartHover (Chart.Events.getNearest Chart.Item.dots)
        , Chart.Events.onMouseLeave (Msg.OnChartHover [])
        ]
        [ Chart.xAxis []
        , Chart.yLabels []
        , Chart.generate 8 (Chart.Svg.times Time.utc) .x [] <|
            \_ info ->
                [ Chart.xLabel
                    [ Chart.Attributes.x (toFloat <| Time.posixToMillis info.timestamp)
                    , Chart.Attributes.withGrid
                    ]
                    [ Svg.text (formatFullTime Time.utc info.timestamp) ]
                ]
        , Chart.series .x
            [ Chart.interpolatedMaybe .y1
                []
                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                |> Chart.named Data.lineChartData.set1Label
            , Chart.interpolatedMaybe .y2
                []
                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                |> Chart.named Data.lineChartData.set2Label
            ]
            Data.lineChartData.dataPoints
        , Chart.legendsAt .min
            .max
            [ Chart.Attributes.column
            , Chart.Attributes.moveRight 15
            , Chart.Attributes.spacing 5
            ]
            [ Chart.Attributes.width 20 ]
        , Chart.each model.chartHovering <|
            \_ item ->
                [ Chart.tooltip item [] [] [] ]
        ]


formatFullTime : Time.Zone -> Time.Posix -> String
formatFullTime timezone posix =
    String.join ""
        [ Copy.Text.monthToString (Time.toMonth timezone posix)
        ]
