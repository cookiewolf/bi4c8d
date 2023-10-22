module Views exposing (suite)

import Html
import Model exposing (Model)
import Msg exposing (Msg)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import View.Section1


suite : Test
suite =
    let
        view : Model -> Html.Html Msg
        view =
            View.Section1.view
    in
    describe "View section 1"
        [ describe "View section 1 tests"
            [ test "Section 1 view has body that is HTML" <|
                \() ->
                    view {}
                        |> Query.fromHtml
                        |> Query.has
                            [ Selector.tag "h2"
                            , Selector.text "Section 1"
                            ]
            ]
        ]
