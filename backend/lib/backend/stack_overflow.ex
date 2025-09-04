defmodule Backend.StackOverflow do
  @so_api "https://api.stackexchange.com/2.3/search/advanced?order=desc&sort=relevance&site=stackoverflow&q="

  def fetch_answers(query) do
    url = @so_api <> URI.encode(query)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, data} = Jason.decode(body)
        # extract first 5 questions' answers (simplified)
        Enum.map(data["items"], fn item ->
          %{
            title: item["title"],
            link: item["link"],
            score: item["score"],
            tags: item["tags"]
          }
        end)

      _ ->
        []
    end
  end
end
