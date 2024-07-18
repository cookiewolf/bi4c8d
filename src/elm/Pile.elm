module Pile exposing (..)

import AssocList
import Data exposing (SectionId)
import Draggable
import Draggable.Events
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Math.Vector2


type alias Id =
    String


type alias Card =
    { id : Id
    , position : Math.Vector2.Vec2
    , cont : Html Msg
    }


dragCardBy : Math.Vector2.Vec2 -> Card -> Card
dragCardBy delta card =
    { card | position = card.position |> Math.Vector2.add delta }


type alias CardPile =
    { uid : Int
    , activeCard : Maybe Card
    , idleCards : List Card
    }


emptyPile : CardPile
emptyPile =
    CardPile 0 Nothing []


addCard : ( Math.Vector2.Vec2, Html Msg ) -> CardPile -> CardPile
addCard ( pos, cont ) ({ uid, idleCards } as pile) =
    { pile
        | uid = uid + 1
        , idleCards = Card (String.fromInt uid) pos cont :: idleCards
    }


makeCardPile : List ( Math.Vector2.Vec2, Html Msg ) -> CardPile
makeCardPile elements =
    List.foldl addCard emptyPile elements


allCards : CardPile -> List Card
allCards { activeCard, idleCards } =
    activeCard
        |> Maybe.map (\c -> c :: idleCards)
        |> Maybe.withDefault idleCards


startDragging : Id -> CardPile -> CardPile
startDragging id pile =
    let
        ( targetAsList, others ) =
            List.partition (\card -> card.id == id) pile.idleCards
    in
    { pile
        | idleCards = others
        , activeCard = targetAsList |> List.head
    }


stopDragging : CardPile -> CardPile
stopDragging pack =
    { pack | idleCards = allCards pack, activeCard = Nothing }


dragActiveBy : Math.Vector2.Vec2 -> CardPile -> CardPile
dragActiveBy delta ({ activeCard } as pack) =
    { pack | activeCard = activeCard |> Maybe.map (dragCardBy delta) }


type alias Model =
    { activePile : Maybe SectionId
    , piles : AssocList.Dict SectionId CardPile
    , drag : Draggable.State DragState
    }


type alias DragState =
    { dictKey : SectionId
    , cardId : Id
    }


type Msg
    = DragMsg (Draggable.Msg DragState)
    | OnDragBy Math.Vector2.Vec2
    | StartDragging DragState
    | StopDragging


init : List ( SectionId, List (Html Msg) ) -> Model
init prePiles =
    -- will probably either radomly generate these vectors within bounds or
    -- have some hand crafted numbers for initial layout
    prePiles
        |> List.map
            (\( key, cardsContent ) ->
                let
                    xs =
                        List.range 0 (List.length cardsContent)
                            |> List.map
                                (\n ->
                                    if modBy 2 n == 0 then
                                        n * 120

                                    else
                                        n * 85
                                )
                            |> List.map toFloat

                    ys =
                        List.range 0 (List.length cardsContent)
                            |> List.map
                                (\n ->
                                    if modBy 2 n == 0 then
                                        n * 60

                                    else
                                        n * 75
                                )
                            |> List.map toFloat
                in
                cardsContent
                    |> List.map3 (\x y cont -> ( Math.Vector2.vec2 x y, cont )) xs ys
                    |> makeCardPile
                    |> (\newPile -> ( key, newPile ))
            )
        |> AssocList.fromList
        |> (\pileDict -> Model Nothing pileDict Draggable.init)



-- These functions require wrapping in the programs main Msg type
-- in order to be compatible


dragConfig : (Msg -> msg) -> Draggable.Config DragState msg
dragConfig mainMsg =
    Draggable.customConfig
        [ Draggable.Events.onDragBy (\( dx, dy ) -> Math.Vector2.vec2 dx dy |> OnDragBy |> mainMsg)
        , Draggable.Events.onDragStart (\a -> a |> StartDragging |> mainMsg)
        ]


update : (Msg -> msg) -> Msg -> Model -> ( Model, Cmd msg )
update mainMsg msg ({ piles, activePile } as model) =
    case msg of
        OnDragBy delta ->
            ( { model
                | piles =
                    activePile
                        |> Maybe.map (\key -> AssocList.update key (Maybe.map (dragActiveBy delta)) piles)
                        |> Maybe.withDefault piles
              }
            , Cmd.none
            )

        StartDragging dragState ->
            ( { model
                | piles = AssocList.update dragState.dictKey (Maybe.map (startDragging dragState.cardId)) piles
                , activePile =
                    if AssocList.member dragState.dictKey piles then
                        Just dragState.dictKey

                    else
                        Nothing
              }
            , Cmd.none
            )

        StopDragging ->
            ( { model
                | activePile = Nothing
                , piles =
                    activePile
                        |> Maybe.map (\key -> AssocList.update key (Maybe.map stopDragging) piles)
                        |> Maybe.withDefault piles
              }
            , Cmd.none
            )

        DragMsg dragMsg ->
            Draggable.update (dragConfig mainMsg) dragMsg model


subscriptions : (Msg -> msg) -> Model -> Sub msg
subscriptions mainMsg { drag } =
    Draggable.subscriptions DragMsg drag
        |> Sub.map mainMsg


cardView : SectionId -> Card -> Html Msg
cardView key { id, position, cont } =
    let
        x =
            String.fromFloat (Math.Vector2.getX position) ++ "px"

        y =
            String.fromFloat (Math.Vector2.getY position) ++ "px"
    in
    Html.div
        [ Html.Attributes.class "card"
        , Html.Attributes.style "left" x
        , Html.Attributes.style "top" y
        , Html.Attributes.style "cursor" "move"
        , Draggable.mouseTrigger (DragState key id) DragMsg
        , Html.Events.onMouseUp StopDragging
        ]
        [ cont ]


view : SectionId -> Model -> Html Msg
view key model =
    AssocList.get key model.piles
        |> Maybe.map
            (\pile ->
                pile
                    |> allCards
                    |> List.map (cardView key)
                    |> List.reverse
                    |> Html.div [ Html.Attributes.class "pile" ]
            )
        |> Maybe.withDefault (Html.text "")
