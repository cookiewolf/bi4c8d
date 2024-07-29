module View.Context exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import Html.Events
import InView
import Markdown
import Msg exposing (Msg)


view : InView.State -> List Data.Context -> Html.Html Msg
view inViewState contextList =
    contextList
        |> List.filter hasUsefulContext
        |> List.partition
            (\context ->
                InView.isInView (Data.sectionIdToString context.section) inViewState
                    |> Maybe.withDefault False
            )
        |> Tuple.first
        |> List.head
        |> Maybe.map viewContextSection
        |> Maybe.withDefault (Html.text "")


hasUsefulContext : Data.Context -> Bool
hasUsefulContext context =
    (context.maybeContext /= Nothing)
        || (context.maybeFactCheck /= Nothing)
        || (List.length context.references > 0)


viewContextSection : Data.Context -> Html.Html Msg
viewContextSection context =
    Html.div
        [ Html.Attributes.id (sectionIdStringFromSection context.section)
        , Html.Attributes.id "context"
        , Html.Attributes.class "section-active"
        ]
        [ viewContextSectionHeader context.section
        , Html.details []
            [ Html.summary [] [ Html.text "Context" ]
            , Html.div
                [ Html.Attributes.class "context-body"
                ]
                [ Html.p [] [ Html.text "THIS WILL BE CONTENT FROM CONTEXT" ]
                , Html.dl [ Html.Attributes.class "context-list" ]
                    (viewContext context.maybeContext
                        ++ viewFactCheck context.maybeFactCheck
                        ++ viewReferences context.references
                    )
                ]
            ]
        ]


sectionIdStringFromSection : Data.SectionId -> String
sectionIdStringFromSection sectionId =
    "context-" ++ Data.sectionIdToString sectionId


viewContextSectionHeader : Data.SectionId -> Html.Html Msg
viewContextSectionHeader sectionId =
    Html.h2
        [ Html.Attributes.class "context-section-title"
        , Html.Attributes.attribute "aria-live" "polite"
        ]
        [ Html.span
            [ Html.Attributes.class "screen-reader-only"
            ]
            [ Html.text (t ContextNewSectionMessage) ]
        , Html.text ("Section " ++ String.fromInt (Data.sectionIdToInt sectionId) ++ " of 17")
        ]


viewContext : Maybe String -> List (Html.Html Msg)
viewContext maybeContext =
    case maybeContext of
        Just content ->
            [ Html.dt [] [ Html.text (t ContextLabel) ]
               , Html.dd
                    [ Html.Attributes.class "context-content"
                    , Html.Attributes.attribute "aria-live" "polite"
                    ]
                    (Markdown.markdownToHtml content)

            ]

        Nothing ->
            []


viewFactCheck : Maybe String -> List (Html.Html Msg)
viewFactCheck  maybeFactCheck =
    case maybeFactCheck of
        Just content ->
            [ Html.dt [] [ Html.text (t FactCheckLabel) ]
                ,Html.dd
                    [ Html.Attributes.class "context-content"
                    , Html.Attributes.attribute "aria-live" "polite"
                    ]
                    (Markdown.markdownToHtml content)

            ]

        Nothing ->
            []


viewReferences : List String -> List (Html.Html Msg)
viewReferences  referenceList =
    if List.length referenceList> 0 then
        [ Html.dt [] [ Html.text (t ReferencesLabel)  ]
            ,Html.dd
                [ Html.Attributes.class "context-content"
                , Html.Attributes.attribute "aria-live" "polite"
                ]
                [ Html.ol []
                    (List.map
                        (\reference ->
                            Html.li [] [ Html.text reference ]
                        )
                        referenceList
                    )
                ]

        ]

    else
        []


viewDropdownButton : Msg -> String -> Bool -> Html.Html Msg
viewDropdownButton onclick text open =
    let
        src =
            if open then
                "/images/chevron-down.svg"

            else
                "/images/chevron-up.svg"

        screenReaderText =
            if open then
                t ContextLabelOpen

            else
                t ContextLabelClosed
    in
    Html.button
        [ Html.Attributes.class "context-button", Html.Events.onClick onclick ]
        [ Html.span [] [ Html.text text ]
        , Html.span
            [ Html.Attributes.class "screen-reader-only" ]
            [ Html.text screenReaderText ]
        , Html.img
            [ Html.Attributes.attribute "aria-hidden" "true"
            , Html.Attributes.class "context-button-icon"
            , Html.Attributes.src src
            ]
            []
        ]
