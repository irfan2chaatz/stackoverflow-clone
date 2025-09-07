defmodule Backend.LLM.Reranker do

  @model "cross-encoder/ms-marco-MiniLM-L-6-v2"
  @api_url "https://api-inference.huggingface.co/models/#{@model}"

  def rerank(query, answers) when is_list(answers) do
    hf_token = Application.get_env(:backend, :huggingface)[:token]
    body =
      Jason.encode!(%{
        "inputs" =>
          Enum.map(answers, fn ans ->
            %{"source_sentence" => query, "sentences" => [ans]}
          end)
      })

    headers = [
      {"Authorization", "Bearer #{hf_token}"},
      {"Content-Type", "application/json"}
    ]

    case HTTPoison.post(@api_url, body, headers,  recv_timeout: 50_000, timeout: 50_000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        decode_response(response_body, answers)

      {:ok, %HTTPoison.Response{status_code: code, body: err}} ->
        IO.puts("HF error #{code}: #{err}")
        answers

      {:error, reason} ->
        IO.puts("HF request failed: #{inspect(reason)}")
        answers
    end
  end

  defp decode_response(response_body, answers) do
    case Jason.decode(response_body) do
      {:ok, scores} when is_list(scores) ->
        answers
        |> Enum.zip(scores)
        |> Enum.sort_by(fn {_ans, score} -> -score end)
        |> Enum.map(fn {ans, _score} -> ans end)

      _ ->
        answers
    end
  end
end
