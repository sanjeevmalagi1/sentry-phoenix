# SentryPhoenix

Lets you log all non-successful requests to sentry

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sentry_phoenix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sentry_phoenix, github: "sanjeevmalagi1/sentry_phoenix"},
  ]
end
```

# Configuration

add configuration to specify the Sentry module
```
  config :sentry_phoenix,
    client: Sentry # Sentry module
```

# Usage

Add the plug at the controller level
```elixir
defmodule MyAppWeb.MyController do
  use MyAppWeb, :controller
  plug(SentryPhoenix, :params when action in [:index, ])
```

OR

Add the plug at a pipeline level at the router
```elixir
pipeline :log_request_sentry do
  plug :sentry_phoenix
end

scope "/" do
  pipe_through [:log_request_sentry]
  #....
  #....
end
```

P.S. This will log all the failed requests along with the request body and other details to Sentry. Make sure use Data Scrubber for any sensitive information.


