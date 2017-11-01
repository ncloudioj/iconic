defmodule Icon.Parse do
  @moduledoc """
  Icon parsing module.

  """

  defmodule Icon do
  @moduledoc "Icon struct"

    @type t :: %__MODULE__{href: String.t, rel: String.t, type: String.t, sizes: String.t}

    defstruct [:href, :rel, :type, :sizes]
  end

  @doc """
  Parse a html string and extract all the icons from it

  ## Parameters

    - html: String
    - url: a URL string

  ## Returns

    - `[Icon.Parse.Icon.t()]`
    - `[]` if no icon discovered

  ## Examples

      iex> Icon.Parse.parse(-s(<html><head><link rel="icon" href="a/favicon.ico" /></head></html>), "http://test.com")
      [%Icon.Parse.Icon{href: "http://test.com/a/favicon.ico", rel: "icon"}]

  """
  @spec parse(String.t, String.t) :: [Icon.t] | []
  def parse(html, url) do
    html
    |> extract_icons
    |> Enum.map(fn icon -> resolve_href(icon, url) end)
  end

  defp extract_icons(html) do
    html
    |> Floki.find("link")
    |> Enum.filter(fn {_tag, attrs, _children} -> icon_link?(attrs) end)
    |> Enum.map(fn {_tag, attrs, _children} -> attrs end)
    |> Enum.map(fn attrs -> make_icon(attrs) end)
  end

  defp icon_link?(attributes) do
    Enum.any?(attributes, fn {att, value} -> att == "rel" and String.contains?(value, "icon") end)
  end

  defp attr([{att, value} | tl], name) do
    if att == name do
      value
    else
      attr(tl, name)
    end
  end
  defp attr([], _name) do
    nil
  end

  defp make_icon(attrs) do
    %Icon{
      href: attr(attrs, "href"),
      sizes: attr(attrs, "sizes"),
      rel: attr(attrs, "rel"),
      type: attr(attrs, "type")
    }
  end

  defp resolve_href(icon, url) do
    href = icon.href

    case Regex.match?(~r/^https?/, href) do
      true -> icon
      false ->
        uri = URI.parse(href)
        case uri do
          %URI{host: nil} ->
            %{icon | href: %{URI.parse(url) | path: uri.path} |> URI.to_string}
          %URI{scheme: nil} ->
            %{icon | href: %{uri | scheme: "http"} |> URI.to_string}
          _ ->
            icon
        end
    end
  end
end
