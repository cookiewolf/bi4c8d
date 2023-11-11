module Data exposing (Content, Flags, Image, LineChartDatum, MainText, Message, SectionId(..), decodedContent, filterBySection, lineChartData, trackableIdFromItem, trackableIdListFromFlags)

import Dict
import Iso8601
import Json.Decode
import Time


type alias Content =
    { mainText : List MainText
    , messages : List Message
    , images : List Image
    , graphs : List Graph
    }


type alias Flags =
    Json.Decode.Value


type alias MainText =
    { section : SectionId
    , title : String
    , body : String
    }


type alias Message =
    { section : SectionId
    , datetime : Time.Posix
    , forwardedFrom : String
    , viewCount : Int
    , avatarSrc : String
    , body : String
    }


type alias Image =
    { section : SectionId
    , source : String
    , alt : String
    , displayPosition : Int
    }


type alias Graph =
    { set1Label : String
    , set2Label : String
    , set3Label : String
    , set4Label : String
    , set5Label : String
    , set6Label : String
    , set7Label : String
    , dataPoints : List LineChartDatum
    }


type alias LineChartDatum =
    { x : Float
    , y1 : Maybe Float
    , y2 : Maybe Float
    , y3 : Maybe Float
    , y4 : Maybe Float
    , y5 : Maybe Float
    , y6 : Maybe Float
    , y7 : Maybe Float
    }


type SectionId
    = SectionInvalid
    | Section1
    | Section2
    | Section3


decodedContent : Json.Decode.Value -> Content
decodedContent flags =
    case Json.Decode.decodeValue flagsDecoder flags of
        Ok goodContent ->
            { goodContent
                | messages = orderMessagesByDatetime goodContent.messages
                , images = orderByDisplayPosition goodContent.images
            }

        Err _ ->
            { mainText = []
            , messages = []
            , images = []
            , graphs = []
            }


orderMessagesByDatetime : List Message -> List Message
orderMessagesByDatetime messages =
    List.sortBy (\message -> Time.posixToMillis message.datetime) messages


orderByDisplayPosition : List { a | displayPosition : Int } -> List { a | displayPosition : Int }
orderByDisplayPosition items =
    List.sortBy .displayPosition items


flagsDecoder : Json.Decode.Decoder Content
flagsDecoder =
    Json.Decode.map4
        Content
        (Json.Decode.field "main-text" mainTextDictDecoder)
        (Json.Decode.field "messages" messageDictDecoder)
        (Json.Decode.field "images" imageDictDecoder)
        (Json.Decode.field "graphs" graphDictDecoder)


mainTextDictDecoder : Json.Decode.Decoder (List MainText)
mainTextDictDecoder =
    Json.Decode.dict mainTextDecoder
        |> Json.Decode.map Dict.toList
        |> Json.Decode.map (\keyedItems -> List.map (\( _, mainText ) -> mainText) keyedItems)


mainTextDecoder : Json.Decode.Decoder MainText
mainTextDecoder =
    Json.Decode.map3
        MainText
        (Json.Decode.field "section" Json.Decode.string
            |> Json.Decode.andThen sectionIdFromString
        )
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "content" Json.Decode.string)


messageDictDecoder : Json.Decode.Decoder (List Message)
messageDictDecoder =
    Json.Decode.dict messageDecoder
        |> Json.Decode.map Dict.toList
        |> Json.Decode.map (\keyedItems -> List.map (\( _, message ) -> message) keyedItems)


messageDecoder : Json.Decode.Decoder Message
messageDecoder =
    Json.Decode.map6 Message
        (Json.Decode.field "section" Json.Decode.string
            |> Json.Decode.andThen sectionIdFromString
        )
        (Json.Decode.field "datetime" Json.Decode.string
            |> Json.Decode.andThen posixFromStringDecoder
        )
        (Json.Decode.field "forwarded-from" Json.Decode.string)
        (Json.Decode.field "view-count" Json.Decode.int)
        (Json.Decode.field "avatar-src" Json.Decode.string)
        (Json.Decode.field "content" Json.Decode.string)


imageDictDecoder : Json.Decode.Decoder (List Image)
imageDictDecoder =
    Json.Decode.dict imageDecoder
        |> Json.Decode.map Dict.toList
        |> Json.Decode.map (\keyedItems -> List.map (\( _, image ) -> image) keyedItems)


imageDecoder : Json.Decode.Decoder Image
imageDecoder =
    Json.Decode.map4 Image
        (Json.Decode.field "section" Json.Decode.string
            |> Json.Decode.andThen sectionIdFromString
        )
        (Json.Decode.field "source" Json.Decode.string)
        (Json.Decode.field "alt" Json.Decode.string)
        (Json.Decode.field "display-position" Json.Decode.int)


graphDictDecoder : Json.Decode.Decoder (List Graph)
graphDictDecoder =
    Json.Decode.dict graphDecoder
        |> Json.Decode.map Dict.toList
        |> Json.Decode.map (\keyedItems -> List.map (\( _, graph ) -> graph) keyedItems)


