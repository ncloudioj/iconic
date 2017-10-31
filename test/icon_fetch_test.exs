defmodule HTTPoisonMock do

  @body_test_com ~s(
    <html>
    <header>
    <link rel="icon" type="image/x-icon" href="/a/favicon.ico" sizes="16x16" />
    </header>
    </html>
  )

  def get("test.com") do
    {:ok, %HTTPoison.Response{body: @body_test_com, status_code: 200}}
  end

  def get(_) do
    {:error, %HTTPoison.Response{status_code: 404}}
  end
end

defmodule IconFetchTest do
  use ExUnit.Case, async: true

  @http_client Application.get_env(:iconic, :http_client)

  test "http get should return a response on success" do
    {status, %HTTPoison.Response{status_code: status_code}} = @http_client.get("test.com")

    assert status == :ok
    assert status_code == 200
  end

  test "http get should return a response on 404" do
    {status, %HTTPoison.Response{status_code: status_code}} = @http_client.get("404.com")

    assert status == :error
    assert status_code == 404
  end
end
