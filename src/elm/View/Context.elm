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
    Html.ul [ Html.Attributes.id "context" ] (List.map (\context -> viewContext context) contextList)


viewContext : Data.Context -> Html.Html Msg
viewContext context =
    Html.li [ Html.Attributes.id (sectionIdStringFromSection context.section) ]
        [ Html.h2 [] [ Html.text context.title ]
        , Html.dl []
            [ Html.dt [] [ Html.text (t ContextLabel) ]
            , Html.dd [] (Markdown.markdownToHtml context.context)
            , Html.dt [] [ Html.text (t FactCheckLabel) ]
            , Html.dd [] (Markdown.markdownToHtml context.factCheck)
            , Html.dt [] [ Html.text (t ReferencesLabel) ]
            , Html.dd []
                [ Html.ol []
                    (List.map
                        (\reference ->
                            Html.li [] [ Html.text reference ]
                        )
                        context.references
                    )
                ]
            ]
        ]


sectionIdStringFromSection : Data.SectionId -> String
sectionIdStringFromSection sectionId =
    "context-" ++ Data.sectionIdToString sectionId
