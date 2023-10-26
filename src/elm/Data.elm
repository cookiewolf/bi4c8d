module Data exposing (Content, Flags, MainText, Message, SectionId(..), decodedContent, filterBySection)

import Dict
import Iso8601
import Json.Decode
import Time


type alias Content =
    { mainText : List MainText
    , messages : List Message
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


type SectionId
    = SectionInvalid
    | Section1
    | Section2


decodedContent : Json.Decode.Value -> Content
decodedContent flags =
    case Json.Decode.decodeValue flagsDecoder flags of
        Ok goodContent ->
            { goodContent
                | messages = orderMessagesByDatetime goodContent.messages
            }

        Err _ ->
            { mainText = []
            , messages = []
            }


orderMessagesByDatetime : List Message -> List Message
orderMessagesByDatetime messages =
    List.sortBy (\message -> Time.posixToMillis message.datetime) messages


flagsDecoder : Json.Decode.Decoder Content
flagsDecoder =
    Json.Decode.map2
        Content
        (Json.Decode.field "main-text" mainTextDictDecoder)
        (Json.Decode.field "messages" messageDictDecoder)


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
            |> Json.Decode.andThen posixFromString
        )
        (Json.Decode.field "forwarded-from" Json.Decode.string)
        (Json.Decode.field "view-count" Json.Decode.int)
        (Json.Decode.field "avatar-src" Json.Decode.string)
        (Json.Decode.field "content" Json.Decode.string)


posixFromString : String -> Json.Decode.Decoder Time.Posix
posixFromString dateString =
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

        _ ->
            Json.Decode.succeed SectionInvalid


filterBySection :
    SectionId
    -> List { item | section : SectionId }
    -> List { item | section : SectionId }
filterBySection sectionId itemList =
    List.filter (\item -> item.section == sectionId) itemList
