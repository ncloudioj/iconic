defmodule Iconic do
  @moduledoc """
  Application module for iconic, a Task based icon fetching application.

  ## Examples

      iex> Task.await(Iconic.get("www.foo.com"))
      iex> Enum.to_list(Iconic.mget(["www.foo.com", "www.bar.com", "www.baz.com"]))

  """

  use Application
  alias Icon.Fetch

  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Icon.Fetch.Supervisor}
    ]

    opts = [strategy: :one_for_one, name: Iconic.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Returns a `Task` that yields a list of `Icon.Parse.Icon.t()` when it's completed.

  ## Examples

      iex> task = Iconic.get("www.foo.com")
      iex> Task.await(task)
  """
  @spec get(String.t()) :: Task.t()
  def get(url) do
    Task.Supervisor.async(Icon.Fetch.Supervisor, Fetch, :fetch, [url])
  end

  @doc """
  Returns a `Stream` that  yields a list of `{task_status, [Icon.Parse.Icon.t()]}`
  when all the icon fetching tasks are completed.

  ## Options

    * `:max_concurrency` - sets the maximum number of tasks to run at the same
      time. Defaults to `System.schedulers_onlines/0`.
    * `:timeout` - the maximum amount of time to wait (in milliseconds) without
      receiving a task reply (across all running tasks). Defaults to `5000`.

  ## Examples

        iex> tasks = Iconic.mget(["www.foo.com", "www.bar.com", "www.baz.com"])
        iex> Enum.to_list(tasks)

  """
  @spec mget(String.t(), keyword) :: Enumerable.t()
  def mget(urls, options \\ []) do
    Task.Supervisor.async_stream(
      Icon.Fetch.Supervisor,
      urls,
      Fetch,
      :fetch,
      [],
      options
    )
  end
end
