module Copy.Keys exposing (Key(..))


type Key
    = SiteTitle
      -- Context
    | ContextLabel
    | ContextNewSectionMessage
    | FactCheckLabel
    | ReferencesLabel
      -- Post
    | ForwardedLabel
      -- Message
    | Section11Heading
    | Section15MessageHeading
    | Section15MessageTranscriptLink
    | Section16MessageHeading
      -- Breaches
    | TotalBreachesSinceView Int
      -- Terminal
    | HelpText
    | ErrorText String
