module Data exposing (Content, Flags, Image, LineChartDatum, MainText, Message, Post, SectionId(..), Terminal, TickerState, decodedContent, filterBySection, initialTickerState, lineChartData, sideToString, trackableIdFromItem, trackableIdListFromFlags, updateTickerState)

import Dict
import Iso8601
import Json.Decode
import Time


type alias Content =
    { mainText : List MainText
    , posts : List Post
    , messages : List Message
    , images : List Image
    , graphs : List Graph
    , terminals : List Terminal
    , tickers : List Ticker
    }


type alias Flags =
    Json.Decode.Value


type alias MainText =
    { section : SectionId
    , title : String
    , body : String
    }


type alias Post =
    { section : SectionId
    , datetime : Time.Posix
    , forwardedFrom : String
    , viewCount : Int
    , avatarSrc : String
    , maybeVideo : Maybe String
    , body : String
    }


type alias Message =
    { section : SectionId
    , side : Side
    , datetime : Time.Posix
    , body : String
    }


type Side
    = Left
    | Right


type alias Image =
    { section : SectionId
    , source : String
    , alt : String
    , displayPosition : Int
    }


type alias Graph =
    { title : String
    , set1Label : Maybe String
    , set2Label : Maybe String
    , set3Label : Maybe String
    , set4Label : Maybe String
    , set5Label : Maybe String
    , set6Label : Maybe String
    , set7Label : Maybe String
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


type alias Terminal =
    { welcomeMessage : String, prompt : String }


type alias Ticker =
    { id : Int, label : String, total : Int }


type alias TickerState =
    { id : Int, label : String, count : Int, limit : Int }


type SectionId
    = SectionInvalid
    | Section1
    | Section2
    | Section3
    | Section4
    | Section5
    | Section6
    | Section7
    | Section8
    | Section9
    | Section10
    | Section11


decodedContent : Json.Decode.Value -> Content
decodedContent flags =
    case Json.Decode.decodeValue flagsDecoder flags of
        Ok goodContent ->
            { goodContent
                | posts = orderPostsByDatetime goodContent.posts
                , images = orderByDisplayPosition goodContent.images
            }

        Err error ->
            { mainText = []
            , posts = []
            , messages = []
            , images = []
            , graphs = []
            , terminals = []
            , tickers = []
            }


orderPostsByDatetime : List Post -> List Post
orderPostsByDatetime posts =
    List.sortBy (\post -> Time.posixToMillis post.datetime) posts


orderByDisplayPosition : List { a | displayPosition : Int } -> List { a | displayPosition : Int }
orderByDisplayPosition items =
    List.sortBy .displayPosition items


flagsDecoder : Json.Decode.Decoder Content
flagsDecoder =
    Json.Decode.map7
        Content
        (Json.Decode.field "main-text" mainTextDictDecoder)
        (Json.Decode.field "posts" postDictDecoder)
        (Json.Decode.field "messages" messageDictDecoder)
        (Json.Decode.field "images" imageDictDecoder)
        (Json.Decode.field "graphs" graphDictDecoder)
        (Json.Decode.field "terminals" terminalDictDecoder)
        (Json.Decode.field "tickers" tickerDictDecoder)


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
    Json.Decode.map4 Message
        (Json.Decode.field "section" Json.Decode.string
            |> Json.Decode.andThen sectionIdFromString
        )
        (Json.Decode.field "side" Json.Decode.string
            |> Json.Decode.andThen sideFromString
        )
        (Json.Decode.field "datetime" Json.Decode.string
            |> Json.Decode.andThen posixFromStringDecoder
        )
        (Json.Decode.field "content" Json.Decode.string)


postDictDecoder : Json.Decode.Decoder (List Post)
postDictDecoder =
    Json.Decode.dict postDecoder
        |> Json.Decode.map Dict.toList
        |> Json.Decode.map (\keyedItems -> List.map (\( _, post ) -> post) keyedItems)


postDecoder : Json.Decode.Decoder Post
postDecoder =
    Json.Decode.map7 Post
        (Json.Decode.field "section" Json.Decode.string
            |> Json.Decode.andThen sectionIdFromString
        )
        (Json.Decode.field "datetime" Json.Decode.string
            |> Json.Decode.andThen posixFromStringDecoder
        )
        (Json.Decode.field "forwarded-from" Json.Decode.string)
        (Json.Decode.field "view-count" Json.Decode.int)
        (Json.Decode.field "avatar-src" Json.Decode.string)
        (Json.Decode.maybe (Json.Decode.field "video-src" Json.Decode.string))
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
    Json.Decode.succeed Graph
        |> andMap (Json.Decode.field "title" Json.Decode.string)
        |> andMap (Json.Decode.maybe (Json.Decode.field "label1" Json.Decode.string))
        |> andMap (Json.Decode.maybe (Json.Decode.field "label2" Json.Decode.string))
        |> andMap (Json.Decode.maybe (Json.Decode.field "label3" Json.Decode.string))
        |> andMap (Json.Decode.maybe (Json.Decode.field "label4" Json.Decode.string))
        |> andMap (Json.Decode.maybe (Json.Decode.field "label5" Json.Decode.string))
        |> andMap (Json.Decode.maybe (Json.Decode.field "label6" Json.Decode.string))
        |> andMap (Json.Decode.maybe (Json.Decode.field "label7" Json.Decode.string))
        |> andMap (Json.Decode.field "datapoints" (Json.Decode.list datapointDecoder))


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
            |> Json.Decode.andThen emptyStringFromMaybe
        )
        (Json.Decode.maybe (Json.Decode.field countField Json.Decode.float))


