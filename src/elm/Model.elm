module Model exposing (Model)

import Data
import InView


type alias Model =
    { content : Data.Content
    , inView : InView.State
    }
