module View.Context exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import Markdown
import Msg exposing (Msg)


view : List Data.Context -> Html.Html Msg
view contextList =
    Html.ul [ Html.Attributes.id "context" ] (List.map (\context -> viewContextSection context) contextList)


viewContextSection : Data.Context -> Html.Html Msg
viewContextSection context =
    Html.li [ Html.Attributes.id (sectionIdStringFromSection context.section) ]
        [ viewContextSectionHeader context.section
        , Html.dl []
            (viewContext context.maybeContext
                ++ viewFactCheck context.maybeFactCheck
                ++ viewReferences context.references
            )
        ]


sectionIdStringFromSection : Data.SectionId -> String
sectionIdStringFromSection sectionId =
    "context-" ++ Data.sectionIdToString sectionId


viewContextSectionHeader : Data.SectionId -> Html.Html Msg
viewContextSectionHeader sectionId =
    Html.h2 [ Html.Attributes.class "context-section-title" ]
        [ Html.text ("Section " ++ String.fromInt (Data.sectionIdToInt sectionId) ++ " of 17")
        ]


viewContext : Maybe String -> List (Html.Html Msg)
viewContext maybeContext =
    case maybeContext of
        Just context ->
            [ Html.dt [] [ Html.text (t ContextLabel) ]
            , Html.dd [] (Markdown.markdownToHtml context)
            ]

        Nothing ->
            []


viewFactCheck : Maybe String -> List (Html.Html Msg)
viewFactCheck maybeFactCheck =
    case maybeFactCheck of
        Just factCheck ->
            [ Html.dt [] [ Html.text (t FactCheckLabel) ]
            , Html.dd [] (Markdown.markdownToHtml factCheck)
            ]

        Nothing ->
            []


viewReferences : List String -> List (Html.Html Msg)
viewReferences referenceList =
    if List.length referenceList > 0 then
        [ Html.dt [] [ Html.text (t ReferencesLabel) ]
        , Html.dd []
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
