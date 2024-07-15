module Pile exposing (..)

import Draggable
import Draggable.Events
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Math.Vector2 exposing (Vec2)


type alias Id =
    String


type alias Card =
    { id : Id
    , position : Vec2
    , cont : Html Msg
    }


dragCardBy : Vec2 -> Card -> Card
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


addCard : ( Vec2, Html Msg ) -> CardPile -> CardPile
addCard ( pos, cont ) ({ uid, idleCards } as pile) =
    { pile
        | uid = uid + 1
        , idleCards = Card (String.fromInt uid) pos cont :: idleCards
    }


makeCardPile : List ( Vec2, Html Msg ) -> CardPile
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
            List.partition (.id >> (==) id) pile.idleCards
    in
    { pile
        | idleCards = others
        , activeCard = targetAsList |> List.head
    }


stopDragging : CardPile -> CardPile
stopDragging pack =
    { pack | idleCards = allCards pack, activeCard = Nothing }


dragActiveBy : Vec2 -> CardPile -> CardPile
dragActiveBy delta ({ activeCard } as pack) =
    { pack | activeCard = activeCard |> Maybe.map (dragCardBy delta) }


type alias Model =
    { pile : CardPile
    , drag : Draggable.State Id
    }


type Msg
    = DragMsg (Draggable.Msg Id)
    | OnDragBy Vec2
    | StartDragging Id
    | StopDragging


init : List (Html Msg) -> Model
init cardsContent =
    -- will probably either radomly generate these vectors within bounds or
    -- have some hand crafted numbers for initial layout
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
        |> (\pile -> Model pile Draggable.init)



-- These functions require wrapping in the programs main Msg type
-- in order to be compatible


dragConfig : (Msg -> msg) -> Draggable.Config Id msg
dragConfig mainMsg =
    Draggable.customConfig
        [ Draggable.Events.onDragBy (\( dx, dy ) -> Math.Vector2.vec2 dx dy |> OnDragBy |> mainMsg)
        , Draggable.Events.onDragStart (\a -> a |> StartDragging |> mainMsg)
        ]


update : (Msg -> msg) -> Msg -> Model -> ( Model, Cmd msg )
update mainMsg msg ({ pile } as model) =
    case msg of
        OnDragBy delta ->
            ( { model | pile = pile |> dragActiveBy delta }, Cmd.none )

        StartDragging id ->
            ( { model | pile = pile |> startDragging id }, Cmd.none )

        StopDragging ->
            ( { model | pile = pile |> stopDragging }, Cmd.none )

        DragMsg dragMsg ->
            Draggable.update (dragConfig mainMsg) dragMsg model


subscriptions : (Msg -> msg) -> Model -> Sub msg
subscriptions mainMsg { drag } =
    Draggable.subscriptions DragMsg drag
        |> Sub.map mainMsg


cardView : Card -> Html Msg
cardView { id, position, cont } =
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
        , Draggable.mouseTrigger id DragMsg
        , Html.Events.onMouseUp StopDragging
        ]
        [ cont ]


view : CardPile -> Html Msg
view pile =
    pile
        |> allCards
        |> List.map cardView
        |> List.reverse
        |> Html.div [ Html.Attributes.class "pile" ]
