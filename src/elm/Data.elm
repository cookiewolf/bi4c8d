module Data exposing (Command, Content, Context, Flags, Graph, Image, LineChartDatum, MainText, Message, Post, SectionId(..), Terminal, TickerState, YPoint, decodedContent, defaultCommand, filterBySection, initialTickerState, lineChartData, sectionIdToInt, sectionIdToString, sectionsFromPage, sideToString, updateTickerState, urlContainsHash)

import Dict
import Iso8601
import Json.Decode
import Time


type alias Content =
    { url : String
    , context : List Context
    , mainText : List MainText
    , posts : List Post
    , messages : List Message
    , images : List Image
    , graphs : List Graph
    , terminals : List Terminal
    , tickers : List Ticker
    }


type alias Flags =
    Json.Decode.Value


type alias Context =
    { section : SectionId
    , maybeContext : Maybe String
    , maybeFactCheck : Maybe String
    , references : List String
    }


type alias MainText =
    { section : SectionId
    , title : String
    , body : String
    }


type alias Post =
    { section : SectionId
    , datetime : Time.Posix
    , forwardedFrom : String
    , maybeViewCount : Maybe Int
    , avatarSrc : String
    , maybeVideo : Maybe String
    , body : String
    }


type alias Message =
    { section : SectionId
    , side : Side
    , maybeAvatarSrc : Maybe String
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
    { section : SectionId
    , title : String
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
    { section : SectionId
    , terminalId : String
    , welcomeMessage : String
    , prompt : String
    , commandList : List Command
    }


type alias Command =
    { name : String, helpText : String, output : String, subCommands : List String }


defaultCommand : Command
defaultCommand =
    { helpText = ""
    , name = ""
    , output = ""
    , subCommands = []
    }


type alias Ticker =
    { id : Int, label : String, total : Int }


type alias TickerState =
    { id : Int, label : String, count : Int, limit : Int }


type SectionId
    = SectionInvalid
    | Introduction
    | SocialMediaPosts
    | PublicTrust
    | Telegram
    | UlteriorMotives
    | PanicLit
    | PublicOrderSafety
    | DisproportionateEssayEnd
    | FacialRecognition
    | IncompetenceIntro
    | IncompetencePostsAndPapers
    | HmrcTerminal
    | DataLoss
    | RansomwareTerminal
    | HumanCost
    | RoyalMailNegotiation
    | HackneySocial
    | Outro
    | ProjectInfo


decodedContent : Json.Decode.Value -> Content
decodedContent flags =
    case Json.Decode.decodeValue flagsDecoder flags of
        Ok goodContent ->
            { goodContent
                | context = orderBySectionId goodContent.context
                , posts = orderPostsByDatetime goodContent.posts
                , messages = orderMessagesByDatetime goodContent.messages
                , images = orderByDisplayPosition goodContent.images
            }

        Err _ ->
            { url = ""
            , context = []
            , mainText = []
            , posts = []
            , messages = []
            , images = []
            , graphs = []
            , terminals = []
            , tickers = []
            }


orderBySectionId : List { a | section : SectionId } -> List { a | section : SectionId }
orderBySectionId items =
    List.sortBy (\item -> sectionIdToInt item.section) items


orderPostsByDatetime : List Post -> List Post
orderPostsByDatetime posts =
    List.sortBy (\post -> Time.posixToMillis post.datetime) posts


orderMessagesByDatetime : List Message -> List Message
orderMessagesByDatetime messages =
    List.sortBy (\message -> Time.posixToMillis message.datetime) messages


orderByDisplayPosition : List { a | displayPosition : Int } -> List { a | displayPosition : Int }
orderByDisplayPosition items =
    List.sortBy .displayPosition items


flagsDecoder : Json.Decode.Decoder Content
flagsDecoder =
    Json.Decode.succeed Content
        |> andMap (Json.Decode.field "url" Json.Decode.string)
        |> andMap (Json.Decode.field "context" contextDictDecoder)
        |> andMap (Json.Decode.field "main-text" mainTextDictDecoder)
        |> andMap (Json.Decode.field "posts" postDictDecoder)
        |> andMap (Json.Decode.field "messages" messageDictDecoder)
        |> andMap (Json.Decode.field "images" imageDictDecoder)
        |> andMap (Json.Decode.field "graphs" graphDictDecoder)
        |> andMap (Json.Decode.field "terminals" terminalDictDecoder)
        |> andMap (Json.Decode.field "tickers" tickerDictDecoder)


contextDictDecoder : Json.Decode.Decoder (List Context)
contextDictDecoder =
    Json.Decode.dict contextDecoder
        |> Json.Decode.map Dict.toList
        |> Json.Decode.map (\keyedItems -> List.map (\( _, context ) -> context) keyedItems)


mainTextDictDecoder : Json.Decode.Decoder (List MainText)
mainTextDictDecoder =
    Json.Decode.dict mainTextDecoder
        |> Json.Decode.map Dict.toList
        |> Json.Decode.map (\keyedItems -> List.map (\( _, mainText ) -> mainText) keyedItems)


contextDecoder : Json.Decode.Decoder Context
contextDecoder =
    Json.Decode.map4
        Context
        (Json.Decode.field "section" Json.Decode.string
            |> Json.Decode.andThen sectionIdFromString
        )
        (Json.Decode.field "context" Json.Decode.string
            |> Json.Decode.maybe
            |> Json.Decode.map
                (Maybe.andThen
                    (\context ->
                        if context == "" then
                            Nothing

                        else
                            Just context
                    )
                )
        )
        (Json.Decode.maybe (Json.Decode.field "fact-check" Json.Decode.string))
        (Json.Decode.maybe (Json.Decode.field "references" (Json.Decode.list <| Json.Decode.field "reference" Json.Decode.string))
            |> Json.Decode.andThen emptyListFromMaybe
        )


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
    Json.Decode.map5 Message
        (Json.Decode.field "section" Json.Decode.string
            |> Json.Decode.andThen sectionIdFromString
        )
        (Json.Decode.field "side" Json.Decode.string
            |> Json.Decode.andThen sideFromString
        )
        (Json.Decode.maybe (Json.Decode.field "avatar-src" Json.Decode.string))
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
        (Json.Decode.maybe (Json.Decode.field "view-count" Json.Decode.int))
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
        |> andMap
            (Json.Decode.field "section" Json.Decode.string
                |> Json.Decode.andThen sectionIdFromString
            )
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
    Json.Decode.map5 Terminal
        (Json.Decode.field "section" Json.Decode.string
            |> Json.Decode.andThen sectionIdFromString
        )
        (Json.Decode.field "title" Json.Decode.string
            |> Json.Decode.andThen slugFromString
        )
        (Json.Decode.field "welcome-message" Json.Decode.string)
        (Json.Decode.field "prompt" Json.Decode.string)
        (Json.Decode.field "commands" (Json.Decode.list commandDecoder))


commandDecoder : Json.Decode.Decoder Command
commandDecoder =
    Json.Decode.map4 Command
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "help-text" Json.Decode.string)
        (Json.Decode.field "output" Json.Decode.string)
        (Json.Decode.maybe (Json.Decode.field "args" (Json.Decode.list Json.Decode.string))
            |> Json.Decode.andThen emptyListFromMaybe
        )


emptyListFromMaybe : Maybe (List String) -> Json.Decode.Decoder (List String)
emptyListFromMaybe maybeArguments =
    Json.Decode.succeed (Maybe.withDefault [] maybeArguments)


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


urlContainsHash : String -> Bool
urlContainsHash url =
    if List.length (String.split "#" url) > 1 then
        True

    else
        False


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


slugFromString : String -> Json.Decode.Decoder String
slugFromString rawString =
    Json.Decode.succeed (String.toLower (String.replace " " "-" rawString))


sectionIdFromString : String -> Json.Decode.Decoder SectionId
sectionIdFromString sectionString =
    case sectionString of
        "introduction" ->
            Json.Decode.succeed Introduction

        "social-media-posts" ->
            Json.Decode.succeed SocialMediaPosts

        "public-trust" ->
            Json.Decode.succeed PublicTrust

        "telegram" ->
            Json.Decode.succeed Telegram

        "ulterior-motives" ->
            Json.Decode.succeed UlteriorMotives

        "panic-lit" ->
            Json.Decode.succeed PanicLit

        "public-order-safety" ->
            Json.Decode.succeed PublicOrderSafety

        "disproportionate-essay-end" ->
            Json.Decode.succeed DisproportionateEssayEnd

        "facial-recognition" ->
            Json.Decode.succeed FacialRecognition

        "incompetence-intro" ->
            Json.Decode.succeed IncompetenceIntro

        "incompetence-posts-and-papers" ->
            Json.Decode.succeed IncompetencePostsAndPapers

        "hmrc-terminal" ->
            Json.Decode.succeed HmrcTerminal

        "data-loss" ->
            Json.Decode.succeed DataLoss

        "ransomware-terminal" ->
            Json.Decode.succeed RansomwareTerminal

        "human-cost" ->
            Json.Decode.succeed HumanCost

        "royal-mail-negotiation" ->
            Json.Decode.succeed RoyalMailNegotiation

        "hackney-social" ->
            Json.Decode.succeed HackneySocial

        "outro" ->
            Json.Decode.succeed Outro

        "project-info" ->
            Json.Decode.succeed ProjectInfo

        _ ->
            Json.Decode.succeed SectionInvalid


sectionIdToString : SectionId -> String
sectionIdToString sectionId =
    case sectionId of
        Introduction ->
            "introduction"

        SocialMediaPosts ->
            "social-media-posts"

        PublicTrust ->
            "public-trust"

        Telegram ->
            "telegram"

        UlteriorMotives ->
            "ulterior-motives"

        PanicLit ->
            "panic-lit"

        PublicOrderSafety ->
            "public-order-safety"

        DisproportionateEssayEnd ->
            "disproportionate-essay-end"

        FacialRecognition ->
            "facial-recognition"

        IncompetenceIntro ->
            "incompetence-intro"

        IncompetencePostsAndPapers ->
            "incompetence-posts-and-papers"

        HmrcTerminal ->
            "hmrc-terminal"

        DataLoss ->
            "data-loss"

        RansomwareTerminal ->
            "ransomware-terminal"

        HumanCost ->
            "human-cost"

        RoyalMailNegotiation ->
            "royal-mail-negotiation"

        HackneySocial ->
            "hackney-social"

        Outro ->
            "outro"

        ProjectInfo ->
            "project-info"

        SectionInvalid ->
            "section-invalid"


sectionIdToInt : SectionId -> Int
sectionIdToInt sectionId =
    case sectionId of
        Introduction ->
            1

        SocialMediaPosts ->
            2

        PublicTrust ->
            3

        Telegram ->
            4

        UlteriorMotives ->
            5

        PanicLit ->
            6

        PublicOrderSafety ->
            7

        DisproportionateEssayEnd ->
            8

        FacialRecognition ->
            9

        IncompetenceIntro ->
            10

        IncompetencePostsAndPapers ->
            11

        HmrcTerminal ->
            12

        DataLoss ->
            13

        RansomwareTerminal ->
            14

        HumanCost ->
            15

        RoyalMailNegotiation ->
            16

        HackneySocial ->
            17

        Outro ->
            18

        ProjectInfo ->
            19

        SectionInvalid ->
            0


filterBySection :
    SectionId
    -> List { item | section : SectionId }
    -> List { item | section : SectionId }
filterBySection sectionId itemList =
    List.filter (\item -> item.section == sectionId) itemList


sectionsFromPage =
    []


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


lineChartData : Graph
lineChartData =
    { section = PublicTrust
    , title = "Empty test data"
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
