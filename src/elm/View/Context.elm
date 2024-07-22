module View.Context exposing (view)

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
        [ Html.ul []
            [ Html.li [] [ Html.text context.title ]
            , Html.li [] (Markdown.markdownToHtml context.context)
            , Html.li [] (Markdown.markdownToHtml context.factCheck)
            , Html.ul []
                (List.map
                    (\reference ->
                        Html.li [] [ Html.text reference ]
                    )
                    context.references
                )
            ]
        ]


sectionIdStringFromSection : Data.SectionId -> String
sectionIdStringFromSection sectionId =
    "context-" ++ Data.sectionIdToString sectionId
