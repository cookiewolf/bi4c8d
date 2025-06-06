module View.Section.IncompetencePostsAndPapers exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import Pile
import View.Pile
import View.Posts
import View.StackingImage


view : Model -> List (Html.Html Msg)
view model =
    [ if Tuple.second model.viewportHeightWidth < 800 then
        View.Posts.view Data.IncompetencePostsAndPapers model.content.posts

      else
        Pile.view ( Data.IncompetencePostsAndPapers, 1 ) View.Pile.view model.piles |> Html.map Msg.Piles
    , if Tuple.second model.viewportHeightWidth < 800 then
        View.StackingImage.viewImageListStatic Data.IncompetencePostsAndPapers model.content.images

      else
        Pile.view ( Data.IncompetencePostsAndPapers, 2 ) View.Pile.view model.piles |> Html.map Msg.Piles
    ]
