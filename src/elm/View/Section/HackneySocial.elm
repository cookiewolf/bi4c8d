module View.Section.HackneySocial exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import Pile
import View.Messages
import View.Pile
import View.Posts


view : Model -> List (Html.Html Msg)
view model =
    [ View.Messages.view model.inView Data.HackneySocial model.content.messages (t HackneySocialMessageHeading) Nothing
    , if Tuple.second model.viewportHeightWidth < 800 then
        View.Posts.view Data.HackneySocial model.content.posts

      else
        Pile.view ( Data.HackneySocial, 1 ) View.Pile.view model.piles |> Html.map Msg.Piles
    ]
