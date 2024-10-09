defmodule SentryPhoenix do
  @moduledoc """
    A plug to capture and log status codes that are outside the 2xx range.
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    # Register a callback to be invoked before the response is sent
    register_before_send(conn, fn conn ->
      capture_request_parameters(conn)

      conn
    end)
  end

  defp capture_request_parameters(%{status: status_code} = conn)
       when status_code < 200 or status_code >= 300 do
    opts = derive_options(conn)
    message = derive_message(conn)

    sentry_client().capture_message(message, opts)
  end

  defp capture_request_parameters(_), do: nil

  defp derive_message(conn) do
    "#{conn.method} #{conn.request_path} failed with #{conn.status}"
  end

  defp derive_options(conn) do
    extra =
      %{
        args: %{
          request: %{
            headers: conn.req_headers,
            path: conn.request_path,
            method: conn.method,
            body: conn.body_params,
            query: conn.query_params,
            params: conn.params
          },
          response: %{
            headers: conn.resp_headers,
            body: conn.resp_body,
            status_code: conn.status
          }
        }
      }

    add_stacktrace_if_not_added(extra: extra)
  end

  defp current_process_stacktrace do
    case Process.info(self(), :current_stacktrace) do
      {:current_stacktrace, stacktrace} -> stacktrace
      _ -> []
    end
  end

  defp add_stacktrace_if_not_added(opts) do
    case Keyword.get(opts, :stacktrace) do
      nil ->
        opts ++ [stacktrace: current_process_stacktrace()]

      _ ->
        opts
    end
  end

  defp sentry_client() do
    Application.get_env(:sentry_phoenix, :client)
  end
end
