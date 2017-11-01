defmodule IconFetchTest do
  use ExUnit.Case, async: true

  alias Icon.Fetch

  test "it should fetch the icon on success" do
    icons = Fetch.fetch("http://test.com")

    assert length(icons) == 1

    icon = hd icons
    assert icon.href == "http://test.com/a/favicon.ico"
    assert icon.rel == "icon"
    assert icon.sizes == "16x16"
    assert icon.type == "image/x-icon"
  end

  test "it should add the scheme if it's not provided" do
    icons = Fetch.fetch("test.com")

    assert length(icons) == 1

    icon = hd icons
    assert icon.href == "http://test.com/a/favicon.ico"
    assert icon.rel == "icon"
    assert icon.sizes == "16x16"
    assert icon.type == "image/x-icon"
  end

  test "it should return an empty list on http error" do
    icons = Fetch.fetch("404.com")

    assert icons == []
  end
end
