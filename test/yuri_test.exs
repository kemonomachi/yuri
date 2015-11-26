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

  @url_parts [:authority, :fragment, :host, :path, :port, :scheme, :userinfo]

  Enum.each @url_parts, fn(part) ->
    test "get #{part}", %{uri: uri, uri_string: uri_string} do
      yuri = YURI.parse uri_string

      assert YURI.unquote(:"get_#{part}")(yuri) == uri.unquote(part)
    end

    test "set #{part}", %{uri_string: uri_string} do
      yuri = YURI.parse(uri_string) |> YURI.unquote(:"set_#{part}")(:test)

      assert YURI.unquote(:"get_#{part}")(yuri) == :test
    end
  end
end

