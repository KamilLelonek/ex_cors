defmodule ExCors.AllowCorsRequestsTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ExCors.AllowCorsRequests

  test "should all origins for a regular requests" do
    assert_headers(call(), "access-control-allow-origin", "*")
  end

  test "should overwrite default options" do
    conn = call("origin", "example.com", origin: "example.com")

    assert_headers(conn, "access-control-allow-origin", "example.com")
  end

  test "should contain all headers in OPTIONS request" do
    resp_headers     = call(:options).resp_headers
    required_headers = [
      "access-control-allow-origin",
      "access-control-expose-headers",
      "access-control-allow-credentials",
      "access-control-max-age",
      "access-control-allow-headers",
      "access-control-allow-methods"
    ]

    assert [] = required_headers -- Keyword.keys(resp_headers)
  end

  test "should return a valid origin" do
    conn = call("origin", "example1.com", origin: ["example1.com", "example2.com"])

    assert_headers(conn, "access-control-allow-origin", "example1.com")
  end

  test "should disallow an invalid origin" do
    conn = call("origin", "example2.com", origin: ["example1.com"])

    assert_headers(conn, "access-control-allow-origin", "null")
  end

  test "should return the request host when the origin is :self" do
    conn = call("origin", "example.com", origin: [:self])

    assert_headers(conn, "access-control-allow-origin", "example.com")
  end

  test "should return exposed headers" do
    conn = call(:options, expose: ["content-range", "content-length", "accept-ranges"])

    assert_headers(conn, "access-control-expose-headers", "content-range,content-length,accept-ranges")
  end

  test "should allow all incoming headers" do
    conn = call("access-control-request-headers", "custom-header,upgrade-insecure-requests", headers: ["*"])

    assert_headers(conn, "access-control-allow-headers", "custom-header,upgrade-insecure-requests")
  end

  defp call(header, value, config) do
    :get
    |> conn("/", nil)
    |> put_req_header(header, value)
    |> call_with_config(config)
  end

  defp call(method \\ :get, config \\ []),
    do: method |> conn("/") |> call_with_config(config)

  defp call_with_config(conn, config),
    do: AllowCorsRequests.call(conn, init(config))

  defp init(config),
    do: AllowCorsRequests.init(config)

  defp assert_headers(conn, header, result),
    do: Plug.Conn.get_resp_header(conn, header) == [result]
end
