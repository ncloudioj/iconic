defmodule Icon.Fetch do
  @moduledoc """
  Icon fetching module.

  """

  @http_client Application.get_env(:iconic, :http_client)

  alias Icon.Parse

  @doc """
  Fetch all the icons from a page

  ## Parameters

    - url: A URL string that points to the target page. A "http://" will be added
      automatically if the scheme is missing in the url

  ## Returns

    - `[Icon.Parse.Icon.t()]` if it discovered icons
    - `[]` if it failed or no icon discovered

  ## Examples

      iex> Icon.Fetch.fetch("www.foo.com")
      [%Icon.Parse.Icon{href: "http://www.foo.com/favicon.ico"}]

  """
  @spec fetch(String.t) :: [Icon.Parse.Icon.t] | []
  def fetch(url) do
    url = case Regex.match?(~r/^https?/, url) do
      true -> url
      false -> "http://#{url}"
    end

    url
    |> @http_client.get([], [follow_redirect: true])
    |> parse_response
    |> Parse.parse(url)
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body
  end

  defp parse_response(_) do
    ""
  end
end
