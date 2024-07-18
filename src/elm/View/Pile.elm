module View.Pile exposing (..)

import Data
import Html
import Html.Attributes
import Pile
import View.Posts


view : Pile.Data -> Html.Html msg
view data =
    case data of
        Pile.Post post ->
            View.Posts.viewPostDraggable post

        -- Html.div [] (View.Posts.viewPost post False)
        -- Html.div [ Html.Attributes.class "post-draggable" ]
        --     [ Html.h4 [ Html.Attributes.class "post-forwarded-from" ] [ Html.text (t ForwardedLabel ++ post.forwardedFrom) ]
        --     , Html.img
        --         [ Html.Attributes.class "post-avatar-draggable"
        --         , Html.Attributes.src post.avatarSrc
        --         ]
        --     , Html.div [ Html.Attributes.class "post-content-draggable" ]
        --         (View.Posts.viewVideo post.maybeVideo :: Markdown.markdownToHtml post.body)
        --     , Html.div [ Html.Attributes.class "post-meta-info" ]
        --         [ case post.maybeViewCount of
        --             Just aViewCount ->
        --                 Html.span [ Html.Attributes.class "post-view-count" ] [ viewPostViewCount aViewCount ]
        --             Nothing ->
        --                 Html.text ""
        --         , Html.span [ Html.Attributes.class "post-time" ] [ viewPostTime post.datetime ]
        --         ]
        --         []
        --     ]
        Pile.Image image ->
            viewImage image


viewImage : Data.Image -> Html.Html msg
viewImage image =
    Html.div
        [ Html.Attributes.class "image-constraint" ]
        [ Html.img
            [ Html.Attributes.src image.source
            , Html.Attributes.alt image.alt
            ]
            []
        ]
