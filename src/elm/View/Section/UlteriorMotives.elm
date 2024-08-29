module View.Section.UlteriorMotives exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg(..))
import Pile
import View.MainText
import View.Pile
import View.Posts
import View.StackingImage


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.UlteriorMotives model.content.mainText
    , if Tuple.second model.viewportHeightWidth < 800 then
        View.Posts.view Data.UlteriorMotives model.content.posts

      else
        Pile.view Data.UlteriorMotives View.Pile.view model.piles |> Html.map Piles
    , if Tuple.second model.viewportHeightWidth < 800 then
        View.StackingImage.viewImageListStatic Data.UlteriorMotives model.content.images

      else
        Pile.view Data.UlteriorMotives View.Pile.view model.piles |> Html.map Piles
    ]
