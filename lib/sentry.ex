defmodule SentryPhoenix.Sentry do
  @callback capture_message(String.t(), list()) :: tuple()
end
