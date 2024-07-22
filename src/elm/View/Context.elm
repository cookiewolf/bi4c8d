module View.Context exposing (view)

import Data
import Html
import Html.Attributes
import Msg exposing (Msg)


view : List Data.Context -> Html.Html Msg
view contextList =
    Html.div [ Html.Attributes.id "context" ] (List.map (\context -> viewContext context) contextList)


viewContext : Data.Context -> Html.Html Msg
viewContext context =
    Html.div [] [ Html.text context.title ]
