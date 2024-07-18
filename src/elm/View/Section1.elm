module View.Section1 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg(..))
import Pile
import View.MainText
import View.Pile
import View.Posts


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section1 model.content.mainText
    , if Tuple.second model.viewportHeightWidth < 800 then
        View.Posts.view Data.Section1 model.content.posts

      else
        Pile.view Data.Section1 View.Pile.view model.piles |> Html.map Piles
    ]
