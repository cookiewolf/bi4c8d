module View.Messages exposing (view)

import Data
import Html
import Html.Attributes
import InView
import Markdown
import Msg exposing (Msg)
import Simple.Animation
import Simple.Animation.Animated
import Simple.Animation.Property
import Time


view : InView.State -> Data.SectionId -> List Data.Message -> String -> Maybe String -> Html.Html Msg
view inViewState sectionId messageList title maybeTranscriptLinkMarkdown =
    if List.length messageList > 0 then
        Html.div [ Html.Attributes.class "messages" ]
            [ Html.h3 [] [ Html.text title ]
            , Html.div [ Html.Attributes.class "messages-inner" ]
                (if sectionInView inViewState sectionId then
                    List.indexedMap
                        (\index message ->
                            viewMessage index
                                message
                                (isLastAtTime message messageList)
                        )
                        (Data.filterBySection sectionId messageList)
                        |> List.concat

                 else
                    []
                )
            , case maybeTranscriptLinkMarkdown of
                Just aLink ->
                    Html.p [] (Markdown.markdownToHtml aLink)

                Nothing ->
                    Html.text ""
            ]

    else
        Html.text ""


sectionInView : InView.State -> Data.SectionId -> Bool
sectionInView inViewState sectionId =
    InView.isInOrAboveView (Data.sectionIdToString sectionId) inViewState
        |> Maybe.withDefault False


isLastAtTime : Data.Message -> List Data.Message -> Bool
isLastAtTime message allMessages =
    let
        messagesSameTime =
            List.filter
                (\{ datetime } ->
                    viewMessageTime
                        datetime
                        == viewMessageTime message.datetime
                )
                allMessages
    in
    case List.head (List.reverse messagesSameTime) of
        Just aMessage ->
            message == aMessage

        Nothing ->
            False


viewMessage : Int -> Data.Message -> Bool -> List (Html.Html Msg)
viewMessage messageIndex message isLast =
    [ Html.div
        [ Html.Attributes.class "message-bubble"
        , Html.Attributes.class (Data.sideToString message.side)
        ]
        [ Simple.Animation.Animated.div
            (fadeIn (fadeInDelay messageIndex - 1200))
            [ Html.Attributes.class "typing-dots" ]
            [ viewTypingDot 1
            , viewTypingDot 2
            , viewTypingDot 3
            ]
        , Simple.Animation.Animated.div
            (fadeIn (fadeInDelay messageIndex))
            [ Html.Attributes.class "message"
            ]
            [ Html.div
                [ Html.Attributes.class "message-body"
                ]
                (Markdown.markdownToHtml message.body)
            , if isLast then
                Html.div [ Html.Attributes.class "message-time" ] [ viewMessageTime message.datetime ]

              else
                Html.text ""
            ]
        ]
    ]


fadeInDelay : Int -> Int
fadeInDelay messageIndex =
    3000 * messageIndex


expandFade : Int -> Simple.Animation.Animation
expandFade delay =
    Simple.Animation.fromTo
        { duration = 1000
        , options =
            [ Simple.Animation.loop
            , Simple.Animation.delay delay
            ]
        }
        [ Simple.Animation.Property.opacity 1
        , Simple.Animation.Property.scale 1
        ]
        [ Simple.Animation.Property.opacity 0
        , Simple.Animation.Property.scale 1.2
        ]


fadeIn : Int -> Simple.Animation.Animation
fadeIn delay =
    Simple.Animation.fromTo
        { duration = 100
        , options =
            [ Simple.Animation.delay delay
            ]
        }
        [ Simple.Animation.Property.opacity 0 ]
        [ Simple.Animation.Property.opacity 1 ]


viewTypingDot position =
    Simple.Animation.Animated.div (expandFade (position * 100))
        [ Html.Attributes.class "dot"
        , Html.Attributes.style "margin-right" "10px"
        ]
        [ Html.div
            [ Html.Attributes.class "dot"
            , Html.Attributes.style "margin-right" "8px"
            ]
            []
        ]


viewMessageTime : Time.Posix -> Html.Html Msg
viewMessageTime posix =
    Html.text
        ([ String.fromInt (Time.toHour Time.utc posix)
         , String.fromInt (Time.toMinute Time.utc posix)
         ]
            |> List.map (\timeDigit -> String.padLeft 2 '0' timeDigit)
            |> String.join ":"
        )