emptyStringFromMaybe : Maybe String -> Json.Decode.Decoder String
emptyStringFromMaybe maybeTooltip =
    Json.Decode.succeed (Maybe.withDefault "" maybeTooltip)


terminalDictDecoder : Json.Decode.Decoder (List Terminal)
terminalDictDecoder =
    Json.Decode.dict terminalDecoder
        |> Json.Decode.map Dict.toList
        |> Json.Decode.map (\keyedItems -> List.map (\( _, terminal ) -> terminal) keyedItems)


terminalDecoder : Json.Decode.Decoder Terminal
terminalDecoder =
    Json.Decode.map2 Terminal
        (Json.Decode.field "welcome-message" Json.Decode.string)
        (Json.Decode.field "prompt" Json.Decode.string)


tickerDictDecoder : Json.Decode.Decoder (List Ticker)
tickerDictDecoder =
    Json.Decode.dict tickerDecoder
        |> Json.Decode.map Dict.toList
        |> Json.Decode.map
            (\keyedItems ->
                List.indexedMap (\index ( _, ticker ) -> { ticker | id = index }) keyedItems
            )


tickerDecoder : Json.Decode.Decoder Ticker
tickerDecoder =
    Json.Decode.map3 Ticker
        (Json.Decode.succeed 0)
        (Json.Decode.field "label" Json.Decode.string)
        (Json.Decode.field "total" Json.Decode.int)



-- Helpers


andMap :
    Json.Decode.Decoder a
    -> Json.Decode.Decoder (a -> b)
    -> Json.Decode.Decoder b
andMap =
    Json.Decode.map2 (|>)


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

        "section-seven" ->
            Json.Decode.succeed Section7

        "section-eight" ->
            Json.Decode.succeed Section8

        "section-nine" ->
            Json.Decode.succeed Section9

        "section-ten" ->
            Json.Decode.succeed Section10

        "section-eleven" ->
            Json.Decode.succeed Section11

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

        Section7 ->
            "section-seven"

        Section8 ->
            "section-eight"

        Section9 ->
            "section-nine"

        Section10 ->
            "section-ten"

        Section11 ->
            "section-eleven"

        SectionInvalid ->
            "section-invalid"


filterBySection :
    SectionId
    -> List { item | section : SectionId }
    -> List { item | section : SectionId }
filterBySection sectionId itemList =
    List.filter (\item -> item.section == sectionId) itemList


sideFromString : String -> Json.Decode.Decoder Side
sideFromString side =
    case side of
        "right" ->
            Json.Decode.succeed Right

        _ ->
            Json.Decode.succeed Left


sideToString : Side -> String
sideToString side =
    case side of
        Right ->
            "right"

        Left ->
            "left"



-- TRACKABLE element helpers
-- TODO not in use but will be for section 5


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
    { title = "Empty test data"
    , set1Label = Nothing
    , set2Label = Nothing
    , set3Label = Nothing
    , set4Label = Nothing
    , set5Label = Nothing
    , set6Label = Nothing
    , set7Label = Nothing
    , dataPoints =
        []
    }



-- Ticker state helpers


initialTickerState : Flags -> List TickerState
initialTickerState flags =
    (decodedContent flags).tickers
        |> List.map (\ticker -> { id = ticker.id, count = 0, label = ticker.label, limit = ticker.total })


updateTickerState : TickerState -> TickerState
updateTickerState tickerState =
    { tickerState
        | count =
            if tickerState.count < tickerState.limit then
                tickerState.count + 1

            else
                tickerState.count
    }
