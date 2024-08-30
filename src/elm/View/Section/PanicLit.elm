module View.Section.PanicLit exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg(..))
import Pile
import View.Pile
import View.StackingImage


view : Model -> List (Html.Html Msg)
view model =
    [ if Tuple.second model.viewportHeightWidth < 800 then
        View.StackingImage.viewImageListStatic Data.PanicLit model.content.images

      else
        Pile.view ( Data.PanicLit, 1 ) View.Pile.view model.piles |> Html.map Piles
    ]
