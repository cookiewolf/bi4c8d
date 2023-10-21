module Main exposing (main)

import Browser
import Html
import Model exposing (Model)
import Msg exposing (Msg(..))
import View


type alias Document msg =
    { title : String
    , body : List (Html.Html msg)
    }


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
    { title = "Bi4c8d", body = viewSections model }


viewSections : Model -> List (Html.Html Msg)
viewSections model =
    View.viewSections model
