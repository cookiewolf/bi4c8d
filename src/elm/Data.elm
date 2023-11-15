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
    , y1 : YPoint
    , y2 : YPoint
    , y3 : YPoint
    , y4 : YPoint
    , y5 : YPoint
    , y6 : YPoint
    , y7 : YPoint
    }


type alias YPoint =
    { tooltip : String, count : Maybe Float }


type SectionId
    = SectionInvalid
    | Section1
    | Section2
    | Section3
    | Section4
    | Section5
    | Section6


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
        (Json.Decode.field "datapoints" (Json.Decode.list datapointDecoder))


datapointDecoder : Json.Decode.Decoder LineChartDatum
datapointDecoder =
    Json.Decode.map8 LineChartDatum
        (Json.Decode.field "date" Json.Decode.string
            |> Json.Decode.andThen floatFromIsoStringDecoder
        )
        (Json.Decode.field "data" (yPointDecoder ( "count1", "tooltip1" )))
        (Json.Decode.field "data" (yPointDecoder ( "count2", "tooltip2" )))
        (Json.Decode.field "data" (yPointDecoder ( "count3", "tooltip3" )))
        (Json.Decode.field "data" (yPointDecoder ( "count4", "tooltip4" )))
        (Json.Decode.field "data" (yPointDecoder ( "count5", "tooltip5" )))
        (Json.Decode.field "data" (yPointDecoder ( "count6", "tooltip6" )))
        (Json.Decode.field "data" (yPointDecoder ( "count7", "tooltip7" )))


yPointDecoder : ( String, String ) -> Json.Decode.Decoder YPoint
yPointDecoder ( countField, tooltipField ) =
    Json.Decode.map2 YPoint
        (Json.Decode.maybe (Json.Decode.field tooltipField Json.Decode.string)
            |> Json.Decode.andThen tooltipFromMaybe
        )
        (Json.Decode.maybe (Json.Decode.field countField Json.Decode.float))


tooltipFromMaybe : Maybe String -> Json.Decode.Decoder String
tooltipFromMaybe maybeTooltip =
    Json.Decode.succeed (Maybe.withDefault "" maybeTooltip)



-- Helpers


posixFromStringDecoder : String -> Json.Decode.Decoder Time.Posix
posixFromStringDecoder dateString =
    case Iso8601.toTime dateString of
        Ok aDatetime ->
            Json.Decode.succeed aDatetime

        Err _ ->
            Json.Decode.succeed (Time.millisToPosix 0)


floatFromIsoStringDecoder : String -> Json.Decode.Decoder Float
floatFromIsoStringDecoder dateString =
    case Iso8601.toTime dateString of
        Ok aDatetime ->
            Json.Decode.succeed (toFloat (Time.posixToMillis aDatetime))

        Err _ ->
            Json.Decode.succeed 0


sectionIdFromString : String -> Json.Decode.Decoder SectionId
sectionIdFromString sectionString =
    case sectionString of
        "section-one" ->
            Json.Decode.succeed Section1

        "section-two" ->
            Json.Decode.succeed Section2

        "section-three" ->
            Json.Decode.succeed Section3

        "section-four" ->
            Json.Decode.succeed Section4

        "section-five" ->
            Json.Decode.succeed Section5

        "section-six" ->
            Json.Decode.succeed Section6

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

        Section4 ->
            "section-four"

        Section5 ->
            "section-five"

        Section6 ->
            "section-six"

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
    { set1Label = "Empty test data"
    , set2Label = ""
    , set3Label = ""
    , set4Label = ""
    , set5Label = ""
    , set6Label = ""
    , set7Label = ""
    , dataPoints =
        []
    }


posixToFloatFromString : String -> Float
posixToFloatFromString dateString =
    case Iso8601.toTime dateString of
        Ok aDatetime ->
            toFloat (Time.posixToMillis aDatetime)

        Err _ ->
            toFloat 0
