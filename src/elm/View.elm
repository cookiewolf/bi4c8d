module View exposing (viewSections)

import Data
import Html
import Html.Attributes
import Model exposing (Model)
import Msg exposing (Msg)
import View.Context
import View.Section.DataLoss
import View.Section.DisproportionateEssayEnd
import View.Section.FacialRecognition
import View.Section.HackneySocial
import View.Section.HmrcTerminal
import View.Section.HumanCost
import View.Section.IncompetenceIntro
import View.Section.IncompetencePostsAndPapers
import View.Section.Introduction
import View.Section.Outro
import View.Section.PanicLit
import View.Section.PublicOrderSafety
import View.Section.PublicTrust
import View.Section.RansomwareTerminal
import View.Section.RoyalMailNegotiation
import View.Section.SocialMediaPosts
import View.Section.Telegram
import View.Section.UlteriorMotives


sectionViews : Model -> List ( Data.SectionId, List (Html.Html Msg) )
sectionViews model =
    [ ( Data.Introduction, View.Section.Introduction.view model )
    , ( Data.SocialMediaPosts, View.Section.SocialMediaPosts.view model )
    , ( Data.PublicTrust, View.Section.PublicTrust.view model )
    , ( Data.Telegram, View.Section.Telegram.view model )
    , ( Data.UlteriorMotives, View.Section.UlteriorMotives.view model )
    , ( Data.PanicLit, View.Section.PanicLit.view model )
    , ( Data.PublicOrderSafety, View.Section.PublicOrderSafety.view model )
    , ( Data.DisproportionateEssayEnd, View.Section.DisproportionateEssayEnd.view model )
    , ( Data.FacialRecognition, View.Section.FacialRecognition.view model )
    , ( Data.IncompetenceIntro, View.Section.IncompetenceIntro.view model )
    , ( Data.IncompetencePostsAndPapers, View.Section.IncompetencePostsAndPapers.view model )
    , ( Data.HmrcTerminal, View.Section.HmrcTerminal.view model )
    , ( Data.DataLoss, View.Section.DataLoss.view model )
    , ( Data.RansomwareTerminal, View.Section.RansomwareTerminal.view model )
    , ( Data.HumanCost, View.Section.HumanCost.view model )
    , ( Data.RoyalMailNegotiation, View.Section.RoyalMailNegotiation.view model )
    , ( Data.HackneySocial, View.Section.HackneySocial.view model )
    , ( Data.Outro, View.Section.Outro.view model )
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
