defmodule SentryPhoenix.Sentry.Mock do
  @moduledoc """
  Mock queue.

  Designed to be used when testing your application.
  """

  @behaviour SentryPhoenix.Sentry

  def capture_message(_message, _opts) do
    {:ok, nil}
  end
end
