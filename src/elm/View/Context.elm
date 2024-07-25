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
    Html.ul [ Html.Attributes.id "context" ] (List.map (\context -> viewContextSection inViewState context) contextList)


viewContextSection : InView.State -> Data.Context -> Html.Html Msg
viewContextSection inViewState context =
    let
        sectionInView : Bool
        sectionInView =
            InView.isInView (Data.sectionIdToString context.section) inViewState
                |> Maybe.withDefault False

        sectionViewStatus : String
        sectionViewStatus =
            if sectionInView then
                "section-active"

            else
                "section-offscreen"
    in
    Html.li
        [ Html.Attributes.id (sectionIdStringFromSection context.section)
        , Html.Attributes.class sectionViewStatus
        ]
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
