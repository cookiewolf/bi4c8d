module View.Section16 exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Model exposing (Model)
import Msg exposing (Msg)
import View.MainText
import View.Messages
import View.Posts


view : Model -> List (Html.Html Msg)
view model =
    [ View.MainText.viewTop Data.Section16 model.content.mainText
    , View.Messages.view model.inView Data.Section16 model.content.messages (t Section16MessageHeading) Nothing
    , View.Posts.view Data.Section16 model.content.posts
    ]
