module View.Section10 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg(..))
import Pile
import View.Pile
import View.Posts


view : Model -> List (Html.Html Msg)
view model =
    [ if Tuple.second model.viewportHeightWidth < 800 then
        View.Posts.view Data.Section10 model.content.posts

      else
        Pile.view Data.Section10 View.Pile.view model.piles |> Html.map Piles
    ]
