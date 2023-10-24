module Markdown exposing (markdownToHtml)

import Html
import Html.Attributes
import Markdown.Block as Block
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer


markdownToHtml : String -> List (Html.Html msg)
markdownToHtml markdown =
    case markdownToView markdown of
        Ok html ->
            html

        Err _ ->
            []


markdownToView : String -> Result String (List (Html.Html msg))
markdownToView markdownString =
    markdownString
        |> Markdown.Parser.parse
        |> Result.mapError (\_ -> "Markdown error.")
        |> Result.andThen
            (\blocks ->
                Markdown.Renderer.render
                    htmlRenderer
                    blocks
            )


htmlRenderer : Markdown.Renderer.Renderer (Html.Html msg)
htmlRenderer =
    { heading =
        \{ level, children } ->
            case level of
                Block.H1 ->
                    Html.h1 [] children

                Block.H2 ->
                    Html.h2 [] children

                Block.H3 ->
                    Html.h3 [] children

                Block.H4 ->
                    Html.h4 [] children

                Block.H5 ->
                    Html.h5 [] children

                Block.H6 ->
                    Html.h6 [] children
    , paragraph = Html.p []
    , hardLineBreak = Html.br [] []
    , strikethrough =
        \children -> Html.s [] children
    , blockQuote = Html.blockquote []
    , strong =
        \children -> Html.strong [] children
    , emphasis =
        \children -> Html.em [] children
    , codeSpan =
        \content -> Html.code [] [ Html.text content ]
    , link =
        \link content ->
            case link.title of
                Just title ->
                    Html.a
                        [ Html.Attributes.href link.destination
                        , Html.Attributes.title title
                        ]
                        content

                Nothing ->
                    Html.a [ Html.Attributes.href link.destination ] content
    , image =
        \imageInfo ->
            case imageInfo.title of
                Just title ->
                    Html.img
                        [ Html.Attributes.src imageInfo.src
                        , Html.Attributes.alt imageInfo.alt
                        , Html.Attributes.title title
                        , Html.Attributes.class "content_image"
                        ]
                        []

                Nothing ->
                    Html.img
                        [ Html.Attributes.src imageInfo.src
                        , Html.Attributes.alt imageInfo.alt
                        , Html.Attributes.class "content_image"
                        ]
                        []
    , text =
        Html.text
    , unorderedList =
        \items ->
            Html.ul []
                (items
                    |> List.map
                        (\item ->
                            case item of
                                Block.ListItem task children ->
                                    let
                                        checkbox : Html.Html msg
                                        checkbox =
                                            case task of
                                                Block.NoTask ->
                                                    Html.text ""

                                                Block.IncompleteTask ->
                                                    Html.input
                                                        [ Html.Attributes.disabled True
                                                        , Html.Attributes.checked False
                                                        , Html.Attributes.type_ "checkbox"
                                                        ]
                                                        []

                                                Block.CompletedTask ->
                                                    Html.input
                                                        [ Html.Attributes.disabled True
                                                        , Html.Attributes.checked True
                                                        , Html.Attributes.type_ "checkbox"
                                                        ]
                                                        []
                                    in
                                    Html.li [] (checkbox :: children)
                        )
                )
    , orderedList =
        \startingIndex items ->
            Html.ol
                (case startingIndex of
                    1 ->
                        [ Html.Attributes.start startingIndex ]

                    _ ->
                        []
                )
                (items
                    |> List.map
                        (\itemBlocks ->
                            Html.li []
                                itemBlocks
                        )
                )
    , html = Markdown.Html.oneOf []
    , codeBlock =
        \{ body } ->
            Html.pre []
                [ Html.code []
                    [ Html.text body
                    ]
                ]
    , thematicBreak = Html.hr [] []
    , table = Html.table []
    , tableHeader = Html.thead []
    , tableBody = Html.tbody []
    , tableRow = Html.tr []
    , tableHeaderCell =
        \maybeAlignment ->
            let
                attrs : List (Html.Attribute msg)
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Block.AlignLeft ->
                                        "left"

                                    Block.AlignCenter ->
                                        "center"

                                    Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Html.Attributes.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.th attrs
    , tableCell =
        \maybeAlignment ->
            let
                attrs : List (Html.Attribute msg)
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Block.AlignLeft ->
                                        "left"

                                    Block.AlignCenter ->
                                        "center"

                                    Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Html.Attributes.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.td attrs
    }
