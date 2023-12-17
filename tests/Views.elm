module Views exposing (suite)

import Data exposing (SectionId(..))
import Html
import InView
import Model exposing (Model)
import Msg exposing (Msg)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import Time
import View.Section1


suite : Test
suite =
    let
        view : Model -> List (Html.Html Msg)
        view =
            View.Section1.view

        ( inViewModel, _ ) =
            InView.init Msg.InViewMsg []

        model =
            { content =
                { mainText =
                    [ { body = "\n*Display in section 1 as italics*"
                      , section = Section1
                      , title = "Another section 1 context"
                      }
                    , { body = "\n**Some bold text**\n\n* **list item 1**\n* **list item 2**"
                      , section = Section1
                      , title = "Section one context"
                      }
                    , { body = "\nDo not display in section 1"
                      , section = Section2
                      , title = "Section 2 context"
                      }
                    ]
                , posts =
                    [ { avatarSrc = "/images/uploads/generic-avatar.png"
                      , body = "\nThis is a rich text body.\n\n**It has bold text.**\n"
                      , datetime = Time.millisToPosix 0
                      , forwardedFrom = "Joe Test"
                      , section = Section1
                      , viewCount = 994
                      }
                    ]
                , messages = []
                , images = []
                , graphs = []
                , tickers = []
                }
            , tickerState = []
            , randomIntList = []
            , viewportHeightWidth = ( 800, 800 )
            , inView = inViewModel
            , chartHovering = []
            , time = Time.millisToPosix 0
            }
    in
    describe "View section 1"
        [ describe "View section 1 tests"
            [ test "Section 1 view has body that is HTML" <|
                \() ->
                    Html.div [] (view model)
                        |> Query.fromHtml
                        |> Query.has
                            [ Selector.tag "h3"
                            , Selector.text "Section one context"
                            ]
            ]
        ]
