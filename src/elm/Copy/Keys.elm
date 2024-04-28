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
    | Section11MessageTranscriptLink
      -- Breaches
    | TotalBreachesSinceView Int
      -- Terminal
    | HelpText
    | ErrorText String
