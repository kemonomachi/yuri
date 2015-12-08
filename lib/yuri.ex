defmodule YURI do
  @moduledoc """
  Simple struct for URI representation.

  Similar to the standard lib `URI` struct, but provides Dict-like access
  to the query string.
  """

  use Dict

  defstruct authority: nil,
            scheme: nil,
            userinfo: nil,
            host: nil,
            port: nil,
            path: nil,
            fragment: nil,
            query: %{}

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

    %{uri | __struct__: __MODULE__, query: query}
  end

  @doc """
  Convert a `YURI` struct to a standard lib `URI` struct.
  """
  @spec to_uri(t) :: URI.t
  def to_uri(yuri) do
    query = if Enum.empty? yuri.query do
      nil
    else
      URI.encode_query yuri.query
    end

    %{yuri | __struct__: URI, query: query}
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

      Kernel.to_string %{yuri | __struct__: URI, query: query}
    end
  end

  defimpl List.Chars, for: YURI do
    def to_char_list(yuri) do
      Kernel.to_char_list to_string(yuri)
    end
  end
end

