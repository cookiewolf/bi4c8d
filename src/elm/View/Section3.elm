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
    [ View.MainText.viewTop Data.Section5 model.content.mainText
    , Html.div
        [ Html.Attributes.class "graph-container"
        , Html.Attributes.style "min-height" (String.fromFloat (Tuple.first model.viewportHeightWidth) ++ "px")
        ]
        [ Html.div [ Html.Attributes.class "chart" ] [ viewChart model ]
        ]
    , View.MainText.viewBottom Data.Section5 model.content.mainText
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
        , Chart.Attributes.domain
            [ Chart.Attributes.lowest 25 Chart.Attributes.exactly
            , Chart.Attributes.highest 55 Chart.Attributes.exactly
            ]
        , Chart.Events.onMouseMove Msg.OnChartHover
            (Chart.Events.getNearest Chart.Item.dots)
        , Chart.Events.onMouseLeave (Msg.OnChartHover [])
        ]
        [ Chart.labelAt (Chart.Attributes.percent 50)
            (Chart.Attributes.percent 115)
            [ Chart.Attributes.fontSize 20
            , Chart.Attributes.color "#FFFFFF"
            ]
            [ Svg.text graph.title ]
        , Chart.xAxis [ Chart.Attributes.color "#FFFFFF" ]
        , Chart.yLabels
            [ Chart.Attributes.format (\yLabel -> "£" ++ String.fromFloat yLabel ++ " mil")
            , Chart.Attributes.color "#FFFFFF"
            ]
        , Chart.generate 20 (Chart.Svg.times Time.utc) .x [] <|
            \_ info ->
                [ Chart.xLabel
                    [ Chart.Attributes.x (toFloat <| Time.posixToMillis info.timestamp)
                    , Chart.Attributes.withGrid
                    , Chart.Attributes.color "#FFFFFF"
                    ]
                    [ Svg.text (formatFullTime Time.utc info.timestamp) ]
                ]
        , Chart.series .x
            ([ Chart.interpolatedMaybe (\item -> item.y1.count)
                [ Chart.Attributes.color "#E4003B" ]
                [ Chart.Attributes.color "#E40038"
                , Chart.Attributes.circle
                , Chart.Attributes.size 4
                ]
                |> Chart.named (Maybe.withDefault "" graph.set1Label)
             ]
                ++ (case graph.set2Label of
                        Just aLabel ->
                            [ Chart.interpolatedMaybe (\item -> item.y2.count)
                                [ Chart.Attributes.color "#0087DC" ]
                                [ Chart.Attributes.color "#0087DC"
                                , Chart.Attributes.circle
                                , Chart.Attributes.size 4
                                ]
                                |> Chart.named aLabel
                            ]

                        Nothing ->
                            []
                   )
                ++ (case graph.set3Label of
                        Just aLabel ->
                            [ Chart.interpolatedMaybe (\item -> item.y3.count)
                                []
                                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                                |> Chart.named aLabel
                            ]

                        Nothing ->
                            []
                   )
                ++ (case graph.set4Label of
                        Just aLabel ->
                            [ Chart.interpolatedMaybe (\item -> item.y4.count)
                                []
                                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                                |> Chart.named aLabel
                            ]

                        Nothing ->
                            []
                   )
                ++ (case graph.set5Label of
                        Just aLabel ->
                            [ Chart.interpolatedMaybe (\item -> item.y5.count)
                                []
                                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                                |> Chart.named aLabel
                            ]

                        Nothing ->
                            []
                   )
                ++ (case graph.set6Label of
                        Just aLabel ->
                            [ Chart.interpolatedMaybe (\item -> item.y6.count)
                                []
                                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                                |> Chart.named aLabel
                            ]

                        Nothing ->
                            []
                   )
                ++ (case graph.set7Label of
                        Just aLabel ->
                            [ Chart.interpolatedMaybe (\item -> item.y7.count)
                                []
                                [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                                |> Chart.named aLabel
                            ]

                        Nothing ->
                            []
                   )
            )
            graph.dataPoints
        , Chart.legendsAt .min
            .max
            [ Chart.Attributes.row
            , Chart.Attributes.moveRight 50
            , Chart.Attributes.spacing 15
            , Chart.Attributes.moveUp 25
            ]
            []
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
    String.fromInt (Time.toYear timezone posix)
