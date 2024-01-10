module View.Section11 exposing (view)

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
    [ View.MainText.viewTop Data.Section11 model.content.mainText
    , View.Messages.view Data.Section11 model.content.messages (t Section11MessageHeading)
    , View.Posts.view Data.Section11 model.content.posts
    ]
