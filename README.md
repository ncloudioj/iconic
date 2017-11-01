# Iconic

Fetch icon links from sites like a breeze.

## Usage

```
# get icons from one site
iex> Iconic.get("https://elixir-lang.org")

[%Icon.Parse.Icon{href: "https://elixir-lang.org/favicon.ico",
  rel: "shortcut icon", sizes: nil, type: "image/x-icon"}]

# get icons from multiple sites concurrently
iex> Enum.to_list(Iconic.mget(
["https://elixir-lang.org", "news.ycombinator.com", "https://www.reddit.com"]))

[ok: [%Icon.Parse.Icon{href: "https://elixir-lang.org/favicon.ico",
   rel: "shortcut icon", sizes: nil, type: "image/x-icon"}],
 ok: [%Icon.Parse.Icon{href: "http://news.ycombinator.comfavicon.ico",
   rel: "shortcut icon", sizes: nil, type: nil}],
 ok: [%Icon.Parse.Icon{href: "http://www.redditstatic.com/icon.png",
   rel: "icon", sizes: "256x256", type: "image/png"},
  %Icon.Parse.Icon{href: "http://www.redditstatic.com/favicon.ico",
   rel: "shortcut icon", sizes: nil, type: "image/x-icon"},
  %Icon.Parse.Icon{href: "http://www.redditstatic.com/icon-touch.png",
   rel: "apple-touch-icon-precomposed", sizes: nil, type: nil}]]

# with control options (timeout and max concurrency)
iex> Enum.to_list(Iconic.mget(
["https://elixir-lang.org", "news.ycombinator.com", "https://www.reddit.com"],
[max_concurrency: 16, timeout: 30000]))


```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `iconic` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:iconic, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/iconic](https://hexdocs.pm/iconic).

## License
Apache 2.0
