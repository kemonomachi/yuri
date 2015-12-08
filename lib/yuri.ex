defmodule YURI do
  @moduledoc """
  Wrapper around the standard Elixir URI module to simplify URI manipulation.

  Provides Dict-like access to the query string and functions for accessing
  all other parts of the URI.
  """

  use Dict

  defstruct uri: %URI{}, query: %{}

  @type t :: %__MODULE__{}

  @doc """
  Create a new, empty YURI struct.
  """
  @spec new() :: t
  def new(), do: %__MODULE__{}

  @doc """
  Create a `YURI` struct from a URI `String` or a standard lib `URI` struct, and a
  dict of additional/default query parameters. Query parameters in the parsed
  URI will take precedence.
  """
  @spec parse(String.t | URI.t, Dict.t) :: t
  def parse(uri, query \\ %{}) do
    uri = URI.parse uri

    query = (uri.query || "") |> URI.decode_query |> Dict.merge(query)

    %YURI{uri: %{uri | query: nil}, query: query}
  end

  url_parts = [:authority, :fragment, :host, :path, :port, :scheme, :userinfo]

  Enum.each url_parts, fn(part) ->
    @spec unquote(:"set_#{part}")(t, term) :: t
    def unquote(:"set_#{part}")(yuri, val) do
      %{yuri | uri: %{yuri.uri | unquote(part) => val}}
    end

    @spec unquote(:"get_#{part}")(t) :: term
    def unquote(:"get_#{part}")(yuri) do
      Map.get yuri.uri, unquote(part)
    end
  end

  @doc """
  Convert a `YURI` struct to a standard lib `URI` struct.
  """
  @spec to_uri(t) :: URI.t
  def to_uri(yuri) do
    if Enum.empty? yuri.query do
      %{yuri.uri | query: nil}
    else
      %{yuri.uri | query: URI.encode_query(yuri.query)}
    end
  end

  ### Callbacks for Dict behaviour ###
  def delete(yuri, param) do
    %{yuri | query: Dict.delete(yuri.query, param)}
  end

  def fetch(yuri, param) do
    Dict.fetch yuri.query, param
  end

  def put(yuri, param, value) do
    %{yuri | query: Dict.put(yuri.query, param, value)}
  end

  def reduce(yuri, acc, fun) do
    Enumerable.reduce yuri, acc, fun
  end

  def size(yuri) do
    Dict.size yuri.query
  end

  ### Protocol implementations ###
  defimpl Enumerable, for: YURI do
    def reduce(yuri, acc, fun) do
      Enumerable.reduce yuri.query, acc, fun
    end

    def count(_yuri), do: {:error, __MODULE__}

    def member?(_yuri, _val), do: {:error, __MODULE__}
  end

  defimpl Collectable, for: YURI do
    def into(original) do
      {original.query,
       fn(query, {:cont, {param, val}}) -> Dict.put query, param, val
         (query, :done) -> %{original | query: query}
         (_, :halt) -> :ok
       end}
    end
  end

  defimpl String.Chars, for: YURI do
    def to_string(yuri) do
      query = if Enum.empty?(yuri.query) do
        nil
      else
        URI.encode_query(yuri.query)
      end

      Kernel.to_string %{yuri.uri | query: query}
    end
  end

  defimpl List.Chars, for: YURI do
    def to_char_list(yuri) do
      Kernel.to_char_list to_string %{yuri.uri | query: URI.encode_query(yuri.query)}
    end
  end
end

