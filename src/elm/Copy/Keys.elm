module Copy.Keys exposing (Key(..))


type Key
    = SiteTitle
      -- Post
    | ForwardedLabel
      -- Message
    | Section8Heading
    | Section10MessageHeading
    | Section10MessageTranscriptLink
    | Section11MessageHeading
      -- Breaches
    | TotalBreachesSinceView Int
      -- Terminal
    | HelpText
    | ErrorText String
