module View.Section10 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.Posts


view : Model -> List (Html.Html Msg)
view model =
    [ View.Posts.view Data.Section10 model.content.posts
    ]
