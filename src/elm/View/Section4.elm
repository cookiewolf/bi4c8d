module View.Section4 exposing (view)

import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg(..))
import Pile
import View.MainText
import View.StackingImage


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section4 model.content.mainText
    , if Tuple.second model.viewportHeightWidth < 800 then
        View.StackingImage.viewImageListStatic Data.Section4 model.content.images

      else
        Pile.view model.pile2.pile |> Html.map Pile2
    ]
