defmodule Backend.LLM.Fetcher do

  @so_api "https://api.stackexchange.com/2.3/search/advanced?order=desc&sort=relevance&site=stackoverflow&q="
  @answer_api "https://api.stackexchange.com/2.3/questions/%{question_id}/answers?order=desc&sort=votes&site=stackoverflow&filter=withbody"

  # Public function to fetch questions and their answers
  def fetch_answers(query) do
    url = @so_api <> URI.encode(query)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Map.get("items", [])
        |> Enum.map(&map_question(&1))

      {:ok, %HTTPoison.Response{status_code: status}} ->
        IO.puts("Stack Overflow API returned status: #{status}")
        []

      {:error, reason} ->
        IO.inspect(reason, label: "Error fetching from Stack Overflow")
        []
    end
  end

  # Map question item and fetch its answers
  defp map_question(item) do
    answers = fetch_question_answers(item["question_id"])

    %{
      question_id: item["question_id"],
      title: item["title"],
      link: item["link"],
      score: item["score"],
      is_answered: item["is_answered"],
      answer_count: item["answer_count"],
      accepted_answer_id: item["accepted_answer_id"],
      view_count: item["view_count"],
      creation_date: item["creation_date"],
      last_activity_date: item["last_activity_date"],
      tags: item["tags"],
      owner: %{
        user_id: get_in(item, ["owner", "user_id"]),
        display_name: get_in(item, ["owner", "display_name"]),
        reputation: get_in(item, ["owner", "reputation"]),
        link: get_in(item, ["owner", "link"])
      },
      answers: answers
    }
  end

  # Fetch answers for a single question
  defp fetch_question_answers(question_id) do
    url = String.replace(@answer_api, "%{question_id}", to_string(question_id))

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Map.get("items", [])
        |> Enum.map(&map_answer(&1))

      {:ok, %HTTPoison.Response{status_code: status}} ->
        IO.puts("Error fetching answers for question #{question_id}: #{status}")
        []

      {:error, reason} ->
        IO.inspect(reason, label: "HTTP error fetching answers for question #{question_id}")
        []
    end
  end

  # Map answer item
  defp map_answer(answer) do
    %{
      answer_id: answer["answer_id"],
      body: answer["body"],           # full HTML content
      score: answer["score"],
      is_accepted: answer["is_accepted"],
      creation_date: answer["creation_date"],
      owner: %{
        user_id: get_in(answer, ["owner", "user_id"]),
        display_name: get_in(answer, ["owner", "display_name"]),
        reputation: get_in(answer, ["owner", "reputation"]),
        link: get_in(answer, ["owner", "link"])
      }
    }
  end
end
