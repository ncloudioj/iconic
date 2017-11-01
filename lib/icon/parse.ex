defmodule Icon.Parse do
  @moduledoc """
  Icon parsing module

  """

  def parse(html, url) do
    html
    |> extract_icons
    |> Enum.map(fn icon -> resolve_href(icon, url) end)
  end

  defp extract_icons(html) do
    links = Floki.find(html, "link")

    links
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
    %{
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
