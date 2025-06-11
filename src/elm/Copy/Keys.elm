module Copy.Keys exposing (InfoLabel(..), Key(..))

import Model exposing (MenuItem)


type Key
    = SiteTitle
      -- Menu
    | CurrentViewText MenuItem
    | MenuItemLinkText String
    | ContentMenuItemText
    | ProjectInfoMenuItemText
      -- Context
    | ContextLabel
    | ContextNewSectionMessage
    | FactCheckLabel
    | ReferencesLabel
      -- Post
    | ForwardedLabel
      -- Message
    | DataLossHeading
    | RoyalMailNegotiationMessageHeading
    | HackneySocialMessageHeading
      -- Profile Info
    | ProfileInfoHeading
    | ProfileInfoLabel InfoLabel
      -- Breaches
    | TotalBreachesSinceView Int
    | AdditionalTickerHeader
      -- Terminal
    | HelpText
    | ErrorText String


type InfoLabel
    = Name ( Int, Int )
    | Job ( Int, Int )
    | City ( Int, Int )
    | Work ( Int, Int )
    | Email ( Int, Int, String )
