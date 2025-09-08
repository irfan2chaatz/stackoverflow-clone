defmodule Backend.LLM.Reranker do

  @api_url "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"

  def rerank(_query, []) do
    IO.puts("Warning: rerank called with empty answer list")
    []
  end

  def rerank(query, answers) when is_list(answers) and length(answers) > 0 do
    api_key = Application.get_env(:backend, :google_api_key)[:token]
    prompt = build_prompt(query, answers)

    body =
      Jason.encode!(%{
        "contents" => [
          %{
            "parts" => [%{"text" => prompt}]
          }
        ]
      })

    headers = [
      {"Content-Type", "application/json"},
      {"X-goog-api-key", api_key}
    ]

    case HTTPoison.post(@api_url, body, headers, recv_timeout: 50_000, timeout: 50_000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: resp_body}} ->
        decode_response(resp_body, answers)

      {:ok, %HTTPoison.Response{status_code: code, body: err}} ->
        IO.puts("Gemini API error #{code}: #{err}")
        answers

      {:error, reason} ->
        IO.puts("HTTP request failed: #{inspect(reason)}")
        answers
    end
  end

  defp build_prompt(query, answers) do
    numbered_answers =
      answers
      |> Enum.with_index(1)
      |> Enum.map(fn {ans, idx} ->
        """
        #{idx}. Title: #{ans.title}
           Link: #{ans.link}
           Score: #{ans.score}
           Answered?: #{ans.is_answered}
        """
      end)
      |> Enum.join("\n\n")

    """
    You are an expert assistant helping a developer find the most relevant answers.

    Query: #{query}

    Candidate answers:

    #{numbered_answers}

    Instructions:
    1. Rank the answers from most relevant to least relevant.
    2. Return only the **numbers of the ranked answers** separated by commas, e.g., 2,1,3
    3. Do not change the content of the answers.
    """
  end

  defp decode_response(response_body, original_answers) do
    case Jason.decode(response_body) do
      {:ok, %{"candidates" => [_ | _] = candidates}} ->
        text =
          get_in(candidates, [Access.at(0), "content", "parts", Access.at(0), "text"])
          |> String.trim()

        gemini_indices =
          text
          |> String.split(",", trim: true)
          |> Enum.map(&String.trim/1)
          |> Enum.filter(&(&1 =~ ~r/^\d+$/))
          |> Enum.map(&(String.to_integer(&1) - 1))

        if gemini_indices == [] do
          original_answers
        else
          Enum.map(gemini_indices, fn idx -> Enum.at(original_answers, idx) end)
        end

      _ ->
        original_answers
    end
  end
end
