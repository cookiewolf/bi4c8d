module Pile exposing (..)

import AssocList
import Data
import Draggable
import Draggable.Events
import Html
import Html.Attributes
import Html.Events
import Math.Vector2


type Data
    = Post Data.Post
    | Image Data.Image


type alias Id =
    String


type alias Card =
    { id : Id
    , position : Math.Vector2.Vec2
    , cont : Data
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


addCard : ( Math.Vector2.Vec2, Data ) -> CardPile -> CardPile
addCard ( position, content ) ({ uid, idleCards } as pile) =
    { pile
        | uid = uid + 1
        , idleCards = Card (String.fromInt uid) position content :: idleCards
    }


makeCardPile : List ( Math.Vector2.Vec2, Data ) -> CardPile
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
    { activePile : Maybe Data.SectionId
    , piles : AssocList.Dict Data.SectionId CardPile
    , drag : Draggable.State DragState
    }


type alias DragState =
    { dictKey : Data.SectionId
    , cardId : Id
    }


type Msg
    = DragMsg (Draggable.Msg DragState)
    | OnDragBy Math.Vector2.Vec2
    | StartDragging DragState
    | StopDragging


clamp : { minVal : Int, maxVal : Int } -> Int -> Int
clamp { minVal, maxVal } value =
    value
        |> min maxVal
        |> max minVal


init : List ( Data.SectionId, List Data ) -> Model
init prePiles =
    let
        ( centerX, centerY ) =
            -- stubbed out ready to recieve viewport data
            ( 600, 400 )
    in
    prePiles
        |> List.map
            (\( key, cardsContent ) ->
                let
                    -- stubbed out ready to recieve viewport data
                    clampX =
                        clamp { minVal = 10, maxVal = 790 }

                    clampY =
                        clamp { minVal = 10, maxVal = 790 }

                    xs =
                        List.range 0 (List.length cardsContent)
                            |> List.map
                                (\number ->
                                    let
                                        offsetX =
                                            -- guestimate for top left of item from it's center
                                            -- could plumb in real values if we ever retrieve that data
                                            200

                                        pos =
                                            centerX - offsetX
                                    in
                                    if modBy 2 number == 0 then
                                        pos + (number * 15)

                                    else
                                        pos - (number * 20)
                                )
                            |> List.map clampX
                            |> List.map toFloat
                            |> List.reverse

                    ys =
                        List.range 0 (List.length cardsContent)
                            |> List.map
                                (\number ->
                                    let
                                        offsetY =
                                            -- guestimate for top left of item from it's center
                                            -- could plumb in real values if we ever retrieve that data
                                            200

                                        pos =
                                            centerY - offsetY
                                    in
                                    if modBy 2 number == 0 then
                                        pos + (number * 15)

                                    else
                                        pos - (number * 25)
                                )
                            |> List.map clampY
                            |> List.map toFloat
                            |> List.reverse
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


dragConfig : Draggable.Config DragState Msg
dragConfig =
    Draggable.customConfig
        [ Draggable.Events.onDragBy (\( dx, dy ) -> Math.Vector2.vec2 dx dy |> OnDragBy)
        , Draggable.Events.onDragStart (\a -> a |> StartDragging)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ piles, activePile } as model) =
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
                | piles =
                    AssocList.update dragState.dictKey
                        (Maybe.map (\cardPile -> cardPile |> stopDragging |> startDragging dragState.cardId))
                        piles
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
            Draggable.update dragConfig dragMsg model


subscriptions : Model -> Sub Msg
subscriptions { drag } =
    Draggable.subscriptions DragMsg drag


cardView : Data.SectionId -> (Data -> Html.Html Msg) -> Card -> Html.Html Msg
cardView key toView { id, position, cont } =
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
        [ toView cont ]


view : Data.SectionId -> (Data -> Html.Html Msg) -> Model -> Html.Html Msg
view key toView model =
    AssocList.get key model.piles
        |> Maybe.map
            (\pile ->
                pile
                    |> allCards
                    |> List.map (cardView key toView)
                    |> List.reverse
                    |> Html.div [ Html.Attributes.class "pile" ]
            )
        |> Maybe.withDefault (Html.text "")
