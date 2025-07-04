module View.Posts exposing (view, viewPostDraggable)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data
import Html
import Html.Attributes
import Markdown
import Time


view : Data.SectionId -> List Data.Post -> Html.Html msg
view sectionId postList =
    if List.length postList > 0 then
        Html.div [ Html.Attributes.class "posts" ]
            (List.map
                (\post ->
                    viewPost post
                        (isFirstOnDate post postList)
                )
                (Data.filterBySection sectionId postList)
                |> List.concat
            )

    else
        Html.text ""


isFirstOnDate : Data.Post -> List Data.Post -> Bool
isFirstOnDate post allPosts =
    let
        postsSameDay =
            List.filter
                (\{ datetime } ->
                    viewPostDate
                        datetime
                        == viewPostDate post.datetime
                )
                allPosts
    in
    case List.head postsSameDay of
        Just aPost ->
            post == aPost

        Nothing ->
            False


viewPost : Data.Post -> Bool -> List (Html.Html msg)
viewPost post isFirst =
    [ Html.div [ Html.Attributes.class "post" ]
        [ if isFirst then
            Html.h3 [ Html.Attributes.class "post-date" ]
                [ viewPostDate post.datetime
                ]

          else
            Html.text ""
        , Html.div [ Html.Attributes.class "post-inner" ]
            [ Html.h4 [ Html.Attributes.class "post-forwarded-from" ] [ Html.text (t ForwardedLabel ++ post.forwardedFrom) ]
            , Html.div [ Html.Attributes.class "post-body" ]
                (viewVideo post.maybeVideo :: Markdown.markdownToHtml post.body)
            , Html.div [ Html.Attributes.class "post-meta-info" ]
                [ case post.maybeViewCount of
                    Just aViewCount ->
                        Html.span [ Html.Attributes.class "post-view-count" ] [ viewPostViewCount aViewCount ]

                    Nothing ->
                        Html.text ""
                , Html.span [ Html.Attributes.class "post-time" ] [ viewPostTime post.datetime ]
                ]
            ]
        , Html.img
            [ Html.Attributes.class "post-avatar"
            , Html.Attributes.src post.avatarSrc
            ]
            []
        ]
    ]


viewPostDraggable : Data.Post -> Html.Html msg
viewPostDraggable post =
    Html.div [ Html.Attributes.class "post-draggable" ]
        [ Html.h4 [ Html.Attributes.class "post-forwarded-from-draggable" ]
            [ Html.div [ Html.Attributes.class "post-forwarded-from" ]
                [ Html.text (t ForwardedLabel ++ post.forwardedFrom) ]
            ]
        , Html.img
            [ Html.Attributes.class "post-avatar-draggable"
            , Html.Attributes.src post.avatarSrc
            ]
            []
        , Html.div [ Html.Attributes.class "post-content-draggable" ]
            (viewVideo post.maybeVideo :: Markdown.markdownToHtml post.body)
        , Html.div [ Html.Attributes.class "post-meta-draggable" ]
            [ Html.span [ Html.Attributes.class "post-date-time-draggable" ]
                [ Html.span [] [ viewPostDate post.datetime ]
                , Html.span [] [ viewPostTime post.datetime ]
                ]
            , case post.maybeViewCount of
                Just aViewCount ->
                    Html.span
                        [ Html.Attributes.class "post-view-count-draggable" ]
                        [ viewPostViewCount aViewCount ]

                Nothing ->
                    Html.text ""
            ]
        ]


viewPostDate : Time.Posix -> Html.Html msg
viewPostDate posix =
    Html.text
        (String.join ""
            [ Copy.Text.monthToString (Time.toMonth Time.utc posix)
            , " "
            , String.fromInt (Time.toDay Time.utc posix)
            , ", "
            , String.fromInt (Time.toYear Time.utc posix)
            ]
        )


viewPostTime : Time.Posix -> Html.Html msg
viewPostTime posix =
    Html.text
        ([ String.fromInt (Time.toHour Time.utc posix)
         , String.fromInt (Time.toMinute Time.utc posix)
         ]
            |> List.map (\timeDigit -> String.padLeft 2 '0' timeDigit)
            |> String.join ":"
        )


viewPostViewCount : Int -> Html.Html msg
viewPostViewCount viewCount =
    Html.text
        (if toFloat viewCount / 1000 > 1 then
            String.fromInt (viewCount // 1000) ++ "k"

         else
            String.fromInt viewCount
        )


viewVideo : Maybe String -> Html.Html msg
viewVideo videoSrc =
    case videoSrc of
        Just aVideoSrc ->
            if String.length aVideoSrc > 0 then
                Html.div [ Html.Attributes.class "video-container" ]
                    [ Html.iframe
                        [ Html.Attributes.class "video"
                        , Html.Attributes.src aVideoSrc
                        ]
                        []
                    ]

            else
                Html.text ""

        Nothing ->
            Html.text ""
