defmodule IconicTest do
  use ExUnit.Case

  test "Iconic.get() on success" do
    icons = Task.await(Iconic.get("http://test.com"))

    assert length(icons) == 1

    icon = hd(icons)
    assert icon.href == "http://test.com/a/favicon.ico"
    assert icon.rel == "icon"
    assert icon.sizes == "16x16"
    assert icon.type == "image/x-icon"
  end

  test "Iconic.get() on failure" do
    icons = Task.await(Iconic.get("http://404.com"))

    assert icons == []
  end

  test "Iconic.mget() on success" do
    tasks = Iconic.mget(["http://test.com", "http://test.com"])
    results = Enum.to_list(tasks)

    assert length(results) == 2

    [{:ok, [icon]} | results] = results
    assert icon.href == "http://test.com/a/favicon.ico"
    assert icon.rel == "icon"
    assert icon.sizes == "16x16"
    assert icon.type == "image/x-icon"

    [{:ok, [icon]} | []] = results
    assert icon.href == "http://test.com/a/favicon.ico"
    assert icon.rel == "icon"
    assert icon.sizes == "16x16"
    assert icon.type == "image/x-icon"
  end

  test "Iconic.mget() on failure" do
    tasks = Iconic.mget(["http://test.com", "http://404.com"])
    results = Enum.to_list(tasks)

    assert length(results) == 2

    [{:ok, [icon]} | results] = results
    assert icon.href == "http://test.com/a/favicon.ico"
    assert icon.rel == "icon"
    assert icon.sizes == "16x16"
    assert icon.type == "image/x-icon"

    [{:ok, icons} | []] = results
    assert icons == []
  end
end
