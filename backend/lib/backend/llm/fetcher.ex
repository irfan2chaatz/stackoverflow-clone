defmodule Backend.LLM.Fetcher do
  @so_api "https://api.stackexchange.com/2.3/search/advanced?order=desc&sort=relevance&site=stackoverflow&q="

  def fetch_answers(query) do
    url = @so_api <> URI.encode(query)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Map.get("items", [])
        |> Enum.map(fn item ->
          %{
            title: item["title"],
            link: item["link"],
            score: item["score"],
            is_answered: item["is_answered"]
          }
        end)

      {:ok, %HTTPoison.Response{status_code: status}} ->
        IO.puts("Stack Overflow API returned status: #{status}")
        []

      {:error, error} ->
        IO.inspect(error, label: "Error fetching from Stack Overflow")
        []
    end
  end
end
