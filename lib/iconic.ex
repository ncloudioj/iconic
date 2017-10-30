defmodule Iconic do
  @moduledoc """
  Application module for iconic.

  """

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

  def mget(urls, timeout \\ 5000, max_concurrency \\ 0) do
    max_concurrency = max(max_concurrency, System.schedulers_online())

    Task.Supervisor.async_stream(Icon.Fetch.Supervisor, urls, Fetch, :fetch, [],
                                 [timeout: timeout, max_concurrency: max_concurrency])
  end
end
