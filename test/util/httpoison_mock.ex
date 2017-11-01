defmodule HTTPoisonMock do
  @moduledoc false

  @body_test_com ~s(
    <html>
    <header>
    <link rel="icon" type="image/x-icon" href="/a/favicon.ico" sizes="16x16" />
    </header>
    </html>
  )

  def get("http://test.com", _params, _options) do
    {:ok, %HTTPoison.Response{body: @body_test_com, status_code: 200}}
  end

  def get(_url, _params, _options) do
    {:error, %HTTPoison.Response{status_code: 404}}
  end
end
