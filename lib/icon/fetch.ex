defmodule Icon.Fetch do
  @moduledoc """
  Icon fetching related functions.

  """

  @http_client Application.get_env(:iconic, :http_client)

  alias Icon.Parse

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
