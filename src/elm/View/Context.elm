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
        |> List.partition
            (\context ->
                InView.isInView (Data.sectionIdToString context.section) inViewState
                    |> Maybe.withDefault False
            )
        |> Tuple.first
        |> List.head
        |> Maybe.map viewContextSection
        |> Maybe.withDefault (Html.text "")


viewContextSection : Data.Context -> Html.Html Msg
viewContextSection context =
    let
        toggleMsg : Data.ContextSection -> Msg
        toggleMsg =
            Msg.ToggleContext context.section
    in
    Html.div
        [ Html.Attributes.id (sectionIdStringFromSection context.section)
        , Html.Attributes.id "context"
        , Html.Attributes.class "section-active"
        ]
        [ viewContextSectionHeader context.section
        , Html.dl [ Html.Attributes.class "context-list" ]
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
            [ Html.dt [] [ viewDropdownButton (toggle Data.ContextTxt) (t ContextLabel) open ]
            , if open then
                Html.dd [ Html.Attributes.class "context-content" ] (Markdown.markdownToHtml content)

              else
                Html.text ""
            ]

        Nothing ->
            []


viewFactCheck : (Data.ContextSection -> Msg) -> Maybe (Data.ContextState String) -> List (Html.Html Msg)
viewFactCheck toggle maybeFactCheck =
    case maybeFactCheck of
        Just { content, open } ->
            [ Html.dt [] [ viewDropdownButton (toggle Data.FactCheck) (t FactCheckLabel) open ]
            , if open then
                Html.dd [ Html.Attributes.class "context-content" ] (Markdown.markdownToHtml content)

              else
                Html.text ""
            ]

        Nothing ->
            []


viewReferences : (Data.ContextSection -> Msg) -> Data.ContextState (List String) -> List (Html.Html Msg)
viewReferences toggle referenceList =
    if List.length referenceList.content > 0 then
        [ Html.dt [] [ viewDropdownButton (toggle Data.Reference) (t ReferencesLabel) referenceList.open ]
        , if referenceList.open then
            Html.dd [ Html.Attributes.class "context-content" ]
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


viewDropdownButton : Msg -> String -> Bool -> Html.Html Msg
viewDropdownButton onclick text open =
    let
        symbol =
            if open then
                "🔥"

            else
                "🎊"
    in
    Html.button
        [ Html.Attributes.class "context-button", Html.Events.onClick onclick ]
        [ Html.span [] [ Html.text text ]
        , Html.span [] [ Html.text symbol ]
        ]
