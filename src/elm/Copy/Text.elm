module Copy.Text exposing (monthToString, t)

import Copy.Keys exposing (InfoLabel(..), Key(..))
import Time



-- The translate function


t : Key -> String
t key =
    case key of
        SiteTitle ->
            "Bifurcated"

        IntroMenuItemText ->
            "Introduction"

        ContentMenuItemText ->
            "Explore content"

        ProjectInfoMenuItemText ->
            "Project information"

        ContextLabel ->
            "Context"

        ContextNewSectionMessage ->
            "Context available for "

        FactCheckLabel ->
            "Fact check"

        ReferencesLabel ->
            "References"

        ForwardedLabel ->
            "Forwarded from: "

        DataLossHeading ->
            "Between July 2020 and June 2021, data breaches exposed financial data from 42.2 million UK accounts."

        RoyalMailNegotiationMessageHeading ->
            "Lockbit/Royal Mail private transcript"

        HackneySocialMessageHeading ->
            "Cristina, Hackney Resident"

        ProfileInfoHeading ->
            "Extracted Information"

        ProfileInfoLabel label ->
            case label of
                Name boxCountTuple ->
                    labelledBoxededStrings "Name" boxCountTuple

                Job boxCountTuple ->
                    labelledBoxededStrings "Job Title" boxCountTuple

                City boxCountTuple ->
                    labelledBoxededStrings "City of Residence" boxCountTuple

                Work boxCountTuple ->
                    labelledBoxededStrings "Place of Work" boxCountTuple

                Email ( nameCount, domainCount, tld ) ->
                    "Email: "
                        ++ countToBoxString nameCount
                        ++ "@"
                        ++ countToBoxString domainCount
                        ++ "."
                        ++ tld

        TotalBreachesSinceView count ->
            String.join " "
                [ "Since you’ve been on this webpage"
                , String.fromInt count
                , "people in the UK have had their personal data compromised..."
                ]

        HelpText ->
            "Use the commands below to explore the content of this terminal. e.g. to see info, type 'info' and hit enter."

        ErrorText command ->
            "bash: " ++ command ++ ": command not found"


labelledBoxededStrings : String -> ( Int, Int ) -> String
labelledBoxededStrings label ( firstCount, lastCount ) =
    String.join " "
        [ label ++ ":"
        , countToBoxString firstCount
        , countToBoxString lastCount
        ]


countToBoxString : Int -> String
countToBoxString numberOfBoxes =
    String.repeat numberOfBoxes "█"


monthToString : Time.Month -> String
monthToString month =
    case month of
        Time.Jan ->
            "Jan"

        Time.Feb ->
            "Feb"

        Time.Mar ->
            "Mar"

        Time.Apr ->
            "Apr"

        Time.May ->
            "May"

        Time.Jun ->
            "June"

        Time.Jul ->
            "July"

        Time.Aug ->
            "Aug"

        Time.Sep ->
            "Sept"

        Time.Oct ->
            "Oct"

        Time.Nov ->
            "Nov"

        Time.Dec ->
            "Dec"