graphDecoder : Json.Decode.Decoder Graph
graphDecoder =
    Json.Decode.map8 Graph
        (Json.Decode.field "label1" Json.Decode.string)
        (Json.Decode.field "label2" Json.Decode.string)
        (Json.Decode.field "label3" Json.Decode.string)
        (Json.Decode.field "label4" Json.Decode.string)
        (Json.Decode.field "label5" Json.Decode.string)
        (Json.Decode.field "label6" Json.Decode.string)
        (Json.Decode.field "label7" Json.Decode.string)
        (Json.Decode.field "datapoints" datapointsDecoder)


datapointsDecoder : Json.Decode.Decoder (List LineChartDatum)
datapointsDecoder =
    Json.Decode.map2
        (Json.Decode.field "date" Json.Decode.string
            |> Json.Decode.andThen posixFromStringDecoder
        )
        (Json.Decode.field "data" lineChartDatumDecoder)


lineChartDatumDecoder : Json.Decode.Decoder LineChartDatum
lineChartDatumDecoder =
    Json.Decode.map2
        (Json.Decode.field "date" Json.Decode.float)
        (Json.Decode.field "data" lineChartYPointsDecoder)


lineChartYPointsDecoder : Json.Decode.Decoder {}
lineChartYPointsDecoder =
    Json.Decode.map2



-- Helpers


posixFromStringDecoder : String -> Json.Decode.Decoder Time.Posix
posixFromStringDecoder dateString =
    case Iso8601.toTime dateString of
        Ok aDatetime ->
            Json.Decode.succeed aDatetime

        Err _ ->
            Json.Decode.succeed (Time.millisToPosix 0)


sectionIdFromString : String -> Json.Decode.Decoder SectionId
sectionIdFromString sectionString =
    case sectionString of
        "section-one" ->
            Json.Decode.succeed Section1

        "section-two" ->
            Json.Decode.succeed Section2

        "section-three" ->
            Json.Decode.succeed Section3

        _ ->
            Json.Decode.succeed SectionInvalid


sectionIdToString : SectionId -> String
sectionIdToString sectionId =
    case sectionId of
        Section1 ->
            "section-one"

        Section2 ->
            "section-two"

        Section3 ->
            "section-three"

        SectionInvalid ->
            "section-invalid"


filterBySection :
    SectionId
    -> List { item | section : SectionId }
    -> List { item | section : SectionId }
filterBySection sectionId itemList =
    List.filter (\item -> item.section == sectionId) itemList



-- TRACKABLE element helpers


trackableIdListFromFlags : Flags -> List String
trackableIdListFromFlags flags =
    (decodedContent flags).images
        |> List.map trackableIdFromItem


trackableIdFromItem : { item | section : SectionId, displayPosition : Int } -> String
trackableIdFromItem item =
    String.join "-"
        [ sectionIdToString item.section
        , String.fromInt item.displayPosition
        ]


lineChartData : Graph
lineChartData =
    { set1Label = "COVID-19 Agenda"
    , set2Label = "UK – No Mandatory Vaccines – Medical Freedom"
    , set3Label = ""
    , set4Label = ""
    , set5Label = ""
    , set6Label = ""
    , set7Label = ""
    , dataPoints =
        [ { x = posixToFloatFromString "2021-02-17", y1 = Just (toFloat 4473), y2 = Just (toFloat 2142), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-02-24", y1 = Just (toFloat 4555), y2 = Just (toFloat 2263), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-03-11", y1 = Just (toFloat 4747), y2 = Just (toFloat 2798), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-03-17", y1 = Just (toFloat 4827), y2 = Just (toFloat 3033), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-04-06", y1 = Just (toFloat 5469), y2 = Just (toFloat 4422), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-04-13", y1 = Just (toFloat 5616), y2 = Just (toFloat 4620), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-04-21", y1 = Just (toFloat 5948), y2 = Just (toFloat 5046), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-04-27", y1 = Just (toFloat 6072), y2 = Just (toFloat 5534), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-05-05", y1 = Just (toFloat 6294), y2 = Just (toFloat 5816), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-05-20", y1 = Just (toFloat 6521), y2 = Just (toFloat 6142), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-05-30", y1 = Just (toFloat 6644), y2 = Just (toFloat 6246), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-06-05", y1 = Just (toFloat 6768), y2 = Just (toFloat 6291), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-06-17", y1 = Just (toFloat 7175), y2 = Just (toFloat 6384), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-07-01", y1 = Just (toFloat 7635), y2 = Just (toFloat 6515), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-07-06", y1 = Just (toFloat 7849), y2 = Just (toFloat 6579), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-07-15", y1 = Just (toFloat 8095), y2 = Just (toFloat 6689), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        , { x = posixToFloatFromString "2021-07-27", y1 = Just (toFloat 8840), y2 = Just (toFloat 6936), y3 = Nothing, y4 = Nothing, y5 = Nothing, y6 = Nothing, y7 = Nothing }
        ]
    }


posixToFloatFromString : String -> Float
posixToFloatFromString dateString =
    case Iso8601.toTime dateString of
        Ok aDatetime ->
            toFloat (Time.posixToMillis aDatetime)

        Err _ ->
            toFloat 0
