defmodule ExCors.AllowCorsRequests do
  import Plug.Conn

   @defaults [
      origin:      "*",
      expose:      [],
      methods:     ~w(GET POST PUT PATCH DELETE OPTIONS),
      max_age:     60 * 60 * 24,
      credentials: true,
      headers:     ~w(
        Authorization
        Content-Type
        Accept
        Origin
        User-Agent
        DNT
        Cache-Control
        X-Mx-ReqToken
        Keep-Alive
        X-Requested-With
        If-Modified-Since
        X-CSRF-Token
      ),
    ]

  def init(options),
    do: Keyword.merge(@defaults, options)

  def call(%{resp_headers: resp_headers} = conn, options) do
    conn.resp_headers
    |> put_in(resp_headers ++ headers(conn, options))
    |> process_request()
  end

  defp process_request(%Plug.Conn{method: "OPTIONS"} = conn),
    do: conn |> send_resp(204, "") |> halt()
  defp process_request(conn),
    do: conn

  defp headers(%Plug.Conn{method: "OPTIONS"} = conn, options) do
    headers(%{conn | method: nil}, options) ++ [
      {"access-control-max-age",       to_string(options[:max_age])},
      {"access-control-allow-headers", allowed_headers(options[:headers], conn)},
      {"access-control-allow-methods", Enum.join(options[:methods], ",")}
    ]
  end
  defp headers(conn, options) do
    [
      {"access-control-allow-origin",      origin(options[:origin], conn)},
      {"access-control-expose-headers",    Enum.join(options[:expose], ",")},
      {"access-control-allow-credentials", to_string(options[:credentials])}
    ]
  end

  defp allowed_headers(["*"], conn),
    do: req_header(conn, "access-control-request-headers")
  defp allowed_headers(key, _conn),
    do: Enum.join(key, ",")

  defp origin(key, conn)
  when not is_list(key),
    do: origin([key], conn)
  defp origin([:self], conn),
    do: req_header(conn, "origin") || "*"
  defp origin(["*"], _conn),
    do: "*"
  defp origin(origins, conn) do
    conn
    |> req_header("origin")
    |> maybe_origin(origins)
  end

  defp maybe_origin(true,   req_origin), do: req_origin
  defp maybe_origin(false, _req_origin), do: "null"
  defp maybe_origin(req_origin, origins) do
    origins
    |> Enum.member?(req_origin)
    |> maybe_origin(req_origin)
  end

  defp req_header(conn, name) do
    conn
    |> get_req_header(name)
    |> List.first()
  end
end
