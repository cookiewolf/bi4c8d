module View.Section2 exposing (view)

import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText


view : Model -> List (Html.Html Msg)
view model =
    [ Html.h2 [] [ Html.text "Section 2" ]
    , View.MainText.view Data.Section2 model.content.mainText
    , viewImageList model.content.images
    ]


viewImageList : List Data.Image -> Html.Html Msg
viewImageList imageList =
    if List.length imageList > 0 then
        Html.div [ Html.Attributes.class "images" ]
            (List.map
                (\image -> viewImage image)
                (Data.filterBySection Data.Section2 imageList)
            )

    else
        Html.text ""


viewImage : Data.Image -> Html.Html Msg
viewImage image =
    Html.div []
        [ Html.div [ Html.Attributes.class "image" ]
            [ Html.img
                [ Html.Attributes.src image.source
                , Html.Attributes.alt image.alt
                ]
                []
            ]
        ]
