module Copy.Text exposing (monthToString, t)

import Copy.Keys exposing (Key(..))
import Time



-- The translate function


t : Key -> String
t key =
    case key of
        SiteTitle ->
            "Bifurcated"

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
            "Between July 2020 and June 2021, data breaches exposed financial data from 42.2 million accounts."

        RoyalMailNegotiationMessageHeading ->
            "LockBit"

        RoyalMailNegotiationMessageTranscriptLink ->
            "[LockBit message transcripts](https://lockbittranscripturi)"

        HackneySocialMessageHeading ->
            "Hackney"

        TotalBreachesSinceView count ->
            String.join " "
                [ "Since you’ve been on this webpage"
                , String.fromInt count
                , "people have had their personal data compromised..."
                ]

        HelpText ->
            "These shell commands are defined internally. Type `help` to see this list."

        ErrorText command ->
            "bash: " ++ command ++ ": command not found"


monthToString : Time.Month -> String
monthToString month =
    case month of
        Time.Jan ->
            "January"

        Time.Feb ->
            "February"

        Time.Mar ->
            "March"

        Time.Apr ->
            "April"

        Time.May ->
            "May"

        Time.Jun ->
            "June"

        Time.Jul ->
            "July"

        Time.Aug ->
            "August"

        Time.Sep ->
            "September"

        Time.Oct ->
            "October"

        Time.Nov ->
            "November"

        Time.Dec ->
            "December"
