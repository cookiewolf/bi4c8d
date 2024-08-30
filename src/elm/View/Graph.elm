module View.Graph exposing (view)

import Chart
import Chart.Attributes
import Chart.Events
import Chart.Item
import Chart.Svg
import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import Svg
import Time


view : Model -> Data.SectionId -> Html.Html Msg
view model sectionId =
    let
        graph : Data.Graph
        graph =
            List.head (Data.filterBySection sectionId model.content.graphs)
                |> Maybe.withDefault Data.lineChartData

        yAxisLabelPadding =
            graph.dataPoints
                |> yValueHighest
                |> round
                |> String.fromInt
                |> viewYLabel sectionId
                |> String.length
                |> (+) 2
                |> String.fromInt
                |> (\width -> width ++ "ch")
    in
    Html.div [ Html.Attributes.class "chart", Html.Attributes.style "padding-left" yAxisLabelPadding ]
        [ Chart.chart
            [ Chart.Attributes.height 300
            , Chart.Attributes.width 600
            , Chart.Attributes.range
                [ Chart.Attributes.lowest (dateRangeStart sectionId graph.dataPoints) Chart.Attributes.exactly
                , Chart.Attributes.highest (dateRangeEnd sectionId graph.dataPoints) Chart.Attributes.exactly
                ]
            , Chart.Attributes.domain
                [ Chart.Attributes.lowest (yValueLowest graph.dataPoints) Chart.Attributes.exactly
                , Chart.Attributes.highest (yValueHighest graph.dataPoints) Chart.Attributes.exactly
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
            , Chart.yAxis [ Chart.Attributes.color "#FFFFFF" ]
            , Chart.yLabels
                [ Chart.Attributes.format (\yLabel -> viewYLabel sectionId (String.fromFloat yLabel))
                , Chart.Attributes.color "#FFFFFF"
                ]
            , Chart.generate 15 (Chart.Svg.times Time.utc) .x [] <|
                \_ info ->
                    [ Chart.xLabel
                        [ Chart.Attributes.x (toFloat <| Time.posixToMillis info.timestamp)
                        , Chart.Attributes.withGrid
                        , Chart.Attributes.color "#FFFFFF"
                        ]
                        [ Svg.text (formatFullTime Time.utc info.timestamp) ]
                    ]
            , if sectionId == Data.Telegram || sectionId == Data.PublicOrderSafety then
                Chart.series .x
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
                    )
                    graph.dataPoints

              else
                Chart.series .x
                    ([ Chart.interpolatedMaybe (\item -> item.y1.count)
                        []
                        [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
                        |> Chart.named (Maybe.withDefault "" graph.set1Label)
                     ]
                        ++ (case graph.set2Label of
                                Just aLabel ->
                                    [ Chart.interpolatedMaybe (\item -> item.y2.count)
                                        []
                                        [ Chart.Attributes.circle, Chart.Attributes.size 3 ]
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
                [ Chart.Attributes.moveRight 50
                , Chart.Attributes.spacing 15
                , Chart.Attributes.moveUp 25
                , Chart.Attributes.htmlAttrs [ Html.Attributes.class "chart-legend" ]
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
        ]


viewYLabel : Data.SectionId -> String -> String
viewYLabel section yValueString =
    case section of
        Data.PublicTrust ->
            yValueString ++ "%"

        Data.Telegram ->
            yValueString

        Data.PublicOrderSafety ->
            "£" ++ yValueString ++ " mil"

        _ ->
            yValueString


allDates : List Data.LineChartDatum -> List Float
allDates dataPoints =
    List.map .x dataPoints
        |> List.sort


dateRangeStart : Data.SectionId -> List Data.LineChartDatum -> Float
dateRangeStart id dataPoints =
    List.head (allDates dataPoints)
        |> Maybe.withDefault (toFloat 883612800000)
        |> floorDate id


dateRangeEnd : Data.SectionId -> List Data.LineChartDatum -> Float
dateRangeEnd id dataPoints =
    List.reverse (allDates dataPoints)
        |> List.head
        |> Maybe.withDefault (toFloat 1672531200000)
        |> ceilingDate id


oneYearInMillis : Int
oneYearInMillis =
    31556952000


oneWeekInMillis : Int
oneWeekInMillis =
    604800000


floorDate : Data.SectionId -> Float -> Float
floorDate id millis =
    let
        unit =
            if id == Data.Telegram then
                oneWeekInMillis

            else
                oneYearInMillis
    in
    millis
        |> floor
        |> (\time -> time // unit)
        |> (\units -> units * unit)
        |> (\val -> val - unit)
        |> toFloat


ceilingDate : Data.SectionId -> Float -> Float
ceilingDate id millis =
    let
        unit =
            if id == Data.Telegram then
                oneWeekInMillis

            else
                oneYearInMillis
    in
    millis
        |> floor
        |> (\time -> time // unit)
        |> (\units -> units * unit)
        |> (+) unit
        |> toFloat


allYValues : List Data.LineChartDatum -> List Float
allYValues dataPoints =
    List.map (\dataPoint -> countFromYPoint dataPoint.y1) dataPoints
        ++ List.map (\dataPoint -> countFromYPoint dataPoint.y2) dataPoints
        ++ List.map (\dataPoint -> countFromYPoint dataPoint.y3) dataPoints
        ++ List.map (\dataPoint -> countFromYPoint dataPoint.y4) dataPoints
        ++ List.map (\dataPoint -> countFromYPoint dataPoint.y5) dataPoints
        ++ List.map (\dataPoint -> countFromYPoint dataPoint.y6) dataPoints
        ++ List.map (\dataPoint -> countFromYPoint dataPoint.y7) dataPoints
        |> List.concat
        |> List.sort


countFromYPoint : Data.YPoint -> List Float
countFromYPoint yPoint =
    case yPoint.count of
        Just aCount ->
            [ aCount ]

        Nothing ->
            []


yValueLowest : List Data.LineChartDatum -> Float
yValueLowest dataPoints =
    List.head (allYValues dataPoints)
        |> Maybe.withDefault (toFloat 0)
        |> minusTenPercent


yValueHighest : List Data.LineChartDatum -> Float
yValueHighest dataPoints =
    List.reverse (allYValues dataPoints)
        |> List.head
        |> Maybe.withDefault (toFloat 100)
        |> plusTenPercent


minusTenPercent : Float -> Float
minusTenPercent count =
    count - (count * 0.1)


plusTenPercent : Float -> Float
plusTenPercent count =
    count + (count * 0.1)


formatFullTime : Time.Zone -> Time.Posix -> String
formatFullTime timezone posix =
    String.fromInt (Time.toYear timezone posix)
