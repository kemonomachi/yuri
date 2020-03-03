YURI
====

Simple struct for representing URIs.

Similar to the standard lib `URI` struct, but provides Dict-like acces
to the query string.

## Usage

Add YURI to your `mix.exs` dependencies:

```elixir
def deps do
  [{:yuri, "~> 1.0.0"}]
end
```

Download and compile:

```sh-session
$ mix deps.get

$ mix deps.compile
```

Begin URI manipulation:

```elixir
uri = YURI.parse "http://www.example.com/example?a=1"

#Or with optional Dict of query parameters:
uri = YURI.parse "http://www.example.com/example?a=1", %{"b" => 2, "c" => 3}

to_string uri
#>> "http://www.example.com/example?a=1&b=2&c=3"

uri
|> YURI.put("a", "one")
|> YURI.delete("b")
|> YURI.put("d", "IV")
|> to_string
#>> "http://www.example.com/example?a=one&c=3&d=IV"

YURI.get uri, "a"
#>> "1"

to_string {uri | path: "/example/new"}
#>> "http://www.example.com/example/new?a=1&b=2&c=3"

uri.scheme
#>> "http"
```

YURI implements the Dict behaviour, all functions in the Dict module
can be used to manipulate the query string. It also implements the
Enumerable, Collectable, String.Chars and List.Chars protocols.

Other parts of the URI can be accessed using standard struct syntax.


## License

Copyright © 2015 Ookami &lt;<ookamikenrou@gmail.com>&gt;

This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the LICENSE file or
[WTFPL homepage](http://www.wtfpl.net) for more details.

