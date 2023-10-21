module Main exposing (main)

import Browser
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg(..))
import View


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = viewDocument
        }


init : flags -> ( Model, Cmd Msg )
init =
    always ( {}, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = t SiteTitle
    , body =
        [ Html.div
            [ Html.Attributes.class "page-wrapper"
            ]
            (View.viewSections model)
        ]
    }
