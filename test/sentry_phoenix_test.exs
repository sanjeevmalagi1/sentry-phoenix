defmodule SentryPhoenixTest do
  use ExUnit.Case
  use Plug.Test

  import Mock

  alias SentryPhoenix.Sentry.Mock

  test "does not log successful requests (2xx status)" do
    with_mock Mock, capture_message: fn _message, _opts -> :ok end do
      conn = conn(:get, "/")

      conn = SentryPhoenix.call(conn, %{})

      send_resp(conn, 200, "OK")

      assert_not_called(Mock.capture_message(:_, :_))
    end
  end

  test "log unsuccessful requests (non 2xx status)" do
    with_mock Mock, capture_message: fn _message, _opts -> :ok end do
      conn = conn(:get, "/")

      conn = SentryPhoenix.call(conn, %{})

      send_resp(conn, 400, "Something went wrong")

      assert_called(Mock.capture_message(:_, :_))
    end
  end
end
