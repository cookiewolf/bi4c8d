module Copy.Text exposing (monthToString, t)

import Copy.Keys exposing (Key(..))
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
            "LockBit"

        HackneySocialMessageHeading ->
            "Cristina, Hackney Resident"

        TotalBreachesSinceView count ->
            String.join " "
                [ "Since you’ve been on this webpage"
                , String.fromInt count
                , "people in the UK have had their personal data compromised..."
                ]

        HelpText ->
            "These shell commands are defined internally. Type `help` to see this list."

        ErrorText command ->
            "bash: " ++ command ++ ": command not found"


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
