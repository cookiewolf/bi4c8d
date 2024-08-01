module View.Section16 exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import Pile
import View.MainText
import View.Messages
import View.Pile
import View.Posts


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section16 model.content.mainText
    , View.Messages.view model.inView Data.Section16 model.content.messages (t Section16MessageHeading) Nothing
    , if Tuple.second model.viewportHeightWidth < 800 then
        View.Posts.view Data.Section16 model.content.posts

      else
        Pile.view Data.Section16 View.Pile.view model.piles |> Html.map Msg.Piles
    ]
