defmodule YURITest do
  use ExUnit.Case

  doctest Dict
  defp dict_impl, do: YURI

  setup_all do
    uri_string = "http://user:password@example.org:8080/path?foo=1&bar=2#fragment"
    uri = URI.parse uri_string

    {:ok, uri: uri, uri_string: uri_string}
  end

  test "parse string, convert to regular URI", %{uri: uri, uri_string: uri_string} do
    yuri = uri_string |> YURI.parse |> YURI.to_uri

    assert Map.delete(yuri, :query) == Map.delete(uri, :query)
    assert URI.decode_query(yuri.query) == URI.decode_query(uri.query)
  end
end

