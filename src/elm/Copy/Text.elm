module Copy.Text exposing (monthToString, t)

import Copy.Keys exposing (Key(..))
import Time



-- The translate function


t : Key -> String
t key =
    case key of
        SiteTitle ->
            "Bifurcated"

        ForwardedLabel ->
            "Forwarded from: "

        Section11Heading ->
            "Between July 2020 and June 2021, data breaches exposed financial data from 42.2 million accounts."

        Section15MessageHeading ->
            "LockBit"

        Section15MessageTranscriptLink ->
            "[LockBit message transcripts](https://lockbittranscripturi)"

        Section16MessageHeading ->
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
