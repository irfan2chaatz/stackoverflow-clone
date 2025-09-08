defmodule Backend.LLM.Tags do
  @so_tags_api "https://api.stackexchange.com/2.3/tags?order=desc&sort=popular&site=stackoverflow"

  def fetch_tags(page \\ 1, page_size \\ 20) do
    url = "#{@so_tags_api}&page=#{page}&pagesize=#{page_size}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Map.get("items", [])
        |> Enum.map(fn tag ->
          %{
            name: tag["name"],
            count: tag["count"]
          }
        end)

      {:error, reason} ->
        IO.inspect(reason, label: "Error fetching tags")
        []
    end
  end
end
