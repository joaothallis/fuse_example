Mix.install([:tesla, :fuse])

defmodule Server do
  use Tesla

  defp fuse_middleware(url),
    do: [
      {
        Tesla.Middleware.Fuse,
        # it's import to set a name for the fuse so if one url fails, the fuse 
        # will blow only for that url/name
        # installs fuse that will blow if there are 2 failures in 10 seconds
        # and reset after 60 more seconds
        name: url,
        opts: {{:standard, 2, 10_000}, {:reset, 60_000}},
        keep_original_error: true,
        should_melt: fn
          {:ok, %{status: status}} when status >= 300 -> true
          {:ok, _} -> false
          {:error, _} -> true
        end,
        mode: :sync
      }
    ]

  def requests do
    url_1 = "http://localhost:4000/"
    get_request(url_1)

    Process.sleep(500)

    url_2 = "http://localhost:4000/other"
    get_request(url_2)

    Process.sleep(500)

    requests()
  end

  defp get_request(url) do
    fuse_middleware(url) |> Tesla.client() |> get(url) |> IO.inspect()
  end
end

Server.requests()
