defmodule IconParseTest do
  use ExUnit.Case, async: true

  alias Icon.Parse

  @test_url "http://test.com"
  @html_test_com_no_icon ~s(
    <html>
    <header>
    </header>
    </html>
  )
  @html_test_com_single_icon ~s(
    <html>
    <header>
    <link rel="icon" type="image/x-icon" href="/a/favicon.ico" sizes="16x16" />
    </header>
    </html>
  )
  @html_test_com_multiple_icons ~s(
    <html>
    <header>
    <link rel="icon" type="image/x-icon" href="/a/favicon.ico" sizes="16x16" />
    <link rel="apple-touch-icon" type="png" href="/a/apple-touch-icon.png" sizes="256x256" />
    <link rel="fluid-icon" type="svg" href="/a/fluid-icon.svg" />
    </header>
    </html>
  )

  test "empty body should return an empty list" do
    assert Parse.parse("", @test_url) == []
  end

  test "should return an empty list if there is no icon" do
    assert Parse.parse(@html_test_com_no_icon, @test_url) == []
  end

  test "should parse one icon" do
    icons = Parse.parse(@html_test_com_single_icon, @test_url)

    assert length(icons) == 1

    icon = hd icons
    assert icon.href == "http://test.com/a/favicon.ico"
    assert icon.rel == "icon"
    assert icon.sizes == "16x16"
    assert icon.type == "image/x-icon"
  end

  test "should parse multiple icons" do
    icons = Parse.parse(@html_test_com_multiple_icons, @test_url)

    assert length(icons) == 3

    [icon | tail] = icons
    assert icon.href == "http://test.com/a/favicon.ico"
    assert icon.rel == "icon"
    assert icon.sizes == "16x16"
    assert icon.type == "image/x-icon"

    [icon | tail] = tail
    assert icon.href == "http://test.com/a/apple-touch-icon.png"
    assert icon.rel == "apple-touch-icon"
    assert icon.sizes == "256x256"
    assert icon.type == "png"

    [icon | []] = tail
    assert icon.href == "http://test.com/a/fluid-icon.svg"
    assert icon.rel == "fluid-icon"
    assert icon.sizes == nil
    assert icon.type == "svg"
  end
end
