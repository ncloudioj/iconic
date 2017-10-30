defmodule Iconic do

  use Application

  alias Icon.Fetch

  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Icon.Fetch.Supervisor}
    ]

    opts = [strategy: :one_for_one,
            name: Iconic.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def get(url) do
    Task.Supervisor.async(Icon.Fetch.Supervisor, Fetch, :fetch, [url])
  end

  def mget(urls) do
    Task.Supervisor.async_stream(Icon.Fetch.Supervisor, urls, Fetch, :fetch, [])
  end
end
