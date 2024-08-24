module View.Context exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
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
            [ Html.summary [ Html.Attributes.class "context-subtitle", Html.Attributes.class "context-summary" ] [ Html.text (t ContextLabel) ]
            , Html.div
                [ Html.Attributes.class "context-body"
                ]
                [ viewContext context.maybeContext
                , Html.dl [ Html.Attributes.class "context-list" ]
                    (viewFactCheck context.maybeFactCheck
                        ++ viewReferences context.references
                    )
                ]
            ]
        , Html.node "hyvor-talk-comments"
            [ Html.Attributes.attribute "website-id" "11670"
            , Html.Attributes.attribute "page-id" (sectionIdStringFromSection context.section)
            ]
            [ Html.text (sectionIdStringFromSection context.section) ]
        , Html.node "section-change-tracker"
            [ Html.Attributes.attribute "section-id" (sectionIdStringFromSection context.section) ]
            []
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


viewContext : Maybe String -> Html.Html Msg
viewContext maybeContext =
    case maybeContext of
        Just content ->
            Html.div [ Html.Attributes.class "context-content" ] (Markdown.markdownToHtml content)

        Nothing ->
            Html.text ""


viewFactCheck : Maybe String -> List (Html.Html Msg)
viewFactCheck maybeFactCheck =
    case maybeFactCheck of
        Just content ->
            [ Html.dt [ Html.Attributes.class "context-subtitle" ] [ Html.text (t FactCheckLabel) ]
            , Html.dd
                [ Html.Attributes.class "context-content"
                ]
                (Markdown.markdownToHtml content)
            ]

        Nothing ->
            []


viewReferences : List String -> List (Html.Html Msg)
viewReferences referenceList =
    if List.length referenceList > 0 then
        [ Html.dt [ Html.Attributes.class "context-subtitle" ] [ Html.text (t ReferencesLabel) ]
        , Html.dd
            [ Html.Attributes.class "context-content"
            ]
            [ Html.ol [ Html.Attributes.class "references" ]
                (List.map
                    (\reference ->
                        Html.li [] [ Html.a [ Html.Attributes.class "reference-link", Html.Attributes.href reference ] [ Html.text reference ] ]
                    )
                    referenceList
                )
            ]
        ]

    else
        []
