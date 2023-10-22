module Data exposing (Content, Flags, MainText, SectionId(..), decodedContent, filterBySection)

import Dict
import Json.Decode


type alias Content =
    { mainText : List MainText }


type alias Flags =
    Json.Decode.Value


type alias MainText =
    { title : String
    , section : SectionId
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
            goodContent

        Err error ->
            let
                _ =
                    Debug.log "data import error" error
            in
            { mainText = [] }


flagsDecoder : Json.Decode.Decoder Content
flagsDecoder =
    Json.Decode.map
        Content
        (Json.Decode.field "main-text" mainTextDictDecoder)


mainTextDictDecoder : Json.Decode.Decoder (List MainText)
mainTextDictDecoder =
    Json.Decode.dict mainTextDecoder
        |> Json.Decode.map Dict.toList
        |> Json.Decode.map (\keyedItems -> List.map (\( _, mainText ) -> mainText) keyedItems)


mainTextDecoder : Json.Decode.Decoder MainText
mainTextDecoder =
    Json.Decode.map3
        MainText
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "section" Json.Decode.string
            |> Json.Decode.andThen sectionIdFromString
        )
        (Json.Decode.field "content" Json.Decode.string)


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
