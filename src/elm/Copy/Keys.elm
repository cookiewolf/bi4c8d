module Copy.Keys exposing (Key(..))


type Key
    = SiteTitle
      -- Intro
    | ViewContentLinkText
    | ViewIntroLinkText
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
      -- Breaches
    | TotalBreachesSinceView Int
      -- Terminal
    | HelpText
    | ErrorText String
