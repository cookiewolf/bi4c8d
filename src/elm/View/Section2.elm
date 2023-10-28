module View.Section2 exposing (view)

import Data
import Html
import Html.Attributes
import Html.Events
import InView
import Json.Decode
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 [] [ Html.text "Section 2" ]
    , View.MainText.view Data.Section2 model.content.mainText
    , viewImageList model.inView model.content.images
    ]


viewImageList : InView.State -> List Data.Image -> Html.Html Msg
viewImageList inViewState imageList =
    if List.length imageList > 0 then
        Html.div [ Html.Attributes.class "images" ]
            (List.map
                (\image -> viewImage inViewState image)
                (Data.filterBySection Data.Section2 imageList)
            )

    else
        Html.text ""


viewImage : InView.State -> Data.Image -> Html.Html Msg
viewImage inViewState image =
    Html.div []
        [ Html.div [ Html.Attributes.class "image" ]
            [ Html.img
                [ Html.Attributes.src image.source
                , Html.Attributes.alt image.alt
                , Html.Attributes.id image.source
                , Html.Events.on "load" (Json.Decode.succeed (Msg.OnElementLoad image.source))
                , case InView.isInView image.source inViewState of
                    Just answer ->
                        if answer then
                            Html.Attributes.class "in-view"

                        else
                            Html.Attributes.class ""

                    Nothing ->
                        Html.Attributes.class ""
                ]
                []
            ]
        ]
