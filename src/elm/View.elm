module View exposing (viewSections)

import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.Context
import View.Section.DisproportionateEssayEnd
import View.Section.FacialRecognition
import View.Section.IncompetenceIntro
import View.Section.IncompetencePostsAndPapers
import View.Section.Introduction
import View.Section.PanicLit
import View.Section.PublicOrderSafety
import View.Section.PublicTrust
import View.Section.SocialMediaPosts
import View.Section.Telegram
import View.Section.UlteriorMotives
import View.Section12
import View.Section13
import View.Section14
import View.Section15
import View.Section16
import View.Section17


sectionViews : Model -> List ( Data.SectionId, List (Html.Html Msg) )
sectionViews model =
    [ ( Data.Introduction, View.Section.Introduction.view model )
    , ( Data.SocialMediaPosts, View.Section.SocialMediaPosts.view model )
    , ( Data.PublicTrust, View.Section.PublicTrust.view model )
    , ( Data.Telegram, View.Section.Telegram.view model )
    , ( Data.UlteriorMotives, View.Section.UlteriorMotives.view model )
    , ( Data.Telegram, View.Section.PanicLit.view model )
    , ( Data.Telegram, View.Section.PublicOrderSafety.view model )
    , ( Data.Telegram, View.Section.DisproportionateEssayEnd.view model )
    , ( Data.Telegram, View.Section.FacialRecognition.view model )
    , ( Data.Telegram, View.Section.IncompetenceIntro.view model )
    , ( Data.Telegram, View.Section.IncompetencePostsAndPapers.view model )
    , ( Data.Section12, View.Section12.view model )
    , ( Data.Section13, View.Section13.view model )
    , ( Data.Section14, View.Section14.view model )
    , ( Data.Section15, View.Section15.view model )
    , ( Data.Section16, View.Section16.view model )
    , ( Data.Section17, View.Section17.view model )
    ]


viewSections : Model -> List (Html.Html Msg)
viewSections model =
    View.Context.view model.inView model.content.context
        :: List.map
            (\( sectionId, sectionView ) ->
                Html.div
                    [ Html.Attributes.id (Data.sectionIdToString sectionId)
                    , Html.Attributes.class "section"
                    , Html.Attributes.style "min-height" (sectionHeightFromViewport model.viewportHeightWidth)
                    ]
                    sectionView
            )
            (sectionViews model)


sectionHeightFromViewport : ( Float, Float ) -> String
sectionHeightFromViewport viewportHeighWidth =
    String.fromFloat (Tuple.first viewportHeighWidth) ++ "px"
