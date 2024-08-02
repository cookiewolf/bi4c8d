module View.HorizontalScroller exposing (..)

import Data
import Html
import Html.Attributes
import Model
import View.Posts


view : Data.SectionId -> Model.Model -> Html.Html msg
view id model =
    let
        testImage =
            Data.Image id "https://i.pinimg.com/originals/99/84/36/99843695cdbe04d10555f02381bc6d4e.jpg" "" 1

        testImage2 =
            Data.Image id "https://i.pinimg.com/originals/ce/4f/d2/ce4fd246b64711bbc64f6fe99dd132d0.png" "" 1
    in
    case id of
        Data.Section1 ->
            Data.filterBySection id model.content.posts
                |> List.map viewPost
                |> viewScroller

        Data.Section4 ->
            testImage
                :: testImage2
                :: Data.filterBySection id model.content.images
                |> List.map viewImage
                |> viewScroller

        Data.Section8 ->
            Data.filterBySection id model.content.images
                |> List.map viewImage
                |> viewScroller

        Data.Section10 ->
            Data.filterBySection id model.content.posts
                |> List.map viewPost
                |> viewScroller

        Data.Section16 ->
            Data.filterBySection id model.content.posts
                |> List.map viewPost
                |> viewScroller

        _ ->
            Html.text ""


viewScroller : List (Html.Html msg) -> Html.Html msg
viewScroller =
    Html.div [ Html.Attributes.class "horizontal-scroller" ]


viewImage : Data.Image -> Html.Html msg
viewImage image =
    Html.img
        [ Html.Attributes.src image.source
        , Html.Attributes.alt image.alt
        ]
        []



-- Html.div
--     []
--     [ Html.img
--         [ Html.Attributes.src image.source
--         , Html.Attributes.alt image.alt
--         ]
--         []
--     ]


viewPost : Data.Post -> Html.Html msg
viewPost post =
    Html.div
        [ Html.Attributes.class "horizontal-scroller__post"
        ]
        [ View.Posts.viewPostDraggable post ]
