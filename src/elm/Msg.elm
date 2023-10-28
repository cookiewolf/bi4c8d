module Msg exposing (Msg(..))

import InView


type Msg
    = OnScroll { x : Float, y : Float }
    | InViewMsg InView.Msg
    | OnElementLoad String
