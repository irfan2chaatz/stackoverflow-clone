# lib/backend/llm/PopularQuestions.ex
defmodule Backend.LLM.PopularQuestions do
  @moduledoc "Fetch most popular or newest questions from Stack Overflow"
  @so_api "https://api.stackexchange.com/2.3/questions?order=desc&sort="

  def fetch_questions(sort \\ "votes", page \\ 1, page_size \\ 10) do
    url =
      @so_api <>
        "#{sort}&site=stackoverflow&page=#{page}&pagesize=#{page_size}&filter=withbody"

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
            creation_date: item["creation_date"],
            last_activity_date: item["last_activity_date"],
            owner: %{
              display_name: item["owner"]["display_name"],
              link: item["owner"]["link"]
            },
            answer_count: item["answer_count"],
            tags: item["tags"],
            is_answered: item["is_answered"],
            accepted_answer_id: item["accepted_answer_id"]
          }
        end)

      {:error, reason} ->
        IO.inspect(reason, label: "Error fetching popular questions")
        []
    end
  end
end
