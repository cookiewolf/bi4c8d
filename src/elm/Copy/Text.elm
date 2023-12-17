module Copy.Text exposing (monthToString, t)

import Copy.Keys exposing (Key(..))
import Time



-- The translate function


t : Key -> String
t key =
    case key of
        SiteTitle ->
            "Bi4c8d"

        ForwardedLabel ->
            "Forwarded from: "

        Section10MessageHeading ->
            "LockBit"


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
