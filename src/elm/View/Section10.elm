module View.Section10 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg(..))
import Pile
import View.Posts


view : Model -> List (Html.Html Msg)
view model =
    [ if Tuple.second model.viewportHeightWidth < 800 then
        View.Posts.view Data.Section10 model.content.posts

      else
        Pile.view model.pile3.pile |> Html.map Pile3
    ]
