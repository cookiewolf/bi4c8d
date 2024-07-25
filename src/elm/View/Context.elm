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

        toggleMsg =
            Msg.ToggleContext context.section
    in
    Html.li
        [ Html.Attributes.id (sectionIdStringFromSection context.section)
        , Html.Attributes.class sectionViewStatus
        ]
        [ viewContextSectionHeader context.section
        , Html.dl []
            (viewContext toggleMsg context.maybeContext
                ++ viewFactCheck toggleMsg context.maybeFactCheck
                ++ viewReferences toggleMsg context.references
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


viewContext : (Data.ContextSection -> Msg) -> Maybe (Data.ContextState String) -> List (Html.Html Msg)
viewContext toggle maybeContext =
    case maybeContext of
        Just { content, open } ->
            [ Html.dt [] [ Html.button [ Html.Events.onClick (toggle Data.ContextTxt) ] [ Html.text (t ContextLabel) ] ]
            , if open then
                Html.dd [] (Markdown.markdownToHtml content)

              else
                Html.text ""
            ]

        Nothing ->
            []


viewFactCheck : (Data.ContextSection -> Msg) -> Maybe (Data.ContextState String) -> List (Html.Html Msg)
viewFactCheck toggle maybeFactCheck =
    case maybeFactCheck of
        Just { content, open } ->
            [ Html.dt [] [ Html.button [ Html.Events.onClick (toggle Data.FactCheck) ] [ Html.text (t FactCheckLabel) ] ]
            , if open then
                Html.dd [] (Markdown.markdownToHtml content)

              else
                Html.text ""
            ]

        Nothing ->
            []


viewReferences : (Data.ContextSection -> Msg) -> Data.ContextState (List String) -> List (Html.Html Msg)
viewReferences toggle referenceList =
    if List.length referenceList.content > 0 then
        [ Html.dt [] [ Html.button [ Html.Events.onClick (toggle Data.Reference) ] [ Html.text (t ReferencesLabel) ] ]
        , if referenceList.open then
            Html.dd []
                [ Html.ol []
                    (List.map
                        (\reference ->
                            Html.li [] [ Html.text reference ]
                        )
                        referenceList.content
                    )
                ]

          else
            Html.text ""
        ]

    else
        []
