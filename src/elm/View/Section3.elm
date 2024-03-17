module View.Section3 exposing (view)

import Chart
import Chart.Attributes
import Chart.Events
import Chart.Item
import Chart.Svg
import Copy.Text
import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import Svg
import Time
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section3 model.content.mainText
    , Html.div [ Html.Attributes.class "chart" ] [ viewChart model ]
    , View.MainText.viewBottom Data.Section3 model.content.mainText
    ]


viewChart : Model -> Html.Html Msg
viewChart model =
    let
        dateRangeStart =
            toFloat 883612800000

        dateRangeEnd =
            toFloat 1672531200000

        graph =
            List.head model.content.graphs
                |> Maybe.withDefault Data.lineChartData
    in
    Chart.chart
        [ Chart.Attributes.height 300
        , Chart.Attributes.width 600
        , Chart.Attributes.range
            [ Chart.Attributes.lowest dateRangeStart Chart.Attributes.exactly
            , Chart.Attributes.highest dateRangeEnd Chart.Attributes.exactly
            ]
        , Chart.Events.onMouseMove Msg.OnChartHover
            (Chart.Events.getNearest Chart.Item.dots)
        , Chart.Events.onMouseLeave (Msg.OnChartHover [])
        ]
        [ Chart.labelAt (Chart.Attributes.percent 50) (Chart.Attributes.percent 100) [] [ Svg.text graph.title ]
        , Chart.xAxis []
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
            [ Chart.interpolatedMaybe (\item -> item.y1.count)
                []
                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                |> Chart.named graph.set1Label
            , Chart.interpolatedMaybe (\item -> item.y2.count)
                []
                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                |> Chart.named graph.set2Label
            , Chart.interpolatedMaybe (\item -> item.y3.count)
                []
                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                |> Chart.named graph.set3Label
            , Chart.interpolatedMaybe (\item -> item.y4.count)
                []
                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                |> Chart.named graph.set4Label
            , Chart.interpolatedMaybe (\item -> item.y5.count)
                []
                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                |> Chart.named graph.set5Label
            , Chart.interpolatedMaybe (\item -> item.y6.count)
                []
                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                |> Chart.named graph.set6Label
            , Chart.interpolatedMaybe (\item -> item.y7.count)
                []
                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                |> Chart.named graph.set7Label
            ]
            graph.dataPoints
        , Chart.legendsAt .min
            .max
            [ Chart.Attributes.column
            , Chart.Attributes.spacing 5
            , Chart.Attributes.moveLeft 250
            ]
            [ Chart.Attributes.width 20 ]
        , Chart.each model.chartHovering <|
            \_ item ->
                let
                    data =
                        Chart.Item.getData item

                    y =
                        Chart.Item.getY item

                    tooltip =
                        if data.y1.count == Just y then
                            data.y1.tooltip

                        else if data.y2.count == Just y then
                            data.y2.tooltip

                        else if data.y3.count == Just y then
                            data.y3.tooltip

                        else if data.y4.count == Just y then
                            data.y4.tooltip

                        else if data.y5.count == Just y then
                            data.y5.tooltip

                        else if data.y6.count == Just y then
                            data.y6.tooltip

                        else if data.y7.count == Just y then
                            data.y7.tooltip

                        else
                            ""
                in
                if String.length tooltip > 0 then
                    [ Chart.tooltip item [] [] [ Html.text tooltip ] ]

                else
                    []
        ]


formatFullTime : Time.Zone -> Time.Posix -> String
formatFullTime timezone posix =
    String.join ""
        [ Copy.Text.monthToString (Time.toMonth timezone posix)
        ]
