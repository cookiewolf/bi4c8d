module Data exposing (Content, Flags, Image, LineChartDatum, MainText, Message, SectionId(..), decodedContent, filterBySection, lineChartData, trackableIdFromItem, trackableIdListFromFlags)

import Dict
import Iso8601
import Json.Decode
import Time


type alias Content =
    { mainText : List MainText
    , messages : List Message
    , images : List Image
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


type alias LineChartData =
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
    , y1 : { tooltip : String, count : Maybe Float }
    , y2 : { tooltip : String, count : Maybe Float }
    , y3 : { tooltip : String, count : Maybe Float }
    , y4 : { tooltip : String, count : Maybe Float }
    , y5 : { tooltip : String, count : Maybe Float }
    , y6 : { tooltip : String, count : Maybe Float }
    , y7 : { tooltip : String, count : Maybe Float }
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
            }


orderMessagesByDatetime : List Message -> List Message
orderMessagesByDatetime messages =
    List.sortBy (\message -> Time.posixToMillis message.datetime) messages


orderByDisplayPosition : List { a | displayPosition : Int } -> List { a | displayPosition : Int }
orderByDisplayPosition items =
    List.sortBy .displayPosition items


flagsDecoder : Json.Decode.Decoder Content
flagsDecoder =
    Json.Decode.map3
        Content
        (Json.Decode.field "main-text" mainTextDictDecoder)
        (Json.Decode.field "messages" messageDictDecoder)
        (Json.Decode.field "images" imageDictDecoder)


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


lineChartData : LineChartData
lineChartData =
    { set1Label = "COVID-19 Agenda"
    , set2Label = "UK – No Mandatory Vaccines – Medical Freedom"
    , set3Label = "Third test set"
    , set4Label = ""
    , set5Label = ""
    , set6Label = ""
    , set7Label = ""
    , dataPoints =
        [ { x = posixToFloatFromString "2021-02-17"
          , y1 = { tooltip = "Tooltip for set 1 3173", count = Just (toFloat 3173) }
          , y2 = { tooltip = "Tooltip for set 2 1142", count = Just (toFloat 1142) }
          , y3 = { tooltip = "Tooltip for set 3 Nothing", count = Nothing }
          , y4 = { tooltip = "", count = Nothing }
          , y5 = { tooltip = "", count = Nothing }
          , y6 = { tooltip = "", count = Nothing }
          , y7 = { tooltip = "", count = Nothing }
          }
        , { x = posixToFloatFromString "2021-02-24"
          , y1 = { tooltip = "Tooltip for set 1 3255", count = Just (toFloat 3255) }
          , y2 = { tooltip = "", count = Just (toFloat 1263) }
          , y3 = { tooltip = "Tooltip for set 3 2000", count = Just (toFloat 2000) }
          , y4 = { tooltip = "", count = Nothing }
          , y5 = { tooltip = "", count = Nothing }
          , y6 = { tooltip = "", count = Nothing }
          , y7 = { tooltip = "", count = Nothing }
          }
        , { x = posixToFloatFromString "2021-03-11"
          , y1 = { tooltip = "hello3", count = Just (toFloat 3547) }
          , y2 = { tooltip = "", count = Just (toFloat 1798) }
          , y3 = { tooltip = "Tooltip set 3 1850", count = Just (toFloat 1850) }
          , y4 = { tooltip = "", count = Nothing }
          , y5 = { tooltip = "", count = Nothing }
          , y6 = { tooltip = "", count = Nothing }
          , y7 = { tooltip = "", count = Nothing }
          }
        ]
    }


posixToFloatFromString : String -> Float
posixToFloatFromString dateString =
    case Iso8601.toTime dateString of
        Ok aDatetime ->
            toFloat (Time.posixToMillis aDatetime)

        Err _ ->
            toFloat 0
